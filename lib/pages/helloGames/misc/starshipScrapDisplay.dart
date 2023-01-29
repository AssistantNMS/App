import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/tilePresenters/starship_reward_tile_presenter.dart';
import '../../../contracts/helloGames/starship_scrap_detailed.dart';

class StarshipScrapDisplay extends StatefulWidget {
  final List<StarshipScrapDetailed> starScraps;
  final bool displayGenericItemColour;
  const StarshipScrapDisplay({
    Key? key,
    required this.starScraps,
    required this.displayGenericItemColour,
  }) : super(key: key);

  @override
  _StarshipScrapDisplayState createState() => _StarshipScrapDisplayState();
}

class _StarshipScrapDisplayState extends State<StarshipScrapDisplay> {
  List<String> expandedItems = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = List.empty(growable: true);

    for (StarshipScrapDetailed starScrap in widget.starScraps) {
      String scrapKey = '${starScrap.shipClassType}-${starScrap.shipType}';
      bool isExpanded = expandedItems.contains(scrapKey);
      listItems.add(FlatCard(
        child: ListTile(
          leading: Stack(
            children: [
              LocalImage(
                imagePath: starshipScrapShipImage(starScrap.shipType),
                height: 100,
              ),
              Positioned(
                child: LocalImage(
                  imagePath:
                      starshipScrapShipClassImage(starScrap.shipClassType),
                  height: 30,
                ),
                bottom: -3,
                left: -3,
              ),
            ],
          ),
          title: Text(
            starshipScrapShipType(starScrap.shipType),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            starshipScrapClassType(starScrap.shipClassType) + ' class',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
          ),
          onTap: () {
            setState(() {
              if (isExpanded) {
                expandedItems.remove(scrapKey);
              } else {
                expandedItems.add(scrapKey);
              }
            });
          },
        ),
      ));
      if (isExpanded) {
        for (var itemDetail in starScrap.itemDetails) {
          listItems.add(starshipScrapTilePresenter(
            context,
            itemDetail,
            widget.displayGenericItemColour,
          ));
        }
      }
    }

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      padding: const EdgeInsets.only(bottom: 64),
      scrollController: ScrollController(),
    );
  }
}
