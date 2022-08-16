import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AppAudio.dart';
import '../../constants/AppDuration.dart';
import '../../constants/AppImage.dart';
import '../../constants/Nmsfm.dart';
import '../../contracts/misc/audioStreamBuilderEvent.dart';
import '../../contracts/nmsfm/zenoFMNowPlaying.dart';
import '../../integration/dependencyInjection.dart';
import '../../services/api/zenoFMApiService.dart';
import 'nmsfmTrackList.dart';

class NMSFMPage extends StatefulWidget {
  const NMSFMPage({Key key}) : super(key: key);

  @override
  _NMSFMPageWidget createState() => _NMSFMPageWidget();
}

class _NMSFMPageWidget extends State<NMSFMPage> {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
    widgets.add(localImage(
      AppImage.nmsfmLogo,
      padding: const EdgeInsets.symmetric(horizontal: 64),
    ));
    widgets.add(emptySpace1x());
    widgets.add(genericItemName(getTranslations().fromKey(LocaleKey.nmsfm)));
    widgets.add(genericItemDescription(
      getTranslations().fromKey(LocaleKey.nmsfmSubtitle),
    ));

    widgets.add(emptySpace1x());
    widgets.add(flatCard(
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
        child: positiveButton(
          context,
          title: getTranslations().fromKey(LocaleKey.viewTrackList),
          onPress: () => getNavigation().navigateAsync(
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
  const AudioStreamPresenter({Key key}) : super(key: key);

  @override
  _AudioStreamPresenterWidget createState() => _AudioStreamPresenterWidget();
}

class _AudioStreamPresenterWidget extends State<AudioStreamPresenter> {
  Timer _timer;
  String _title = '';
  String _artist = '';
  bool isPlaying = false;
  AudioStreamBuilderEvent savedMetas;

  _AudioStreamPresenterWidget() {
    initTimer();
  }

  initTimer() {
    if (_timer != null && _timer.isActive) _timer.cancel();
    _timer = Timer.periodic(AppDuration.zenoFMRefreshInterval, (Timer t) async {
      if (isPlaying == false) return;

      ZenoFMApiService service = ZenoFMApiService();
      ResultWithValue<ZenoFmNowPlaying> nowPlayingResult =
          await service.getNowPlaying(nmsfmId);
      if (nowPlayingResult.hasFailed) return;

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
      builder: (BuildContext context, AudioStreamBuilderEvent event) {
        bool isLoading = event.isLoading;

        String title = getTranslations().fromKey(LocaleKey.nmsfm);
        if (_title.isNotEmpty ?? false) title = _title;

        String artist = 'Now Streaming'; // TODO translate
        if (_artist.isNotEmpty ?? false) artist = _artist;

        Widget playStopWidget = (event.isPlaying)
            ? getCorrectlySizedImageFromIcon(context, Icons.stop)
            : getCorrectlySizedImageFromIcon(context, Icons.play_arrow);

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
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }
}

class LocalAudioPresenter extends StatelessWidget {
  final String name;
  final String artist;
  final String localPath;
  const LocalAudioPresenter(this.name, this.artist, this.localPath, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Key uniqueKey = Key(localPath);
    return getAudioPlayer().audioLocalBuilder(
      uniqueKey: uniqueKey,
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
              ? getCorrectlySizedImageFromIcon(context, Icons.stop)
              : getCorrectlySizedImageFromIcon(context, Icons.play_arrow),
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
