import '../../../contracts/faction/storedFactionMission.dart';
import '../../../contracts/redux/journeyMilestoneState.dart';

import '../../../contracts/journey/storedJourneyMilestone.dart';
import '../../../contracts/redux/appState.dart';

List<StoredJourneyMilestone> getJourneyMilestones(AppState state) =>
    state?.journeyMilestoneState?.storedMilestones ??
    JourneyMilestoneState.initial().storedMilestones;

List<StoredFactionMission> getFactions(AppState state) =>
    state?.journeyMilestoneState?.storedFactions ??
    JourneyMilestoneState.initial().storedFactions;
