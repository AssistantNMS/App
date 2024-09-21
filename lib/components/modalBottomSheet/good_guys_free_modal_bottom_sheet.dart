import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_duration.dart';
import '../../constants/modal.dart';
import '../../contracts/fishing/good_guy_free_bait_view_model.dart';
import '../common/row_helper.dart';

class GoodGuysFreeBottomSheet extends StatelessWidget {
  final GoodGuyFreeBaitViewModel viewModel;
  const GoodGuysFreeBottomSheet({Key? key, required this.viewModel})
      : super(key: key);

  Widget gridCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      );

  @override
  Widget build(BuildContext context) {
    var infoProvidedByAndOtherArr = getTranslations()
        .fromKey(LocaleKey.infoProvidedByAndOther)
        .split('{0}');

    List<Widget Function()> widgets = [
      () => const EmptySpace1x(),
      () => RichText(
            text: TextSpan(
              style: getThemeSubtitle(context),
              children: [
                TextSpan(text: infoProvidedByAndOtherArr[0]),
                TextSpan(
                  text: 'GoodGuysFree, PureCalamity, Lowe Gotembomrek',
                  style:
                      TextStyle(color: getTheme().getSecondaryColour(context)),
                ),
                TextSpan(text: infoProvidedByAndOtherArr[1]),
              ],
            ),
            textAlign: TextAlign.center,
          ),
      () => RichText(
            text: TextSpan(
              style: getThemeSubtitle(context),
              children: [
                TextSpan(
                  text: getTranslations().fromKey(
                    LocaleKey.contributeToExternalInfo,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
      () => const EmptySpace2x(),
      () => rowWith2Columns(
            PositiveButton(
              title: 'Discord',
              backgroundColour: HexColor('5865F2'),
              onTap: () =>
                  launchExternalURL('http://discord.com/users/goodguysfree'),
            ),
            PositiveButton(
              title: 'Twitter',
              backgroundColour: HexColor('08A0E9'),
              onTap: () => launchExternalURL('https://x.com/goodguysfree'),
            ),
          ),
      () => const EmptySpace2x(),
      () => Table(
            border: TableBorder.all(
              width: 2,
              color: getTheme().getCardBackgroundColour(context),
            ),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: gridCell(
                      getTranslations().fromKey(LocaleKey.rarity),
                    ),
                  ),
                  TableCell(
                    child: gridCell(
                      getTranslations().fromKey(LocaleKey.size),
                    ),
                  ),
                  TableCell(child: gridCell('Used for')),
                  TableCell(child: gridCell('Average')),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: gridCell('${viewModel.rarity} %')),
                  TableCell(child: gridCell('${viewModel.size} %')),
                  TableCell(child: gridCell(viewModel.usedFor)),
                  TableCell(child: gridCell('${viewModel.average} %')),
                ],
              ),
            ],
          ),
      () => const EmptySpace2x(),
      () => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PositiveButton(
                title: 'Google Sheet',
                onTap: () => launchExternalURL(
                    'https://docs.google.com/spreadsheets/d/1x9LFIzRIFG8B17wQqDNaD77atbtVtq9YK_PsbIJasiY'),
              )
            ],
          ),
    ];

    return AnimatedSize(
      duration: AppDuration.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widgets.length,
            itemBuilder: (_, int index) => widgets[index](),
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}
