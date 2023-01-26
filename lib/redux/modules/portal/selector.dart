import '../../../contracts/portal/portalRecord.dart';
import '../../../contracts/redux/appState.dart';

List<PortalRecord> getPortals(AppState state) => state.portalState.portals;

List<String> getAvailableTags(AppState state) =>
    state.portalState.availableTags;
