// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../components/common/textFormatter.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';

import '../../components/portal/galacticAddress.dart';
import '../../components/portal/portalGlyphList.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/NmsExternalUrls.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/enum/portalAddressType.dart';
import '../../contracts/misc/segmentViewItem.dart';
import '../../contracts/misc/segmentViewMultiBuilder.dart';
import '../../contracts/portal/portalRecord.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/hexHelper.dart';
import '../../redux/modules/portal/portalViewModel.dart';
import 'addPortalPage.dart';

class PortalConverterPage extends StatefulWidget {
  const PortalConverterPage({Key key}) : super(key: key);

  @override
  createState() => _PortalConverterPageState();
}

class _PortalConverterPageState extends State<PortalConverterPage> {
  PortalAddressType input = PortalAddressType.Glyphs;
  PortalAddressType output = PortalAddressType.GalacticCoords;
  List<int> codes = List.empty(growable: true);
  bool disableEditBtns = false;
  int counter = 0;
  String _hexString;
  TextEditingController _hexCoordController;
  TextEditingController _galAddrAController;
  TextEditingController _galAddrBController;
  TextEditingController _galAddrCController;
  TextEditingController _galAddrDController;
  TextEditingController _galAddrPlanetIndexController;

  @override
  void initState() {
    super.initState();
    _hexString = allUpperCase(intArrayToHex(codes));
    _hexCoordController = TextEditingController(text: _hexString);
    _galAddrAController = TextEditingController(text: '');
    _galAddrBController = TextEditingController(text: '');
    _galAddrCController = TextEditingController(text: '');
    _galAddrDController = TextEditingController(text: '');
    _galAddrPlanetIndexController = TextEditingController(text: '0');
  }

  _PortalConverterPageState() {
    getAnalytics().trackEvent(AnalyticsEvent.portalConverterPage);
  }

  _addCode(int code) {
    if (codes.length >= 12) return;
    setState(() {
      codes.add(code);
      var tempHexStr = allUpperCase(intArrayToHex(codes));
      _setHexCoordText(tempHexStr);
      if (codes.isNotEmpty) disableEditBtns = false;
    });
  }

  _setCode(List<int> newCodes) {
    if (newCodes.length > 12) newCodes = newCodes.take(12);
    setState(() {
      codes = newCodes;
      if (newCodes.isNotEmpty) disableEditBtns = false;
    });
  }

  _backspaceCode() {
    if (codes.isEmpty) return;
    setState(() {
      codes = codes.sublist(0, codes.length - 1);
      var tempHexStr = allUpperCase(intArrayToHex(codes));
      _setHexCoordText(tempHexStr);
      if (codes.isEmpty) disableEditBtns = true;
    });
  }

  _clearCode() {
    if (codes.isEmpty) return;
    setState(() {
      codes = [];
      var tempHexStr = allUpperCase(intArrayToHex(codes));
      _setHexCoordText(tempHexStr);
      disableEditBtns = true;
    });
  }

