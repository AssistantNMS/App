import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AppAudio.dart';
import '../../constants/AppImage.dart';
import '../../contracts/misc/audioStreamBuilderEvent.dart';
import '../../integration/dependencyInjection.dart';
import 'nmsfmTrackList.dart';

class NMSFMPage extends StatefulWidget {
  const NMSFMPage({Key key}) : super(key: key);

  @override
  _NMSFMPageWidget createState() => _NMSFMPageWidget();
}

class _NMSFMPageWidget extends State<NMSFMPage> {
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
        child: veritasVelezTile(context,
            subtitle: getTranslations().fromKey(LocaleKey.nmsfmCreator))));

    bool isOnline = _connectivityStatus != ConnectivityResult.none ||
        isiOS; // Connectivity plugin subscription to connectivity does not work on ios 🙄
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

    if (!isOnline || isDesktop) {
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
    super.dispose();
  }
}

class AudioStreamPresenter extends StatefulWidget {
  const AudioStreamPresenter({Key key}) : super(key: key);

  @override
  _AudioStreamPresenterWidget createState() => _AudioStreamPresenterWidget();
}

class _AudioStreamPresenterWidget extends State<AudioStreamPresenter> {
  bool isPlaying = false;
  AudioStreamBuilderEvent savedMetas;

  @override
  Widget build(BuildContext context) {
    return getAudioPlayer().audioStreamBuilder(
        builder: (BuildContext context, AudioStreamBuilderEvent event) {
      bool isLoading = event.isLoading;

      String title = event.title;
      String artist = event.artist;

      bool metasDontMatch = savedMetas != null &&
          title != null &&
          artist != null &&
          (title != savedMetas.title || artist != savedMetas.artist);
      if (metasDontMatch) {
        AudioStreamBuilderEvent newMeta = AudioStreamBuilderEvent(
          title: title,
          artist: artist,
          album: getTranslations().fromKey(LocaleKey.nmsfm),
          image: savedMetas.image,
        );
        setState(() {
          savedMetas = newMeta;
        });
      }

      Widget playStopWidget = isPlaying
          ? getCorrectlySizedImageFromIcon(context, Icons.stop)
          : getCorrectlySizedImageFromIcon(context, Icons.play_arrow);

      return ListTile(
        title: Text(
          title ?? getTranslations().fromKey(LocaleKey.nmsfm),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          artist ?? 'Start listening now!', //TODO Translate
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing:
            isLoading ? getLoading().smallLoadingIndicator() : playStopWidget,
        onTap: () {
          void Function() stopFunction;
          stopFunction = () {
            getAudioPlayer().stop();
            setState(() {
              isPlaying = false;
            });
          };
          if (isPlaying) {
            stopFunction();
            return;
          }
          AudioStreamBuilderEvent defaultMeta = AudioStreamBuilderEvent(
            title: getTranslations().fromKey(LocaleKey.nmsfm),
            artist: 'Now Streaming', // TODO Translate
            image:
                'https://app.nmsassistant.com/assets/images/special/nmsfm.png',
          );
          getAudioPlayer().openUrl(
            'https://stream.zenolive.com/9kz76c8mdg8uv.aac',
            AudioStreamOpenUrlModel(title: title, artist: artist),
          );
          setState(() {
            isPlaying = true;
            savedMetas = defaultMeta;
          });
        },
      );
    });
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
    return getAudioPlayer().audioStreamBuilder(
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
              AudioStreamOpenUrlModel(title: name, artist: artist),
            );
          },
        );
      },
    );
  }
}
