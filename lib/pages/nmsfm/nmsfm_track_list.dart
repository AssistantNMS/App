import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../helpers/search_helpers.dart';
import '../../contracts/nmsfm/nmsfm_track_data.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/nmsfm_track_data_tile_presenter.dart';
import '../../integration/dependency_injection.dart';

class NMSFMTrackListPage extends StatefulWidget {
  const NMSFMTrackListPage({Key? key}) : super(key: key);

  @override
  _NMSFMTrackListPageWidget createState() => _NMSFMTrackListPageWidget();
}

class _NMSFMTrackListPageWidget extends State<NMSFMTrackListPage> {
  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.nmsfm),
      body: SearchableList<NmsfmTrackData>(
        () => getApiRepo().getNmsfmTrackList(),
        listItemDisplayer: nmsfmTrackTilePresenter,
        listItemSearch: searchNmsfm,
        addFabPadding: true,
        key: Key(getTranslations().currentLanguage),
      ),
    );
  }
}
