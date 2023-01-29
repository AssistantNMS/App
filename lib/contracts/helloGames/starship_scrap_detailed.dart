class StarshipScrapDetailed {
  StarshipScrapDetailed({
    required this.shipType,
    required this.shipClassType,
    required this.itemDetails,
  });

  String shipType;
  String shipClassType;
  List<StarshipScrapDetailedItemDetail> itemDetails;
}

class StarshipScrapDetailedItemDetail {
  StarshipScrapDetailedItemDetail({
    required this.id,
    required this.icon,
    required this.name,
    this.colour,
    required this.percentageChance,
    required this.amountMin,
    required this.amountMax,
  });

  String id;
  String icon;
  String name;
  String? colour;
  double percentageChance;
  int amountMin;
  int amountMax;
}