  _setHexCoordText(String text) {
    _hexCoordController.text = text;
    _hexCoordController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  _galAddressTextBox(String keyStr, TextEditingController controller) {
    return Flexible(
      key: Key('_galAddressTextBox' + keyStr),
      fit: FlexFit.loose,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter(
            RegExp('[a-fA-F0-9]'),
            allow: true,
          ),
          LengthLimitingTextInputFormatter(4),
          UpperCaseTextFormatter(),
        ],
        onChanged: (newValue) {
          controller.text = newValue;
          controller.selection =
              TextSelection.collapsed(offset: newValue.length);
          setState(() {
            counter++;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      showHomeAction: true,
      title: getTranslations().fromKey(LocaleKey.portalLibrary),
      body: StoreConnector<AppState, PortalViewModel>(
        converter: (store) => PortalViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(context, viewModel),
      ),
    );
  }

  Widget getBody(
    BuildContext scaffoldContext,
    PortalViewModel portalViewModel,
  ) {
    String colour = getTheme().getIsDark(context) ? 'white' : 'black';
    if (portalViewModel.useAltGlyphs) colour = 'alt';
    List<Widget> inputWidgets = List.empty(growable: true);
    List<Widget> outputWidgets = List.empty(growable: true);
    List<Widget> noConversionNeededWidgets = [
      emptySpace2x(),
      genericItemName('No conversion needed'), // TODO translate
      emptySpace1x(),
    ];
    Widget galAddrSpace = genericItemName(' : ');

    var hexCodeWidget = Padding(
      padding: NMSUIConstants.buttonPadding,
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
    );

    double screenWidth = MediaQuery.of(context).size.width;
    bool screenIsSmol = screenWidth < 500;
    double maxWidth = screenIsSmol ? screenWidth : (screenWidth * 0.7);
    List<SegmentViewMultiBuilder> portalOptions = [
      SegmentViewMultiBuilder(
        title: LocaleKey.portals, // TODO translate
        builders: [
          (innerCtx) => [
                emptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: hexCodeWidget,
                ),
                emptySpace2x(),
              ],
          (innerCtx) {
            if (input == PortalAddressType.Code) {
              return noConversionNeededWidgets;
            }
            List<Widget> innerBuilder = List.empty(growable: true);
            innerBuilder.add(emptySpace2x());
            if (input == PortalAddressType.GalacticCoords) {
              innerBuilder.add(
                genericItemName(portalCodesFromGalacticAddress(
                  context,
                  _galAddrPlanetIndexController.text,
                  _galAddrAController.text,
                  _galAddrBController.text,
                  _galAddrCController.text,
                  _galAddrDController.text,
                )),
              );
            } else {
              innerBuilder.add(genericItemName(
                allUpperCase(intArrayToHex(codes)),
              ));
            }

            innerBuilder.add(emptySpace2x());
            return innerBuilder;
          }
        ],
      ),
      SegmentViewMultiBuilder(
        title: LocaleKey.renamePortal, // TODO translate
        builders: [
          (innerCtx) => [
                emptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(fit: FlexFit.loose, child: hexCodeWidget),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red[400]),
                        ),
                        onPressed: disableEditBtns
                            ? null
                            : () {
                                _backspaceCode();
                              },
                        child: Icon(
                          Icons.backspace,
                          color:
                              disableEditBtns ? Colors.white60 : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red[800]),
                        ),
                        onPressed: disableEditBtns
                            ? null
                            : () {
                                _clearCode();
                              },
                        child: Icon(
                          Icons.clear,
                          color:
                              disableEditBtns ? Colors.white60 : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                emptySpace1x(),
                SizedBox(
                  width: maxWidth,
                  child: portalInput(
                    context,
                    colour: colour,
                    width: screenIsSmol ? null : maxWidth,
                    addCode: (newCode) => _addCode(newCode),
                    isDisabled: codes.length > 11,
                  ),
                ),
                emptySpace1x(),
              ],
          (innerCtx) => [
                emptySpace1x(),
                twoLinePortalGlyphList(codes, useAltGlyphs: true),
                emptySpace1x(),
              ],
        ],
      ),
      SegmentViewMultiBuilder(
        title: LocaleKey.galacticAddress, // TODO translate
        builders: [
          (innerCtx) => [
                emptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _galAddressTextBox('galAddrA', _galAddrAController),
                      galAddrSpace,
                      _galAddressTextBox('galAddrB', _galAddrBController),
                      galAddrSpace,
                      _galAddressTextBox('galAddrC', _galAddrCController),
                      galAddrSpace,
                      _galAddressTextBox('galAddrD', _galAddrDController),
                    ],
                  ),
                ),
                emptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: TextField(
                    controller: _galAddrPlanetIndexController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Planet index', // TODO translate
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (newValue) {
                      _galAddrPlanetIndexController.text = newValue;
                      _galAddrPlanetIndexController.selection =
                          TextSelection.collapsed(offset: newValue.length);
                      setState(() {
                        counter++;
                      });
                    },
                  ),
                ),
                emptySpace2x(),
              ],
          (innerCtx) => [
                if (input == PortalAddressType.GalacticCoords)
                  ...noConversionNeededWidgets
                else ...[
                  emptySpace2x(),
                  galacticAddress(innerCtx, codes, hideTextHeading: true),
                  emptySpace1x(),
                ],
              ],
        ],
      ),
    ];
    outputWidgets.add(emptySpace1x());
    outputWidgets.add(adaptiveSegmentedControl(
      context,
      controlItems: portalOptions.map((s) => s.toSegmentOption()).toList(),
      currentSelection: input.index,
      onSegmentChosen: (index) {
        setState(() {
          input = portalAddressTypeValues.map[index.toString()];
        });
      },
    ));

    var inputBuilder = portalOptions[input.index].builders[0];
    List<Widget> inputBuilderWidgets = inputBuilder(context);
    for (Widget inputBuilderWidget in inputBuilderWidgets) {
      outputWidgets.add(inputBuilderWidget);
    }
    outputWidgets.add(customDivider());

    outputWidgets.add(emptySpace1x());
    outputWidgets.add(adaptiveSegmentedControl(
      context,
      controlItems: portalOptions.map((s) => s.toSegmentOption()).toList(),
      currentSelection: output.index,
      onSegmentChosen: (index) {
        setState(() {
          output = portalAddressTypeValues.map[index.toString()];
        });
      },
    ));

    var outputBuilder = portalOptions[output.index].builders[1];
    List<Widget> outputBuilderWidgets = outputBuilder(context);
    for (Widget outputBuilderWidget in outputBuilderWidgets) {
      outputWidgets.add(outputBuilderWidget);
    }

    outputWidgets.add(emptySpace8x());

    return ListView(
      children: [
        Column(
          children: inputWidgets,
        ),
        Column(
          key: Key(counter.toString()),
          children: outputWidgets,
        )
      ],
    );
  }
}
