// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/textFormatter.dart';
import '../../components/portal/portalGlyphList.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/portal/portalRecord.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/actionHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/hexHelper.dart';
import '../../redux/modules/portal/portalViewModel.dart';

class AddPortalPage extends StatefulWidget {
  final bool isEdit;
  final PortalRecord item;
  const AddPortalPage(this.item, {Key? key, this.isEdit = false})
      : super(key: key);

  @override
  _PortalPageState createState() => _PortalPageState(item, isEdit: isEdit);
}

class _PortalPageState extends State<AddPortalPage> {
  String? validationMessage;
  PortalRecord item;
  final bool isEdit;
  late bool disableEditBtns;
  String? _hexString;
  late TextEditingController _hexCoordController;

  _PortalPageState(this.item, {this.isEdit = false}) {
    getAnalytics().trackEvent(AnalyticsEvent.addPortalPage);
    disableEditBtns = !isEdit;
  }

  @override
  void initState() {
    super.initState();
    _hexString = allUpperCase(intArrayToHex(item.codes));
    _hexCoordController = TextEditingController(text: _hexString);
  }

  _addCode(int code) {
    if (item.codes.length >= 12) return;
    setState(() {
      item.codes.add(code);
      String tempHexStr = allUpperCase(intArrayToHex(item.codes));
      _setHexCoordText(tempHexStr);
      if (item.codes.isNotEmpty) disableEditBtns = false;
    });
  }

  _setCode(List<int> codes) {
    if (codes.length > 12) codes = codes.take(12).toList();
    setState(() {
      item = item.copyWith(codes: codes);
      if (item.codes.isNotEmpty) disableEditBtns = false;
    });
  }

  _addTag(BuildContext context, String tag) {
    setState(() {
      item.tags.add(tag);
    });
  }

  _removeTag(BuildContext context, String tag) {
    setState(() {
      item.tags.remove(tag);
    });
  }

  _backspaceCode() {
    if (item.codes.isEmpty) return;
    setState(() {
      item = item.copyWith(
        codes: item.codes.sublist(0, item.codes.length - 1),
      );
      String tempHexStr = allUpperCase(intArrayToHex(item.codes));
      _setHexCoordText(tempHexStr);
      if (item.codes.isEmpty) disableEditBtns = true;
    });
  }

  _clearCode() {
    if (item.codes.isEmpty) return;
    setState(() {
      item = item.copyWith(
        codes: [],
      );
      String tempHexStr = allUpperCase(intArrayToHex(item.codes));
      _setHexCoordText(tempHexStr);
      disableEditBtns = true;
    });
  }

  _setHexCoordText(String text) {
    _hexCoordController.text = text;
    _hexCoordController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: item.name ?? getTranslations().fromKey(LocaleKey.newPortalEntry),
        actions: [
          editNameInAppBarAction(
            context,
            LocaleKey.name,
            nameIfEmpty: LocaleKey.newPortalEntry,
            currentName: item.name ??
                getTranslations().fromKey(LocaleKey.newPortalEntry),
            onEdit: (String newName) => setState(() {
              item.name = newName;
            }),
          ),
        ],
        body: getBody(context, viewModel),
        fab: getFab(context),
      ),
    );
  }

  Widget? getFab(BuildContext fabCtx) {
    if (item.codes.length != 12) return null;
    String name = (item.name == null)
        ? getTranslations().fromKey(LocaleKey.newPortalEntry)
        : item.name!;

    return FloatingActionButton(
      onPressed: () async {
        if (validationMessage != null) return;
        List<int> tempCodes = List.from(item.codes)
            .map((cc) => cc as int)
            .toList(); //So that it isn't passed by reference
        List<String> tempTags = List.from(item.tags)
            .map((cc) => cc as String)
            .toList(); //So that it isn't passed by reference
        getNavigation().pop(
          fabCtx,
          PortalRecord(
            name: name,
            uuid: item.uuid,
            codes: tempCodes,
            tags: tempTags,
          ),
        );
      },
      heroTag: 'AddPortalPage',
      child: const Icon(Icons.check),
      foregroundColor: getTheme().fabForegroundColourSelector(fabCtx),
      backgroundColor: getTheme().fabColourSelector(fabCtx),
    );
  }

  Widget getBody(BuildContext bodyCtx, PortalViewModel portalViewModel) {
    List<Widget> widgets = List.empty(growable: true);

    String colour = getTheme().getIsDark(bodyCtx) ? 'white' : 'black';
    if (portalViewModel.useAltGlyphs) colour = 'alt';

    widgets.add(Container(
      margin: const EdgeInsets.all(2.0),
      child: twoLinePortalGlyphList(item.codes,
          useAltGlyphs: portalViewModel.useAltGlyphs),
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Center(
        child: TextField(
          controller: _hexCoordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: getTranslations().fromKey(LocaleKey.hexCoordLabel),
          ),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter(RegExp('[a-fA-F0-9]'), allow: true),
            LengthLimitingTextInputFormatter(12),
            UpperCaseTextFormatter(),
          ],
          onChanged: (newHexString) {
            List<int> newCodes = hexToIntArray(newHexString);
            _setCode(newCodes);
            // _setHexCoordText(newHexString);
          },
        ),
      ),
    ));

    widgets.add(Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[400]!),
                      ),
                      onPressed: disableEditBtns
                          ? null
                          : () {
                              _backspaceCode();
                            },
                      child: Icon(
                        Icons.backspace,
                        color: disableEditBtns ? Colors.white60 : Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[800]!),
                      ),
                      onPressed: disableEditBtns
                          ? null
                          : () {
                              _clearCode();
                            },
                      child: Icon(
                        Icons.clear,
                        color: disableEditBtns ? Colors.white60 : Colors.white,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Switch.adaptive(
                        value: portalViewModel.useAltGlyphs,
                        activeThumbImage: AssetImage(
                          '${getPath().imageAssetPathPrefix}/portals/alt/0.png',
                        ),
                        inactiveThumbImage: AssetImage(
                          '${getPath().imageAssetPathPrefix}/portals/$colour/0.png',
                        ),
                        onChanged: (altGlyph) {
                          portalViewModel.toggleAltGlyphs();
                        },
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: portalInput(
                    bodyCtx,
                    colour: colour,
                    addCode: _addCode,
                  ),
                ),
              ],
            ))
      ],
    ));

    List<Widget> tags = List.empty(growable: true);
    for (var item in this.item.tags) {
      tags.add(genericChip(bodyCtx, item, onTap: () async {
        _removeTag(bodyCtx, item);
      }));
    }

    tags.add(
      genericChip(
        bodyCtx,
        '+' + getTranslations().fromKey(LocaleKey.addTag),
        onTap: () async {
          var availableTags = portalViewModel.availableTags
              .where((at) => !item.tags.contains(at))
              .toList();
          String? temp = await getNavigation().navigateAsync(
            bodyCtx,
            navigateTo: (_) => OptionsListPageDialog(
              'Tags',
              availableTags.map((g) => DropdownOption(g.toString())).toList(),
              addOption: (DropdownOption option) {
                portalViewModel.addTag(option.value);
              },
              onDelete: (DropdownOption option) {
                portalViewModel.removeTag(option.value);
              },
            ),
          );
          if (temp == null || temp.isEmpty) return;
          _addTag(bodyCtx, temp);
        },
      ),
    );
    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: tags,
    ));

    widgets.add(Container(
      margin: const EdgeInsets.all(16.0),
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (_, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
