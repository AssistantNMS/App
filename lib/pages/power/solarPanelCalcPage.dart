import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../helpers/itemsHelper.dart';
import 'solarPanelCalcComponents.dart';
import 'solarPanelCalcHelper.dart';

final String _solarPanelId = 'conTech50';
final String _batteryId = 'conTech57';

class SolarPanelCalcPage extends StatefulWidget {
  const SolarPanelCalcPage({Key key}) : super(key: key);

  @override
  _SolarPanelCalcWidget createState() => _SolarPanelCalcWidget();
}

class _SolarPanelCalcWidget extends State<SolarPanelCalcPage> {
  _SolarPanelCalcWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.solarPanelCalcPage);
  }

  Future<List<RequiredItemDetails>> requiredItemDetailsFuture(
      BuildContext context) async {
    Future<ResultWithValue<RequiredItemDetails>> solarPnlTask =
        requiredItemDetails(
            context, RequiredItem(id: _solarPanelId, quantity: 1));
    Future<ResultWithValue<RequiredItemDetails>> batteryTask =
        requiredItemDetails(context, RequiredItem(id: _batteryId, quantity: 1));

    List<ResultWithValue<RequiredItemDetails>> results =
        await Future.wait([solarPnlTask, batteryTask]);
    return results
        .where((result) => result.isSuccess)
        .map((result) => result.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String loading = getTranslations().fromKey(LocaleKey.loading);
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.solarPanelBatteryCalculator),
      body: CachedFutureBuilder<List<RequiredItemDetails>>(
        future: requiredItemDetailsFuture(context),
        whileLoading:
            getLoading().fullPageLoading(context, loadingText: loading),
        whenDoneLoading: (List<RequiredItemDetails> snapshot) {
          return SolarPanelInnerPage(
            solarPanelDetails: getItemFromArray(snapshot, _solarPanelId),
            batteryDetails: getItemFromArray(snapshot, _batteryId),
          );
        },
      ),
    );
  }

  RequiredItemDetails getItemFromArray(
    List<RequiredItemDetails> array,
    String id,
  ) {
    if (array == null || array.length == 0) return null;
    if (array.length == 1) return array[0];

    return array.firstWhere((item) => item.id == id, orElse: () => null);
  }
}

class SolarPanelInnerPage extends StatefulWidget {
  final RequiredItemDetails solarPanelDetails;
  final RequiredItemDetails batteryDetails;

  const SolarPanelInnerPage({
    Key key,
    this.solarPanelDetails,
    this.batteryDetails,
  }) : super(key: key);

  @override
  _SolarPanelInnerWidget createState() => _SolarPanelInnerWidget(
        solarPanelDetails,
        batteryDetails,
      );
}

class _SolarPanelInnerWidget extends State<SolarPanelInnerPage> {
  int _powerKps;
  final RequiredItemDetails solarPanelDetails;
  final RequiredItemDetails batteryDetails;
  bool showDetails = false;
  bool showInfo = false;
  TextEditingController _editing = TextEditingController();

  _SolarPanelInnerWidget(this.solarPanelDetails, this.batteryDetails);

  _setPowerKps(int powerKps) {
    this.setState(() {
      _powerKps = powerKps;
    });
  }

  _setPowerKpsFromString(String powerKpsString) {
    var intValue = int.tryParse(powerKpsString);
    if (intValue == null) intValue = 0;

    _setPowerKps(intValue);
  }

  _toggleShowDetails() {
    this.setState(() {
      showDetails = !showDetails;
    });
  }

