import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/dialogs/baseDialog.dart';
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

class AddFriendCodePage extends StatefulWidget {
  AddFriendCodePage();

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
    getSegmentedControlOption(xb1)
  ];

  @override
  void initState() {
    super.initState();
    friendCodeVm = AddFriendCodeViewModel(languageCode: 'en');
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _codeController = maskedTextController(
      mask: '@@@@-@@@@-@@@@@',
      defaultText: '',
      afterChange: (String prev, String next) {
        _codeController.text = next.toUpperCase();
        _codeController.selection = TextSelection.collapsed(
          offset: _codeController.text.length,
        );
      },
    );
  }

  _AddFriendCodeState() {
    getAnalytics().trackEvent(AnalyticsEvent.addFriendCodeListPage);
    _validationMap = {
      'name': () => nameValidator(_nameController.text, minLength: 1),
      'email': () => emailValidator(_emailController.text),
      'code': () => friendCodeValidator(_codeController.text),
    };
  }

  updateApiObj() {
    this.setState(() {
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
      builder: (_, friendCodeSettingVm) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.friendCode),
        body: getBody(context, friendCodeSettingVm),
        fab: FloatingActionButton(
          onPressed: () async {
            if (!this._allValidationsPassed()) {
              this.setState(() {
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
            this.setState(() {
              _isLoading = true;
            });
            var submissionResult = await getApiRepo().submitFriendCode(apiObj);
            this.setState(() {
              _isLoading = false;
            });
            if (submissionResult.isSuccess) {
              var thankYou = getTranslations()
                  .fromKey(LocaleKey.thankYouForSubmittingFriendCode);
              var checkMail = getTranslations()
                  .fromKey(LocaleKey.pleaseCheckMailForConfirmation)
                  .replaceAll('{0}', '(${apiObj.email})');
              var dialogDescription = '$thankYou $checkMail';
              prettyDialog(
                context,
                '${getPath().imageAssetPathPrefix}/email.png',
                getTranslations().fromKey(LocaleKey.friendCode),
                dialogDescription,
                onlyCancelButton: true,
              );
            } else {
              simpleDialog(
                context,
                getTranslations().fromKey(LocaleKey.error),
                getTranslations().fromKey(LocaleKey.friendCodeNotSubmitted),
                buttons: [simpleDialogCloseButton(context)],
              );
            }
          },
          heroTag: 'addFriendCode',
          child: Icon(Icons.check),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }

  Widget getBody(
      BuildContext context, FriendCodeSettingsViewModel friendCodeVm) {
    if (_isLoading) return getLoading().fullPageLoading(context);
    List<Widget> widgets = List.empty(growable: true);

    var textEditingPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0);

    widgets.add(Padding(
      padding: textEditingPadding,
      child: adaptiveSegmentedControl(
        context,
        controlItems: options,
        currentSelection: friendCodeVm.lastPlatformIndex,
        onSegmentChosen: (index) => friendCodeVm.setPlatformIndex(index),
      ),
    ));

    widgets.add(Padding(
      padding: textEditingPadding,
      child: TextField(
        controller: _nameController,
        decoration: getTextFieldDecoration(
          context,
          LocaleKey.name,
          this._validationMap['name'],
          _showValidation,
        ),
        onChanged: (_) => this.updateApiObj(),
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
              this._validationMap['email'],
              _showValidation,
            ),
            onChanged: (_) => this.updateApiObj(),
          ),
        ),
        Positioned(
          top: 4,
          right: 22,
          bottom: 4,
          child: GestureDetector(
            child: Icon(Icons.help_outline),
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
          this._validationMap['code'],
          _showValidation,
        ),
        onChanged: (_) => this.updateApiObj(),
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp('[A-z0-9]'), allow: true),
          LengthLimitingTextInputFormatter(15),
        ],
      ),
    ));

    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  bool _allValidationsPassed() {
    for (var validationKey in this._validationMap.keys) {
      var validate = this._validationMap[validationKey];
      var vResult = validate();
      if (vResult == false) return false;
    }
    return true;
  }
}
