import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

List<Widget> getSunriseHeading(BuildContext context) => [
      const CorrectlySizedImageFromIcon(icon: Icons.brightness_6, maxSize: 20),
      headingText(context, LocaleKey.sunrise),
    ];
List<Widget> getDayHeading(BuildContext context) => [
      const CorrectlySizedImageFromIcon(icon: Icons.brightness_7, maxSize: 20),
      headingText(context, LocaleKey.daytime),
    ];
List<Widget> getSunsetHeading(BuildContext context) => [
      const CorrectlySizedImageFromIcon(icon: Icons.brightness_4, maxSize: 20),
      headingText(context, LocaleKey.sunset),
    ];
List<Widget> getNightHeading(BuildContext context) => [
      const CorrectlySizedImageFromIcon(icon: Icons.brightness_3, maxSize: 20),
      headingText(context, LocaleKey.night),
    ];

Widget getPowerTable(BuildContext context, double totalPowerCons,
    {double sunrise = 0,
    double day = 0,
    double sunset = 0,
    double night = 0,
    double total = 0}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Table(
      children: [
        TableRow(children: [
          ...getSunriseHeading(context),
          rowText(context, sunrise.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          ...getDayHeading(context),
          rowText(context, day.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          ...getSunsetHeading(context),
          rowText(context, sunset.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          ...getNightHeading(context),
          rowText(context, night.toStringAsFixed(0)),
        ]),
        // TableRow(children: [getBaseWidget().customDivider(), getBaseWidget().customDivider()]),
        TableRow(children: [
          const EmptySpace1x(),
          const EmptySpace1x(),
          getBaseWidget().customDivider()
        ]),
        TableRow(children: [
          const EmptySpace1x(),
          headingText(context, LocaleKey.total, textAlign: TextAlign.right),
          rowText(
            context,
            total.toStringAsFixed(0),
          ),
        ]),
        TableRow(children: [
          getBaseWidget().customDivider(),
          getBaseWidget().customDivider(),
          getBaseWidget().customDivider()
        ]),
      ],
      columnWidths: const {
        0: FractionColumnWidth(.05),
        1: FractionColumnWidth(.65),
        2: FractionColumnWidth(.3)
      },
    ),
  );
}

Widget getSummaryTable(BuildContext context, double powerStoredForNight,
    double powerRequiredForNight, double powerUnused, double powerLost) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Table(
      children: [
        TableRow(children: [
          const CorrectlySizedImageFromIcon(
            icon: Icons.battery_charging_full,
            maxSize: 20,
          ),
          headingText(context, LocaleKey.powerStored),
          rowText(context, powerStoredForNight.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          const CorrectlySizedImageFromIcon(
            icon: Icons.lightbulb_outline,
            maxSize: 20,
          ),
          headingText(context, LocaleKey.powerRequired),
          rowText(context, powerRequiredForNight.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          const CorrectlySizedImageFromIcon(
            icon: Icons.battery_alert,
            maxSize: 20,
          ),
          headingText(context, LocaleKey.powerUnused),
          rowText(context, powerUnused.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          const CorrectlySizedImageFromIcon(
            icon: Icons.delete_outline,
            maxSize: 20,
          ),
          headingText(context, LocaleKey.powerLost),
          rowText(context, powerLost.toStringAsFixed(0)),
        ]),
        TableRow(children: [
          getBaseWidget().customDivider(),
          getBaseWidget().customDivider(),
          getBaseWidget().customDivider()
        ]),
      ],
      columnWidths: const {
        0: FractionColumnWidth(.05),
        1: FractionColumnWidth(.65),
        2: FractionColumnWidth(.3)
      },
    ),
  );
}

Widget headingLocaleKeyWithImage(
  BuildContext context,
  IconData icon,
  LocaleKey locale, {
  TextAlign? textAlign,
}) =>
    Row(children: [
      CorrectlySizedImageFromIcon(icon: icon, maxSize: 20),
      headingText(context, locale, textAlign: textAlign),
    ]);

Widget headingText(
  BuildContext context,
  LocaleKey locale, {
  TextAlign? textAlign,
}) =>
    Padding(
      child: Text(
        getTranslations().fromKey(locale),
        style: const TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
      padding: const EdgeInsets.only(top: 2, bottom: 4, left: 8),
    );

Widget rowText(
  BuildContext context,
  String text, {
  TextAlign? textAlign,
}) =>
    Padding(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.end,
      ),
      padding: const EdgeInsets.only(top: 2, bottom: 4, right: 8),
    );

Widget inGameInfoTable(BuildContext context) {
  return Padding(
    child: Column(
      children: [
        Table(
          children: [
            TableRow(children: [
              const EmptySpace1x(),
              const EmptySpace1x(),
              rowText(context, getTranslations().fromKey(LocaleKey.inGame)),
              const EmptySpace1x(),
            ]),
            TableRow(children: [
              ...getSunriseHeading(context),
              rowText(context, "05:20 - 06:26"),
              rowText(context, "1h 06m"),
            ]),
            TableRow(children: [
              ...getDayHeading(context),
              rowText(context, "06:26 - 17:34"),
              rowText(context, "11h 08m"),
            ]),
            TableRow(children: [
              ...getSunsetHeading(context),
              rowText(context, "17:34 - 18:40"),
              rowText(context, "1h 06m"),
            ]),
            TableRow(children: [
              ...getNightHeading(context),
              rowText(context, "18:40 - 05:20"),
              rowText(context, "10h 40m"),
            ]),
          ],
          columnWidths: const {
            0: FractionColumnWidth(.05),
          },
        ),
      ],
    ),
    padding: const EdgeInsets.all(8),
  );
}

Widget realTimeInfoTable(BuildContext context) {
  return Padding(
    child: Column(
      children: [
        Table(
          children: [
            TableRow(children: [
              const EmptySpace1x(),
              const EmptySpace1x(),
              rowText(context, getTranslations().fromKey(LocaleKey.realTime)),
              const EmptySpace1x(),
            ]),
            TableRow(children: [
              ...getSunriseHeading(context),
              rowText(context, "25kPs"),
              rowText(context, "82.5s"),
            ]),
            TableRow(children: [
              ...getDayHeading(context),
              rowText(context, "50kPs"),
              rowText(context, "835s"),
            ]),
            TableRow(children: [
              ...getSunsetHeading(context),
              rowText(context, "25kPs"),
              rowText(context, "82.5s"),
            ]),
            TableRow(children: [
              ...getNightHeading(context),
              rowText(context, "0kPs"),
              rowText(context, "800s"),
            ]),
          ],
          columnWidths: const {
            0: FractionColumnWidth(.05),
          },
        ),
      ],
    ),
    padding: const EdgeInsets.all(8),
  );
}
