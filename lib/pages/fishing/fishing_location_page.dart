import 'dart:collection';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantapps_flutter_common/components/adaptive/dropdown.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/fishing_page_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/fishing/fishing_data.dart';
import '../../integration/dependency_injection.dart';

const defaultOptionValue = '...';

class FishingLocationPage extends StatelessWidget {
  FishingLocationPage({super.key}) {
    getAnalytics().trackEvent(AnalyticsEvent.fishingLocationPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.fishingLocation),
      body: CachedFutureBuilder(
          future: getFishingRepo().getAll(context),
          whileLoading: () => getLoading().fullPageLoading(context),
          whenDoneLoading: (ResultWithValue<List<FishingData>> snapshot) {
            HashSet<String> biomeHashSet = HashSet<String>();
            HashSet<String> timeHashSet = HashSet<String>();
            HashSet<String> sizeHashSet = HashSet<String>();

            if (snapshot.isSuccess) {
              for (FishingData fish in snapshot.value) {
                for (String biome in fish.biomes) {
                  biomeHashSet.add(biome);
                }
                timeHashSet.add(fish.time);
                sizeHashSet.add(fish.size);
              }
            }
            var biomeOptions = [defaultOptionValue, ...biomeHashSet]
                .map((b) => DropdownOption(b))
                .toList();
            var timeOptions = [defaultOptionValue, ...timeHashSet]
                .map((t) => DropdownOption(t))
                .toList();
            var sizeOptions = [defaultOptionValue, ...sizeHashSet]
                .map((s) => DropdownOption(s))
                .toList();

            return FishingLocationList(
              biomeOptions: biomeOptions,
              timeOptions: timeOptions,
              sizeOptions: sizeOptions,
              fishData: snapshot.isSuccess ? snapshot.value : [],
            );
          }),
    );
  }
}

class FishingLocationList extends StatefulWidget {
  final List<DropdownOption> biomeOptions;
  final List<DropdownOption> timeOptions;
  final List<DropdownOption> sizeOptions;
  final List<FishingData> fishData;
  const FishingLocationList({
    Key? key,
    required this.biomeOptions,
    required this.timeOptions,
    required this.sizeOptions,
    required this.fishData,
  }) : super(key: key);

  @override
  _FishingLocationListWidget createState() => _FishingLocationListWidget();
}

class _FishingLocationListWidget extends State<FishingLocationList> {
  String biomeSelection = defaultOptionValue;
  String timeSelection = defaultOptionValue;
  String sizeSelection = defaultOptionValue;

  Future<ResultWithValue<List<FishingData>>> getFilteredFishData() async {
    List<FishingData> filtered = [...widget.fishData];
    if (biomeSelection != defaultOptionValue) {
      filtered = filtered
          .where((f) => f.biomes
              .where((b) => b.contains(biomeSelection)) //
              .isNotEmpty)
          .toList();
    }
    if (timeSelection != defaultOptionValue) {
      filtered = filtered.where((f) => timeSelection == f.time).toList();
    }
    if (sizeSelection != defaultOptionValue) {
      filtered = filtered.where((f) => sizeSelection == f.size).toList();
    }
    return ResultWithValue<List<FishingData>>(true, filtered, '');
  }

  Widget getDropDownRow({
    String? initialValue,
    required LocaleKey title,
    required List<DropdownOption> options,
    required BoxConstraints constraints,
    required void Function(String newValue) onChanged,
  }) {
    double screenWidth = constraints.maxWidth;
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8, top: 8),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(minWidth: screenWidth * 0.15),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(getTranslations().fromKey(title)),
            ),
          ),
          Expanded(
            child: AdaptiveDropdown(
              initialValue: initialValue,
              options: options,
              onChanged: (newValue) {
                setState(() {
                  onChanged(newValue);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchableList<FishingData>(
      () => getFilteredFishData(),
      keepFirstListItemWidgetVisible: true,
      firstListItemWidget: LayoutBuilder(
        builder: (layoutCtx, BoxConstraints constraints) {
          return Column(
            children: [
              getDropDownRow(
                title: LocaleKey.biome,
                initialValue: biomeSelection,
                options: widget.biomeOptions,
                constraints: constraints,
                onChanged: (biome) {
                  biomeSelection = biome;
                },
              ),
              getDropDownRow(
                title: LocaleKey.time,
                initialValue: timeSelection,
                options: widget.timeOptions,
                constraints: constraints,
                onChanged: (time) {
                  timeSelection = time;
                },
              ),
              getDropDownRow(
                title: LocaleKey.size,
                initialValue: sizeSelection,
                options: widget.sizeOptions,
                constraints: constraints,
                onChanged: (size) {
                  sizeSelection = size;
                },
              ),
              getBaseWidget().customDivider(),
            ],
          );
        },
      ),
      listItemDisplayer: fishingDataTilePresenter,
      listItemSearch: (FishingData option, String search) =>
          option.name.toLowerCase().contains(search.toLowerCase()),
      key: Key('fishing-$biomeSelection-$timeSelection-$sizeSelection'),
      hintText: getTranslations().fromKey(LocaleKey.searchItems),
      minListForSearch: 0,
    );
  }
}
