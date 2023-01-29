import 'package:redux/redux.dart';

import '../../../contracts/portal/portalRecord.dart';
import '../../../contracts/redux/appState.dart';
import '../setting/actions.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class PortalViewModel {
  List<PortalRecord> portals;
  List<String> availableTags;
  final bool useAltGlyphs;

  Function(String name, List<int> codes, List<String> tags) addPortal;
  Function(String name, List<int> codes, List<String> tags, String uuid)
      editPortal;
  Function(String uuid) removePortal;
  Function() removeAllPortals;
  Function(String tage) addTag;
  Function(String tag) removeTag;
  Function() toggleAltGlyphs;

  PortalViewModel({
    required this.portals,
    required this.addPortal,
    required this.editPortal,
    required this.removePortal,
    required this.availableTags,
    required this.removeAllPortals,
    required this.useAltGlyphs,
    required this.addTag,
    required this.removeTag,
    required this.toggleAltGlyphs,
  });

  static PortalViewModel fromStore(Store<AppState> store) {
    return PortalViewModel(
      portals: getPortals(store.state),
      availableTags: getAvailableTags(store.state),
      useAltGlyphs: getUseAltGlyphs(store.state),
      addPortal: (String name, List<int> codes, List<String> tags) =>
          store.dispatch(AddPortalAction(
              PortalRecord(name: name, codes: codes, tags: tags))),
      editPortal: (String name, List<int> codes, List<String> tags,
              String uuid) =>
          store.dispatch(EditPortalAction(
              PortalRecord(name: name, codes: codes, tags: tags, uuid: uuid))),
      removePortal: (String uuid) => store.dispatch(RemovePortalAction(uuid)),
      removeAllPortals: () => store.dispatch(RemoveAllPortalsAction()),
      addTag: (String tag) => store.dispatch(AddPortalTagAction(tag)),
      removeTag: (String tag) => store.dispatch(RemovePortalTagAction(tag)),
      toggleAltGlyphs: () => store.dispatch(ToggleAltGlyphs()),
    );
  }
}
