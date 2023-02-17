import '../../../contracts/faction/stored_faction_mission.dart';
import '../../../contracts/journey/stored_journey_milestone.dart';
import '../../../contracts/redux/app_state.dart';

List<StoredJourneyMilestone> getJourneyMilestones(AppState state) =>
    state.journeyMilestoneState.storedMilestones;

List<StoredFactionMission> getFactions(AppState state) =>
    state.journeyMilestoneState.storedFactions;
