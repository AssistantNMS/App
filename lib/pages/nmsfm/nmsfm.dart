import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AppAudio.dart';
import '../../constants/AppImage.dart';
import '../../integration/dependencyInjection.dart';
import 'nmsfmTrackList.dart';

//https://stream.zenolive.com/9kz76c8mdg8uv.aac

class NMSFMPage extends StatefulWidget {
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
      this.setState(() {
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
      padding: EdgeInsets.symmetric(horizontal: 64),
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

    bool isOnline = this._connectivityStatus != ConnectivityResult.none ||
        isiOS; // Connectivity plugin subscription to connectivity does not work on ios 🙄
    if (isOnline) {
      widgets.add(AudioStreamPresenter());
      widgets.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: positiveButton(
          title: getTranslations().fromKey(LocaleKey.viewTrackList),
          colour: getTheme().getSecondaryColour(context),
          onPress: () => getNavigation().navigateAsync(
            context,
            navigateTo: (context) => NMSFMTrackListPage(),
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
        LocalAudioPresenter(
          'Cactus Jelly Sunrise',
          'Tron Lennon',
          AppAudio.cactusJellySunrise,
        ),
      );
      widgets.add(
        LocalAudioPresenter(
          'Flux16',
          'The ByteBeat Guy',
          AppAudio.flux16,
        ),
      );
      widgets.add(
        LocalAudioPresenter(
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
      padding: EdgeInsets.only(bottom: 32),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

class AudioStreamPresenter extends StatefulWidget {
  @override
  _AudioStreamPresenterWidget createState() => _AudioStreamPresenterWidget();
}

class _AudioStreamPresenterWidget extends State<AudioStreamPresenter> {
  bool isPlaying = false;
  Metas savedMetas;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getAudioPlayer().getPlayer().current,
      builder: (context, AsyncSnapshot<Playing> asyncSnapshot) {
        final Audio current = asyncSnapshot?.data?.audio?.audio;
        bool isLoading = this.isPlaying == true && current == null;
        bool localIsPlaying = this.isPlaying;
        if (current == null) {
          localIsPlaying = false;
        }
        Metas metas = (current?.metas != null) ? current?.metas : null;
        String title = metas?.title;
        String artist = metas?.artist;

        bool metasDontMatch = metas != null &&
            savedMetas != null &&
            title != null &&
            artist != null &&
            (title != savedMetas.title || artist != savedMetas.artist);
        if (metasDontMatch) {
          var newMeta = Metas(
            title: title,
            artist: artist,
            album: getTranslations().fromKey(LocaleKey.nmsfm),
            image: savedMetas.image,
          );
          current.updateMetas(
            title: title,
            artist: artist,
          );
          setState(() {
            savedMetas = newMeta;
          });
        }

        Widget playStopWidget = localIsPlaying
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
            var stopFunction = (AssetsAudioPlayer localPlayer) {
              localPlayer.stop();
              this.setState(() {
                isPlaying = false;
              });
            };
            if (localIsPlaying) {
              stopFunction(getAudioPlayer().getPlayer());
              return;
            }
            var defaultMeta = Metas(
              title: getTranslations().fromKey(LocaleKey.nmsfm),
              artist: 'Now Streaming', // TODO Translate
              image: MetasImage.network(
                'https://app.nmsassistant.com/assets/images/special/nmsfm.png',
              ),
            );
            getAudioPlayer().getPlayer().open(
                  Audio.liveStream(
                    'https://stream.zenolive.com/9kz76c8mdg8uv.aac',
                    metas: defaultMeta,
                  ),
                  autoStart: true,
                  showNotification: true,
                  notificationSettings: NotificationSettings(
                    nextEnabled: false,
                    prevEnabled: false,
                    customStopAction: stopFunction,
                  ),
                );
            this.setState(() {
              isPlaying = true;
              savedMetas = defaultMeta;
            });
          },
        );
      },
    );
  }
}

class LocalAudioPresenter extends StatelessWidget {
  final String name;
  final String artist;
  final String localPath;
  LocalAudioPresenter(this.name, this.artist, this.localPath);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getAudioPlayer().getPlayer().isPlaying,
      builder: (context, AsyncSnapshot<bool> asyncSnapshot) {
        if (asyncSnapshot.data == null) {
          return getLoading().smallLoadingTile(context);
        }

        final bool isPlaying = asyncSnapshot.data;
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
              getAudioPlayer().getPlayer().stop();
              return;
            }
            getAudioPlayer().getPlayer().open(
                  Audio(
                    "assets/audio/$localPath",
                    metas: Metas(title: name, artist: artist),
                  ),
                  autoStart: true,
                  showNotification: true,
                );
          },
        );
      },
    );
  }
}
