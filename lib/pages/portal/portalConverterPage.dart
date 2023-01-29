// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/text_formatter.dart';
import '../../components/portal/galacticAddress.dart';
import '../../components/portal/portalGlyphList.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/enum/portalAddressType.dart';
import '../../contracts/misc/segmentViewMultiBuilder.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/hexHelper.dart';
import '../../redux/modules/portal/portalViewModel.dart';

class PortalConverterPage extends StatefulWidget {
  const PortalConverterPage({Key? key}) : super(key: key);

  @override
  createState() => _PortalConverterPageState();
}

class _PortalConverterPageState extends State<PortalConverterPage> {
  PortalAddressType input = PortalAddressType.Glyphs;
  int outputIndex = 0;
  List<int> codes = List.empty(growable: true);
  bool disableEditBtns = false;
  int counter = 0;
  String? _hexString;
  late TextEditingController _hexCoordController;
  late TextEditingController _galAddrAController;
  late TextEditingController _galAddrBController;
  late TextEditingController _galAddrCController;
  late TextEditingController _galAddrDController;
  late TextEditingController _galAddrPlanetIndexController;

  _PortalConverterPageState() {
    getAnalytics().trackEvent(AnalyticsEvent.portalConverterPage);
  }

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

  _addCode(int code) {
    if (codes.length >= 12) return;
    setState(() {
      codes.add(code);
      String tempHexStr = allUpperCase(intArrayToHex(codes));
      _setHexCoordText(tempHexStr);
      if (codes.isNotEmpty) disableEditBtns = false;
    });
  }

  _setCode(List<int> newCodes) {
    if (newCodes.length > 12) newCodes = newCodes.take(12).toList();
    setState(() {
      codes = newCodes;
      if (newCodes.isNotEmpty) disableEditBtns = false;
    });
  }

  _backspaceCode() {
    if (codes.isEmpty) return;
    setState(() {
      codes = codes.sublist(0, codes.length - 1);
      String tempHexStr = allUpperCase(intArrayToHex(codes));
      _setHexCoordText(tempHexStr);
      if (codes.isEmpty) disableEditBtns = true;
    });
  }

