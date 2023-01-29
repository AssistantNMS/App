import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/components/common/row_helper.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/app_image.dart';
import '../../contracts/faction/guild_mission.dart';

class GuildMissionDetailPage extends StatefulWidget {
  final GuildMission mission;
  const GuildMissionDetailPage(this.mission, {Key? key}) : super(key: key);
  @override
  _GuildMissionDetailPageWidget createState() =>
      _GuildMissionDetailPageWidget();
}

class _GuildMissionDetailPageWidget extends State<GuildMissionDetailPage> {
  int titleIndex = 0;
  int descripIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> titles = widget.mission.titles;
    if (titles.isEmpty) {
      titles = widget.mission.subtitles;
    }
    List<Widget Function(BuildContext t)> widgets = List.empty(growable: true);

    widgets.add(
      (_) => LocalImage(
        imagePath: widget.mission.icon,
        imageHero: widget.mission.icon + widget.mission.id,
        height: 100,
        width: 100,
      ),
    );
    widgets.add((_) => const EmptySpace1x());

    widgets.add((_) => GenericItemName(titles[titleIndex]));
    if (titles.length > 1) {
      widgets.add(
        (_) => GenericItemDescription(
          (titleIndex + 1).toString() + " / " + titles.length.toString(),
          maxLines: 20,
        ),
      );
      widgets.add(
        (_) => rowWith2Columns(
          PositiveButton(
            title: '<',
            padding: const EdgeInsets.symmetric(vertical: 8),
            onTap: () {
              if (titleIndex < 1) return;
              setState(() {
                titleIndex--;
              });
            },
          ),
          PositiveButton(
            title: '>',
            padding: const EdgeInsets.symmetric(vertical: 8),
            onTap: () {
              if (titleIndex >= (titles.length - 1)) {
                return;
              }
              setState(() {
                titleIndex++;
              });
            },
          ),
        ),
      );
    }
    widgets.add((_) => const EmptySpace1x());
    widgets.add((_) => customDivider());
    widgets.add((_) => const EmptySpace1x());

    widgets.add(
      (_) => GenericItemDescription(widget.mission.descriptions[descripIndex]),
    );
    widgets.add(
      (_) => GenericItemDescription(
        (descripIndex + 1).toString() +
            " / " +
            widget.mission.descriptions.length.toString(),
      ),
    );
    widgets.add(
      (_) => rowWith2Columns(
        PositiveButton(
          title: '<',
          padding: const EdgeInsets.symmetric(vertical: 8),
          onTap: () {
            if (descripIndex < 1) return;
            setState(() {
              descripIndex--;
            });
          },
        ),
        PositiveButton(
          title: '>',
          padding: const EdgeInsets.symmetric(vertical: 8),
          onTap: () {
            if (descripIndex >= (widget.mission.descriptions.length - 1)) {
              return;
            }
            setState(() {
              descripIndex++;
            });
          },
        ),
      ),
    );
    List<String> factionImgs = List.empty(growable: true);
    if (widget.mission.factions.contains('ExplorerGuild')) {
      factionImgs.add(AppImage.expFaction);
    }
    if (widget.mission.factions.contains('TradeGuild')) {
      factionImgs.add(AppImage.traFaction);
    }
    if (widget.mission.factions.contains('WarriorGuild')) {
      factionImgs.add(AppImage.warFaction);
    }
    widgets.add((_) => const EmptySpace1x());
    widgets.add((_) => customDivider());
    widgets.add((_) => const EmptySpace1x());
    widgets.add(
      (_) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: factionImgs
            .map(
              (img) => LocalImage(
                imagePath: img,
                imageHero: img + widget.mission.id,
                height: 50,
                width: 50,
              ),
            )
            .toList(),
      ),
    );

    widgets.add((_) => const EmptySpace8x());

    return simpleGenericPageScaffold(
      context,
      title: widget.mission.objective,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (listCtx, index) => widgets[index](listCtx),
        scrollController: ScrollController(),
      ),
    );
  }
}