  _toggleShowInfo() {
    this.setState(() {
      showInfo = !showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(flatCard(child: devilinPixyTile(context)));
    widgets.add(emptySpace1x());
    widgets.add(genericItemDescription(
      getTranslations().fromKey(LocaleKey.totalPowerConsumption),
    ));

    widgets.add(
      Padding(
        child: TextField(
          controller: _editing,
          style: TextStyle(fontSize: 24),
          autofocus: true,
          textAlign: TextAlign.center,
          cursorColor: getTheme().getSecondaryColour(context),
          onChanged: _setPowerKpsFromString,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        padding: EdgeInsets.only(left: 16, right: 16),
      ),
    );

    widgets.add(emptySpace3x());
    widgets.add(genericItemGroup(getTranslations().fromKey(LocaleKey.minimum)));

    int minSolarPanels = getMinimumAmountOfSolarPanels(_powerKps);
    if (solarPanelDetails != null) {
      solarPanelDetails.quantity = minSolarPanels;
      widgets.add(flatCard(
        child: requiredItemDetailsTilePresenter(context, solarPanelDetails),
      ));
    }

    int minBatteries = getMinimumAmountOfBatteries(_powerKps);
    if (batteryDetails != null) {
      batteryDetails.quantity = minBatteries;
      widgets.add(flatCard(
        child: requiredItemDetailsTilePresenter(context, batteryDetails),
      ));
    }

    var _powerKpsDouble = _powerKps?.toDouble() ?? 0.0;
    double tpcSunrise = getTotalPowerConsSunrise(_powerKpsDouble);
    double tpcDay = getTotalPowerConsDay(_powerKpsDouble);
    double tpcSunset = getTotalPowerConsSunsest(_powerKpsDouble);
    double tpcNight = getTotalPowerConsNight(_powerKpsDouble);
    double tpcTotal = (tpcSunrise + tpcDay + tpcSunset + tpcNight);

    var _minSolarPanelsDouble = minSolarPanels.toDouble();
    double spSunrise = getSolarPowerSunrise(_minSolarPanelsDouble);
    double spDay = getSolarPowerDay(_minSolarPanelsDouble);
    double spSunset = getSolarPowerSunsest(_minSolarPanelsDouble);
    double spNight = getSolarPowerNight(_minSolarPanelsDouble);
    double spTotal = (spSunrise + spDay + spSunset + spNight);

    double totalPowerGenerated = spTotal - (_powerKpsDouble * 1000);
    double maxPowerThatCanBeStored =
        getMaxPowerThatCanBeStored(minBatteries.toDouble());
    double totalPowerRequired = _powerKpsDouble * 800;
    double totalPowerStored = totalPowerGenerated;
    double totalPowerUnused = totalPowerStored - totalPowerRequired;
    double totalPowerLost = totalPowerGenerated - maxPowerThatCanBeStored;
    if (totalPowerLost < 0) totalPowerLost = 0;

    if (totalPowerGenerated > maxPowerThatCanBeStored) {
      totalPowerStored = maxPowerThatCanBeStored;
      totalPowerUnused = totalPowerStored - totalPowerRequired;
      widgets.add(emptySpace3x());
      widgets.add(genericItemDescription(
        getTranslations()
            .fromKey(LocaleKey.solarPanelsProduceMoreThanBatteries)
            .replaceAll('{0}', minSolarPanels.toString())
            .replaceAll('{1}', minBatteries.toString()),
      ));
      widgets.add(emptySpace1x());
      widgets.add(genericItemGroup(
        getTranslations().fromKey(LocaleKey.recommended),
      ));

      if (solarPanelDetails != null) {
        solarPanelDetails.quantity = minSolarPanels;
        widgets.add(Card(
          child: requiredItemDetailsTilePresenter(context, solarPanelDetails),
          margin: EdgeInsets.zero,
        ));
      }
      if (batteryDetails != null) {
        batteryDetails.quantity = getRecommendedAmountOfBatteries(
          minBatteries,
          totalPowerLost,
        );
        widgets.add(Card(
          child: requiredItemDetailsTilePresenter(context, batteryDetails),
          margin: EdgeInsets.zero,
        ));
      }
    }

    widgets.add(_cardButton(
      context,
      getTranslations().fromKey(LocaleKey.details),
      showDetails,
      this._toggleShowDetails,
    ));
    if (showDetails) {
      widgets.add(emptySpace(1));
      widgets.add(genericItemGroup(
        getTranslations().fromKey(LocaleKey.totalPowerConsumed),
      ));
      widgets.add(getPowerTable(
        context,
        _powerKpsDouble,
        sunrise: tpcSunrise,
        day: tpcDay,
        sunset: tpcSunset,
        night: tpcNight,
        total: tpcTotal,
      ));

      widgets.add(genericItemGroup(
        getTranslations().fromKey(LocaleKey.totalSolarProduced),
      ));
      widgets.add(getPowerTable(
        context,
        _minSolarPanelsDouble,
        sunrise: spSunrise,
        day: spDay,
        sunset: spSunset,
        night: spNight,
        total: spTotal,
      ));

      widgets.add(genericItemGroup(
        getTranslations().fromKey(LocaleKey.minimumSummary),
      ));
      widgets.add(getSummaryTable(
        context,
        totalPowerStored,
        totalPowerRequired,
        totalPowerUnused,
        totalPowerLost,
      ));

      if (totalPowerGenerated > maxPowerThatCanBeStored) {
        widgets.add(genericItemGroup(
          getTranslations().fromKey(LocaleKey.recommendedSummary),
        ));
        widgets.add(getSummaryTable(
          context,
          (totalPowerStored + totalPowerLost),
          totalPowerRequired,
          (totalPowerUnused + totalPowerLost),
          0,
        ));
      }
    }

    widgets.add(_cardButton(
      context,
      getTranslations().fromKey(LocaleKey.info),
      showInfo,
      this._toggleShowInfo,
    ));
    if (showInfo) {
      widgets.add(emptySpace1x());
      widgets.add(genericItemDescription(
        getTranslations().fromKey(LocaleKey.basedOnWorstCase),
      ));
      widgets.add(inGameInfoTable(context));
      widgets.add(realTimeInfoTable(context));
      widgets.add(emptySpace1x());
      widgets.add(genericItemDescription(
        getTranslations().fromKey(LocaleKey.bestCaseScenarioLocation),
      ));
    }
    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  Widget _cardButton(
      BuildContext context, String title, bool isOpen, Function onTap) {
    return GestureDetector(
      child: Padding(
        child: Stack(
          children: [
            Card(
              child: Padding(
                child: Center(
                  child: Text(title),
                ),
                padding: EdgeInsets.all(16),
              ),
              color: getTheme().getSecondaryColour(context),
              margin: EdgeInsets.all(0),
            ),
            Positioned(
              child: Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              top: 0,
              right: 8,
              bottom: 0,
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 8),
      ),
      onTap: onTap,
    );
  }
}
