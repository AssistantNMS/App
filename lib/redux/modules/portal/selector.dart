import '../../../contracts/redux/portalState.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/portal/portalRecord.dart';

List<PortalRecord> getPortals(AppState state) =>
    state.portalState?.portals ?? PortalState.initial().portals;

List<String> getAvailableTags(AppState state) =>
    state.portalState?.availableTags ?? PortalState.initial().availableTags;
