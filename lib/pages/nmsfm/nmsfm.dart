import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/app_audio.dart';
import '../../constants/app_duration.dart';
import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../constants/nmsfm.dart';
import '../../contracts/misc/audio_stream_builder_event.dart';
import '../../contracts/nmsfm/zeno_fm_now_playing.dart';
import '../../integration/dependency_injection.dart';
import '../../services/api/zeno_fm_api_service.dart';
import 'nmsfm_track_list.dart';

class NMSFMPage extends StatefulWidget {
  const NMSFMPage({Key? key}) : super(key: key);

  @override
  _NMSFMPageWidget createState() => _NMSFMPageWidget();
}

class _NMSFMPageWidget extends State<NMSFMPage> {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  _isOnline() {
    return _connectivityStatus != ConnectivityResult.none ||
        isiOS; // Connectivity plugin subscription to connectivity does not work on ios 🙄
  }

  @override
  initState() {
    super.initState();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _connectivityStatus = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.nmsfm),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(const EmptySpace2x());
    widgets.add(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 350),
          child: LocalImage(
            imagePath: AppImage.nmsfmLogo,
            borderRadius: NMSUIConstants.generalBorderRadius,
            padding: const EdgeInsets.symmetric(horizontal: 64),
          ),
        ),
      ),
    );
    widgets.add(const EmptySpace1x());
    widgets.add(GenericItemName(getTranslations().fromKey(LocaleKey.nmsfm)));
    widgets.add(GenericItemDescription(
      getTranslations().fromKey(LocaleKey.nmsfmSubtitle),
    ));

    widgets.add(const EmptySpace1x());
    widgets.add(FlatCard(
      child: veritasVelezTile(
        context,
        subtitle: getTranslations().fromKey(LocaleKey.nmsfmCreator),
      ),
    ));

    bool isOnline = _isOnline();

    if (isOnline && !isDesktop) {
      widgets.add(const AudioStreamPresenter());
      widgets.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: PositiveButton(
          title: getTranslations().fromKey(LocaleKey.viewTrackList),
          onTap: () => getNavigation().navigateAsync(
            context,
            navigateTo: (context) => const NMSFMTrackListPage(),
          ),
        ),
      ));
      widgets.add(customDivider());
    }

    widgets.add(
      externalLinkPresenter(context, 'Zeno Radio', 'https://zeno.fm/nms-fm/'),
    );

    if (!isOnline) {
      widgets.add(customDivider());
      widgets.add(
        const LocalAudioPresenter(
          'Cactus Jelly Sunrise',
          'Tron Lennon',
          AppAudio.cactusJellySunrise,
        ),
      );
      widgets.add(
        const LocalAudioPresenter(
          'Flux16',
          'The ByteBeat Guy',
          AppAudio.flux16,
        ),
      );
      widgets.add(
        const LocalAudioPresenter(
          'Oranges',
          'VeritasVelez',
          AppAudio.oranges,
        ),
      );
    }

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: widgets.length,
      itemBuilder: (BuildContext innerContext, int index) => widgets[index],
      padding: const EdgeInsets.only(bottom: 32),
      scrollController: ScrollController(),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    // getAudioPlayer().stop();
    // getAudioPlayer().dispose();
    super.dispose();
  }
}

class AudioStreamPresenter extends StatefulWidget {
  const AudioStreamPresenter({Key? key}) : super(key: key);

  @override
  _AudioStreamPresenterWidget createState() => _AudioStreamPresenterWidget();
}

class _AudioStreamPresenterWidget extends State<AudioStreamPresenter> {
  late Timer _timer;
  String _title = '';
  String _artist = '';
  bool isPlaying = false;

  _AudioStreamPresenterWidget() {
    initTimer();
  }

  initTimer() {
    // ignore: unnecessary_null_comparison
    if (_timer != null && _timer.isActive) _timer.cancel();
    _timer = Timer.periodic(AppDuration.zenoFMRefreshInterval, (Timer t) async {
      if (isPlaying == false) return;

      ZenoFMApiService service = ZenoFMApiService();
      ResultWithValue<ZenoFmNowPlaying> nowPlayingResult =
          await service.getNowPlaying(nmsfmId);
      if (nowPlayingResult.hasFailed) {
        getLog().i('nowPlayingResult failed');
        return;
      }

      setState(() {
        _title = nowPlayingResult.value.title;
        _artist = nowPlayingResult.value.artist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return getAudioPlayer().audioStreamBuilder(
      uniqueKey: const Key('Streaming'),
      playerContext: context,
      builder: (BuildContext context, AudioStreamBuilderEvent event) {
        bool isLoading = event.isLoading;

        String title = getTranslations().fromKey(LocaleKey.nmsfm);
        if (_title.isNotEmpty) title = _title;

        String artist = 'Now Streaming'; // TODO translate
        getLog().i('_artist: ' + _artist);
        if (_artist.isNotEmpty) artist = _artist;

        Widget playStopWidget = (event.isPlaying)
            ? const CorrectlySizedImageFromIcon(icon: Icons.stop)
            : const CorrectlySizedImageFromIcon(icon: Icons.play_arrow);

        return ListTile(
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(artist, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: isLoading
              ? getLoading().smallLoadingIndicator() //
              : playStopWidget,
          onTap: () {
            void Function() stopFunction;
            stopFunction = () {
              getAudioPlayer().stop();
              setState(() {
                isPlaying = false;
              });
            };
            if (event.isPlaying) {
              stopFunction();
              return;
            }
            getAudioPlayer().openUrl(
              ZenoFMUrlTemplate.streamUrl.replaceAll('{0}', nmsfmId),
              AudioStreamOpenUrlModel(
                title: title,
                artist: artist,
                image: AppImage.nmsfm,
              ),
            );
            setState(() {
              isPlaying = true;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }
}

class LocalAudioPresenter extends StatelessWidget {
  final String name;
  final String artist;
  final String localPath;
  const LocalAudioPresenter(this.name, this.artist, this.localPath, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Key uniqueKey = Key(localPath);
    return getAudioPlayer().audioLocalBuilder(
      uniqueKey: uniqueKey,
      playerContext: context,
      builder: (BuildContext context, AudioStreamBuilderEvent event) {
        bool isPlaying = event.isPlaying;

        if (event.isLoading) {
          return getLoading().smallLoadingTile(context);
        }

        return ListTile(
          title: Text(
            name + ' (Sample)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isPlaying
              ? const CorrectlySizedImageFromIcon(icon: Icons.stop)
              : const CorrectlySizedImageFromIcon(icon: Icons.play_arrow),
          onTap: () {
            if (isPlaying) {
              getAudioPlayer().stop();
              return;
            }
            getAudioPlayer().openLocal(
              'assets/audio/$localPath',
              uniqueKey,
              AudioStreamOpenUrlModel(title: name, artist: artist),
            );
          },
        );
      },
    );
  }
}
