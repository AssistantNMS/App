import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/dialogs/prettyDialog.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/generated/addFriendCodeViewModel.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/validationHelper.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/setting/friendCodeSettingsViewModel.dart';
import '../../validation/commonValidator.dart';

const String pc = 'PC';
const String ps4 = 'PS';
const String xb1 = 'XB';
const String nsw = 'SW';

class AddFriendCodePage extends StatefulWidget {
  const AddFriendCodePage({Key key}) : super(key: key);

  @override
  _AddFriendCodeState createState() => _AddFriendCodeState();
}

class _AddFriendCodeState extends State<AddFriendCodePage> {
  AddFriendCodeViewModel friendCodeVm;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _codeController;
  Map<String, bool Function()> _validationMap;
  bool _showValidation = false;
  bool _isLoading = false;

  List<Widget> options = [
    getSegmentedControlOption(pc),
    getSegmentedControlOption(ps4),
    getSegmentedControlOption(xb1),
    getSegmentedControlOption(nsw)
  ];

  @override
  void initState() {
    super.initState();
    friendCodeVm = AddFriendCodeViewModel(languageCode: 'en');
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _validationMap = {
      'name': () => nameValidator(_nameController.text, minLength: 1),
      'email': () => emailValidator(_emailController.text),
      'code': () => friendCodeValidator(_codeController.text),
    };
    setCodeValidator(false);
  }

  _AddFriendCodeState() {
    getAnalytics().trackEvent(AnalyticsEvent.addFriendCodeListPage);
  }

  setCodeValidator(bool isSwitch) {
    String friendCodeMask = '@@@@-@@@@-@@@@@';
    String text = _codeController?.text ?? '';
    // if (isSwitch) {
    //   friendCodeMask = '@@-@@@@-@@@@-@@@@';
    //   _validationMap['code'] = () => switchFriendCodeValidator(text);
    // } else {
    friendCodeMask = '@@@@-@@@@-@@@@@';
    _validationMap['code'] = () => friendCodeValidator(text);
    // }

    if (_codeController == null ||
        (_codeController as dynamic).mask != friendCodeMask) {
      getLog().i(friendCodeMask);
      _codeController = maskedTextController(
        mask: friendCodeMask,
        defaultText: '',
        afterChange: (String prev, String next) {
          _codeController.text = next.toUpperCase();
          _codeController.selection = TextSelection.collapsed(
            offset: _codeController.text.length,
          );
        },
      );
    }
  }

