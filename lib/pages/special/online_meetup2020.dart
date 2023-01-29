import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/app_image.dart';
import '../../constants/nms_external_urls.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/intro_view_model.dart';

class OnlineMeetup2020Page extends StatefulWidget {
  const OnlineMeetup2020Page({Key? key}) : super(key: key);

  @override
  _OnlineMeetup2020Widget createState() => _OnlineMeetup2020Widget();
}

class _OnlineMeetup2020Widget extends State<OnlineMeetup2020Page> {
  bool displayVideo = false;
  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: 'usv7wEUwpIU',
  //   params: YoutubePlayerParams(
  //     autoPlay: true,
  //     showControls: true,
  //     showFullscreenButton: true,
  //   ),
  // );

  final Widget _youtubeWidget = Container();
  _OnlineMeetup2020Widget() {
    // _youtubeWidget = YoutubePlayerIFrame(
    //   controller: _controller,
    //   aspectRatio: 16 / 9,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: 'NMS Online Meetup',
      actions: [
        ActionItem(
          icon: Icons.home,
          onPressed: () async =>
              await getNavigation().navigateHomeAsync(context),
        )
      ],
      body: StoreConnector<AppState, IntroViewModel>(
        converter: (store) => IntroViewModel.fromStore(store),
        builder: (_, introViewModel) {
          String countdown = '';
          var dateUtc = DateTime.now().toUtc();

          String onlineMeetupImage = AppImage.onlineMeetup1;

          var today = DateTime.now();
          var nmsOnlineMeetup2020Date = DateTime.utc(2020, 08, 14, 19, 0, 0);
          var forceAdvert = today.year == nmsOnlineMeetup2020Date.year &&
              today.month == nmsOnlineMeetup2020Date.month &&
              today.day == nmsOnlineMeetup2020Date.day;
          if (forceAdvert) {
            final int difference =
                nmsOnlineMeetup2020Date.difference(dateUtc).inMinutes;
            if (difference > 1) {
              countdown += (difference / 60).floor().toString() + 'h ';
              countdown += (difference % 60).floor().toString() + 'm';
              onlineMeetupImage = AppImage.onlineMeetup2;
            }
          }

          List<Widget> widgets = [
            Stack(
              children: [
                Container(
                  child: GestureDetector(
                    child: LocalImage(
                        imagePath: onlineMeetupImage, boxfit: BoxFit.fitWidth),
                    onTap: () => launchExternalURL(
                        NmsExternalUrls.proceduralTravellerYoutube),
                  ),
                  margin: const EdgeInsets.all(0),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      countdown,
                      style: const TextStyle(color: Colors.black, fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              child: genericListTileWithSubtitle(
                context,
                leadingImage: 'contributors/proceduralTraveller.jpg',
                name: 'Procedural Traveller',
                subtitle: const Text('Join the Discord Server!'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => launchExternalURL(
                    NmsExternalUrls.proceduralTravellerDiscord),
              ),
            ),
            _cardButton(
              context,
              'More Information',
              displayVideo,
              () => setState(() {
                displayVideo = !displayVideo;
              }),
            ),
            if (displayVideo) ...[
              _youtubeWidget,
            ],
            const EmptySpace1x(),
            PositiveButton(
              title: 'Continue',
              onTap: () async =>
                  await getNavigation().navigateHomeAsync(context),
            ),
            if (!forceAdvert) ...[
              NegativeButton(
                title: getTranslations().fromKey(LocaleKey.noticeReject),
                onTap: () async {
                  // introViewModel.hideOnlineMeetup2020();
                  await getNavigation().navigateHomeAsync(context);
                },
              ),
            ],
            const EmptySpace3x(),
          ];
          return listWithScrollbar(
            shrinkWrap: true,
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int index) => widgets[index],
            scrollController: ScrollController(),
          );
        },
      ),
    );
  }

  Widget _cardButton(
    BuildContext context,
    String title,
    bool isOpen,
    void Function()? onTap,
  ) {
    return GestureDetector(
      child: Padding(
        child: Stack(
          children: [
            Card(
              child: Padding(
                child: Center(
                  child: Text(title),
                ),
                padding: const EdgeInsets.all(16),
              ),
              color: getTheme().getPrimaryColour(context),
              margin: const EdgeInsets.all(0),
            ),
            Positioned(
              child: Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              top: 0,
              right: 8,
              bottom: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 8),
      ),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    // _controller.close();
    super.dispose();
  }
}
