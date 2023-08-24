import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import 'audio_stream_presenter.dart';
import 'nmsfm_track_list.dart';

class NMSFMPage extends StatefulWidget {
  const NMSFMPage({Key? key}) : super(key: key);

  @override
  _NMSFMPageWidget createState() => _NMSFMPageWidget();
}

class _NMSFMPageWidget extends State<NMSFMPage> {
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

    if (!isDesktop) {
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
      widgets.add(getBaseWidget().customDivider());
    }

    widgets.add(
      externalLinkPresenter(context, 'Zeno Radio', 'https://zeno.fm/nms-fm/'),
    );

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: widgets.length,
      itemBuilder: (BuildContext innerContext, int index) => widgets[index],
      padding: const EdgeInsets.only(bottom: 32),
      scrollController: ScrollController(),
    );
  }
}