  updateApiObj() {
    setState(() {
      friendCodeVm = AddFriendCodeViewModel(
        name: _nameController.text,
        code: _codeController.text,
        email: _emailController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FriendCodeSettingsViewModel>(
      converter: (store) => FriendCodeSettingsViewModel.fromStore(store),
      builder: (_, FriendCodeSettingsViewModel friendCodeSettingVm) {
        bool isSwitch = friendCodeSettingVm.lastPlatformIndex == 3;
        setCodeValidator(isSwitch);
        return basicGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.friendCode),
          body: getBody(context, friendCodeSettingVm, isSwitch),
          fab: isSwitch ? null : getFab(friendCodeSettingVm),
        );
      },
    );
  }

  Widget getBody(
    BuildContext context,
    FriendCodeSettingsViewModel friendCodeVm,
    bool isSwitch,
  ) {
    if (_isLoading) return getLoading().fullPageLoading(context);
    List<Widget> widgets = List.empty(growable: true);

    EdgeInsets textEditingPadding =
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0);

    widgets.add(Padding(
      padding: textEditingPadding,
      child: adaptiveSegmentedControl(
        context,
        controlItems: options,
        currentSelection: friendCodeVm.lastPlatformIndex,
        onSegmentChosen: (index) => friendCodeVm.setPlatformIndex(index),
      ),
    ));

    if (isSwitch) {
      widgets.add(Padding(
        padding: textEditingPadding,
        child: const Center(child: Text('Not available yet')),
      ));
    } else {
      widgets.add(Padding(
        padding: textEditingPadding,
        child: TextField(
          controller: _nameController,
          decoration: getTextFieldDecoration(
            context,
            LocaleKey.name,
            _validationMap['name'],
            _showValidation,
          ),
          onChanged: (_) => updateApiObj(),
        ),
      ));

      widgets.add(Stack(
        children: [
          Padding(
            padding: textEditingPadding,
            child: TextField(
              controller: _emailController,
              decoration: getTextFieldDecoration(
                context,
                LocaleKey.emailAddress,
                _validationMap['email'],
                _showValidation,
              ),
              onChanged: (_) => updateApiObj(),
            ),
          ),
          Positioned(
            top: 4,
            right: 22,
            bottom: 4,
            child: GestureDetector(
              child: const Icon(Icons.help_outline),
              onTap: () {
                getDialog().showSimpleHelpDialog(
                  context,
                  getTranslations().fromKey(LocaleKey.help),
                  getTranslations().fromKey(LocaleKey.weDoNotStoreEmails),
                );
              },
            ),
          )
        ],
      ));

      widgets.add(Padding(
        padding: textEditingPadding,
        child: TextField(
          controller: _codeController,
          decoration: getTextFieldDecoration(
            context,
            LocaleKey.friendCode,
            _validationMap['code'],
            _showValidation,
          ),
          onChanged: (_) => updateApiObj(),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter(RegExp('[A-z0-9]'), allow: true),
            LengthLimitingTextInputFormatter(isSwitch ? 17 : 15),
          ],
        ),
      ));
    }

    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  FloatingActionButton getFab(FriendCodeSettingsViewModel friendCodeSettingVm) {
    return FloatingActionButton(
      onPressed: () async {
        if (!_allValidationsPassed()) {
          setState(() {
            _showValidation = true;
          });
          return;
        }

        LocalizationMap currentLocal =
            getTranslations().getCurrentLocalizationMap(
          context,
          friendCodeSettingVm.selectedLanguage,
        );
        AddFriendCodeViewModel apiObj = AddFriendCodeViewModel(
          name: friendCodeVm.name,
          code: friendCodeVm.code,
          email: friendCodeVm.email,
          platformType: friendCodeSettingVm.lastPlatformIndex + 1,
          languageCode: currentLocal.code,
        );
        setState(() {
          _isLoading = true;
        });
        Result submissionResult = await getApiRepo().submitFriendCode(apiObj);
        setState(() {
          _isLoading = false;
        });
        if (submissionResult.isSuccess) {
          String thankYou = getTranslations()
              .fromKey(LocaleKey.thankYouForSubmittingFriendCode);
          String checkMail = getTranslations()
              .fromKey(LocaleKey.pleaseCheckMailForConfirmation)
              .replaceAll('{0}', '(${apiObj.email})');
          String dialogDescription = '$thankYou $checkMail';
          prettyDialog(
            context,
            '${getPath().imageAssetPathPrefix}/email.png',
            getTranslations().fromKey(LocaleKey.friendCode),
            dialogDescription,
            onlyCancelButton: true,
          );
        } else {
          getDialog().showSimpleDialog(
            context,
            getTranslations().fromKey(LocaleKey.error),
            Text(getTranslations().fromKey(LocaleKey.friendCodeNotSubmitted)),
            buttonBuilder: (BuildContext ctx) => [
              getDialog().simpleDialogCloseButton(ctx),
            ],
          );
        }
      },
      heroTag: 'addFriendCode',
      child: const Icon(Icons.check),
      foregroundColor: getTheme().fabForegroundColourSelector(context),
      backgroundColor: getTheme().fabColourSelector(context),
    );
  }

  bool _allValidationsPassed() {
    for (var validationKey in _validationMap.keys) {
      var validate = _validationMap[validationKey];
      var vResult = validate();
      if (vResult == false) return false;
    }
    return true;
  }
}
