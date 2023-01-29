class PatreonEarlyAccessFeature {
  static DateTime manufacturingPuzzleAvailableFrom = DateTime(2020, 12, 3);
  static DateTime upgradeModuleStatsAvailableFrom = DateTime(2021, 2, 19);
  static DateTime eggTraitsAvailableFrom = DateTime(2021, 3, 10);
  static DateTime milestonePatchesAvailableFrom = DateTime(2021, 5, 10);
  static DateTime developerPropertiesAvailableFrom = DateTime(2021, 6, 31);
  static DateTime journeyMilestonesAvailableFrom = DateTime(2021, 10, 2);
  static DateTime season3Expedition = DateTime(2021, 9, 18);
  static DateTime newMilestonesPage = DateTime(2022, 4, 1);
  static DateTime newMajorUpdatesPage = DateTime(2022, 6, 18);
  static DateTime syncInventoryPage = DateTime(2022, 12, 24);
}

bool isPatreonFeatureLocked(DateTime unlockDate, bool isPatron) {
  if (isPatron) return false;
  if (DateTime.now().isAfter(unlockDate)) return false;

  return true;
}
