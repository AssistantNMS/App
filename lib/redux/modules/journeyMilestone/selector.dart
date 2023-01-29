import '../../../contracts/faction/stored_faction_mission.dart';
import '../../../contracts/journey/storedJourneyMilestone.dart';
import '../../../contracts/redux/appState.dart';

List<StoredJourneyMilestone> getJourneyMilestones(AppState state) =>
    state.journeyMilestoneState.storedMilestones;

List<StoredFactionMission> getFactions(AppState state) =>
    state.journeyMilestoneState.storedFactions;