  _clearCode() {
    if (codes.isEmpty) return;
    setState(() {
      codes = [];
      String tempHexStr = allUpperCase(intArrayToHex(codes));
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
          if (newValue.length >= 4) {
            setState(() {
              counter++;
            });
          }
        },
      ),
    );
  }

  _galAddressCopy(BuildContext localContext, String newTxt) {
    Clipboard.setData(ClipboardData(text: newTxt));
    getSnackbar().showSnackbar(
      localContext,
      LocaleKey.galacticAddressCopied,
      description: newTxt,
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
        builder: (_, viewModel) => LayoutBuilder(
          builder: (layoutCtx, BoxConstraints constraints) {
            return getBody(layoutCtx, viewModel, constraints);
          },
        ),
      ),
    );
  }

  Widget getBody(
    BuildContext scaffoldContext,
    PortalViewModel portalViewModel,
    BoxConstraints constraints,
  ) {
    String colour = getTheme().getIsDark(context) ? 'white' : 'black';
    if (portalViewModel.useAltGlyphs) colour = 'alt';
    List<Widget> inputWidgets = List.empty(growable: true);
    List<Widget> outputWidgets = List.empty(growable: true);
    Widget galAddrSpace = const GenericItemName(' : ');

    Padding hexCodeWidget = Padding(
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

    double screenWidth = constraints.maxWidth;
    bool screenIsSmol = screenWidth < 500;
    double maxWidth = screenIsSmol ? screenWidth : (screenWidth * 0.7);
    List<SegmentViewMultiBuilder> portalOptions = [
      SegmentViewMultiBuilder(
        enumIndex: PortalAddressType.Code.index,
        title: LocaleKey.hexCoordLabel,
        builders: [
          (innerCtx) => [
                const EmptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: hexCodeWidget,
                ),
                const EmptySpace2x(),
              ],
          (innerCtx) {
            List<Widget> innerBuilder = List.empty(growable: true);
            innerBuilder.add(const EmptySpace2x());
            if (input == PortalAddressType.GalacticCoords) {
              innerBuilder.add(
                GenericItemName(portalCodesFromGalacticAddress(
                  context,
                  _galAddrPlanetIndexController.text,
                  _galAddrAController.text,
                  _galAddrBController.text,
                  _galAddrCController.text,
                  _galAddrDController.text,
                ).value),
              );
            } else {
              innerBuilder.add(GenericItemName(
                allUpperCase(intArrayToHex(codes)),
              ));
            }

            innerBuilder.add(const EmptySpace2x());
            return innerBuilder;
          }
        ],
      ),
      SegmentViewMultiBuilder(
        enumIndex: PortalAddressType.Glyphs.index,
        title: LocaleKey.portalAddress,
        builders: [
          (innerCtx) => [
                const EmptySpace2x(),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red[400]!),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red[800]!),
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
                const EmptySpace1x(),
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
                const EmptySpace1x(),
              ],
          (innerCtx) {
            List<Widget> innerBuilder = List.empty(growable: true);
            innerBuilder.add(const EmptySpace2x());

            if (input == PortalAddressType.GalacticCoords) {
              ResultWithValue<String> convertResult =
                  portalCodesFromGalacticAddress(
                context,
                _galAddrPlanetIndexController.text,
                _galAddrAController.text,
                _galAddrBController.text,
                _galAddrCController.text,
                _galAddrDController.text,
              );
              if (convertResult.hasFailed == true) {
                innerBuilder.add(GenericItemName(convertResult.value));
              } else {
                List<int> intCoords = hexToIntArray(convertResult.value);
                // ignore: unnecessary_null_comparison
                bool anyAreNull = intCoords.any((coord) => coord == null);
                if (anyAreNull == false && intCoords.length == 12) {
                  innerBuilder.add(
                    twoLinePortalGlyphList(
                      intCoords,
                      useAltGlyphs: portalViewModel.useAltGlyphs,
                    ),
                  );
                } else {
                  innerBuilder.add(GenericItemName(
                    getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
                  ));
                }
              }
            } else {
              innerBuilder.add(
                twoLinePortalGlyphList(
                  codes,
                  useAltGlyphs: portalViewModel.useAltGlyphs,
                ),
              );
            }

            innerBuilder.add(const EmptySpace2x());
            return innerBuilder;
          },
        ],
      ),
      SegmentViewMultiBuilder(
        enumIndex: PortalAddressType.GalacticCoords.index,
        title: LocaleKey.galacticAddress,
        builders: [
          (innerCtx) => [
                const EmptySpace2x(),
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
                const EmptySpace2x(),
                SizedBox(
                  width: maxWidth,
                  child: TextField(
                    controller: _galAddrPlanetIndexController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: getTranslations()
                          .fromKey(LocaleKey.galacticAddressPlanetIndex),
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
                const EmptySpace2x(),
              ],
          (innerCtx) => [
                const EmptySpace2x(),
                galacticAddress(
                  innerCtx,
                  codes,
                  hideTextHeading: true,
                  onCopy: (String newTxt) => _galAddressCopy(innerCtx, newTxt),
                ),
                const EmptySpace1x(),
              ],
        ],
      ),
    ];
    outputWidgets.add(const EmptySpace1x());
    outputWidgets.add(AdaptiveSegmentedControl(
      controlItems: portalOptions.map((s) => s.toSegmentOption()).toList(),
      currentSelection: input.index,
      onSegmentChosen: (index) {
        var portalAddrType = portalAddressTypeValues.map[index.toString()];
        if (portalAddrType == null) return;
        setState(() {
          input = portalAddrType;
        });
      },
    ));

    var inputBuilder = portalOptions[input.index].builders[0];
    List<Widget> inputBuilderWidgets = inputBuilder(context);
    for (Widget inputBuilderWidget in inputBuilderWidgets) {
      outputWidgets.add(inputBuilderWidget);
    }
    outputWidgets.add(customDivider());

    var outputOptions =
        portalOptions.where((opt) => opt.enumIndex != input.index).toList();
    outputWidgets.add(const EmptySpace1x());
    outputWidgets.add(AdaptiveSegmentedControl(
      controlItems: outputOptions.map((s) => s.toSegmentOption()).toList(),
      currentSelection: outputIndex,
      onSegmentChosen: (index) {
        setState(() {
          outputIndex = index;
        });
      },
    ));

    var outputBuilder = outputOptions[outputIndex].builders[1];
    List<Widget> outputBuilderWidgets = outputBuilder(context);
    for (Widget outputBuilderWidget in outputBuilderWidgets) {
      outputWidgets.add(outputBuilderWidget);
    }

    outputWidgets.add(const EmptySpace8x());

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
