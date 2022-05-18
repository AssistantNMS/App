class StarshipScrapDetailed {
  StarshipScrapDetailed({
    this.shipType,
    this.shipClassType,
    this.itemDetails,
  });

  String shipType;
  String shipClassType;
  List<StarshipScrapDetailedItemDetail> itemDetails;
}

class StarshipScrapDetailedItemDetail {
  StarshipScrapDetailedItemDetail({
    this.id,
    this.icon,
    this.name,
    this.colour,
    this.percentageChance,
    this.amountMin,
    this.amountMax,
  });

  String id;
  String icon;
  String name;
  String colour;
  double percentageChance;
  int amountMin;
  int amountMax;
}
