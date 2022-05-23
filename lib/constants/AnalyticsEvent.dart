class AnalyticsEvent {
  static const String unknown = 'Unknown';
  static const String appLoad = 'App_Load';
  static const String homeView = 'Home_Page_View';
  static const String darkMode = 'DarkMode';
  static const String lightMode = 'LightMode';
  //_AdMob
  static const String addMobDonationPage = 'Donation_Ad_View';
  static const String addMobDonationPageClose = 'Donation_Ad_Close';
  static const String addMobDonationPageClick = 'Donation_Ad_Click';
  static const String addMobDonationPageClickBeforeReady =
      'Donation_Ad_Click_before_the_ad_has_loaded';
  static const String addMobDonationPageFailedToLoad =
      'Donation_Ad_failed_to_load';
  //pages
  static const String aboutPage = 'About_Page_View';
  static const String rawMaterialPage = 'RawMaterial_Page_View';
  static const String productsPage = 'Product_Page_View';
  static const String curiositiesPage = 'Curiosity_Page_View';
  static const String genericPage = 'Generic_Page_View';
  static const String genericSearchPage = 'Generic_Search_Page_View';
  static const String genericAllRequiredRawMaterialsPage =
      'Generic_Page_with_all_of_the_RawMaterials_View';
  static const String genericPageRefinerRecipe =
      'Generic_Refiner_Recipe_Page_View';
  static const String allPossibleOutputsPage = 'All_Possible_Outputs_Page_View';
  static const String donationPage = 'Donation_Page_Page_View';
  static const String refinerRecipePage = 'Refiner_Recipe_Page_View';
  static const String languageHelpPage = 'Language_Help_Page_View';
  static const String cartPage = 'Cart_Page_View';
  static const String cookingPage = 'Cooking_Page_View';
  static const String nutrientProcessorRecipePage =
      'Nutrient_Processor_Recipe_Page_View';
  static const String exploitPage = 'Exploit_Page_View';
  static const String exploitDetailsPage = 'Exploit_Details_Page_View';
  static const String buildingsPage = 'Buildings_Page_View';
  static const String portalPage = 'Portal_Page_View';
  static const String addPortalPage = 'Add_Portal_Page_View';
  static const String viewPortalPage = 'View_Portal_Page_View';
  static const String advancedSeachPage = 'Advanced_Search_Page_View';
  static const String guidePage = 'Guide_Page_View';
  static const String guideDetailsPage = 'Guide_Details_Page_View';
  static const String settingsPage = 'Settings_Page_View';
  static const String appleMenuPage = 'Apple_Menu_Page_View';
  static const String releasesPage = 'Releases_Page_View';
  static const String helloGamesPage = 'HelloGames_Page_View';
  static const String newsPage = 'News_Page_View';
  static const String processorRecipePage = 'Processor_Recipe_Page_View';
  static const String contributorsPage = 'Contributors_Page_View';
  static const String communityMissionPage = 'Community_Mission_Page_View';
  static const String imageViewerPage = 'Image_Viewer_Page_View';
  static const String whatIsNewPage = "What_Is_New_Page_View";
  static const String whatIsNewDetailPage = "What_Is_New_Detail_Page_View";
  static const String communityLinkPage = "Community_Links_Page_View";
  static const String socialPage = "Social_Links_Page_View";
  static const String feedbackPage = "Feedback_Page_View";
  static const String updateNewItemPage = "New_Items_From_Update_Page_View";
  static const String unlockableTechTreePage = "Unlockable_Tech_Tree_Page_View";
  static const String inventoryListPage = "Inventory_List_Page_View";
  static const String viewInventoryPage = "View_Inventory_Page_View";
  static const String addInventorySlotPage = "Add_Inventory_Slot_Page_View";
  static const String searchInventorySlotPage =
      "Search_Inventory_Slot_Page_View";
  static const String favouritesPage = "Favourites_Page_View";
  static const String syncPage = "Sync_Page_View";
  static const String timerPage = "Timer_Page_View";
  static const String retiredDrawerMenuPage = "Retired_Drawer_Menu_Page_View";
  static const String solarPanelCalcPage = "SolarPower_Calc_Page_View";
  static const String friendCodeListPage = "FriendCode_List_Page_View";
  static const String addFriendCodeListPage = "Add_FriendCode_List_Page_View";
  static const String onlineMeetup2020SubmissionsListPage =
      "OnlineMeetup_2020_Submissions_List_Page_View";
  static const String patronListPage = "Patron_List_Page_View";
  static const String weekendMissionSeason2Page =
      "Weekend_Mission_Season2_Page_View";
  static const String weekendMissionSeason3Page =
      "Weekend_Mission_Season3_Page_View";
  static const String communitySpotlightPage = "Community_Spotlight_Page_View";
  static const String customHomepage = "Custom_Home_Page_View";
  static const String titlePage = "Title_Page_View";
  static const String alienPuzzlesListPage = "Alien_List_Page_View";
  static const String alienPuzzlesMenuPage = "Alien_Menu_Page_View";
  static const String alienPuzzlesDetailPage = "Alien_Detail_Page_View";
  static const String alienPuzzlesRewardDetailPage =
      "Alien_Reward_Detail_Page_View";
  static const String seasonalExpeditionListPage =
      "Seasonal_Expedition_List_Page_View";
  static const String journeyMilestonesPage = "Journey_Milestones_Page_View";
  static const String factionPage = "Faction_Page_View";
  static const String guildMissionsPage = "Guild_Missions_Page_View";
  static const String twitchCampaignPage = "Twitch_Campaigns_Page_View";
  static const String starshipScrapPagePage = "Starship_Scrap_Page_View";
  //user_events
  static const String addToCartFromHome = 'Added_item_to_cart_from_Home_Page';
  static const String exploitItemClick = 'Exploit_item_Click';
  static const String patreonOAuthLogin = 'Patreon_OAuth_Login';
  //json
  static const String loadRawMaterialJson = 'Loaded_RawMaterials.json';
  static const String loadProductJson = 'Loaded_Products.json';
  static const String loadTradeItemsJson = 'Loaded_TradeItems.json';
  static const String loadOtherItemsJson = 'Loaded_OtherItems.json';
  static const String loadCuriosityJson = 'Loaded_Curiosity.json';
  static const String loadTechnologyJson = 'Loaded_Technology.json';
  static const String loadRefineryJson = 'Loaded_Refinery.json';
  //external
  static const String externalLinkCVWebsite = 'CV_Website';
  static const String externalLinkPersonalBlog = 'Personal_Blog';
  static const String externalLinkBuyMeACoffee = 'BuyMeACoffee';
  static const String externalLinkPayPal = 'PayPal';
  static const String externalLinkPatreon = 'Patreon';
  static const String externalLinkkofi = 'Ko-fi';
  static const String externalLinkKurtLourensEmail = 'Email_hi@kurtlourens.com';
  static const String externalLinkGitHubGeneral = 'Go_to_General_Repository';
  static const String externalLinkGitHubLanguage = 'Go_to_Language_Repository';
  static const String externalLinkBat = 'BraveRewards';
  static const String externalLinkOpenCollective = 'OpenCollective';
}
