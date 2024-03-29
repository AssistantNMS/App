import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/dialogs/pretty_dialog.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/add_friend_code_view_model.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/validation_helper.dart';
import '../../integration/dependency_injection.dart';
import '../../redux/modules/setting/friend_code_settings_view_model.dart';
import '../../validation/common_validator.dart';

const String pc = 'PC';
const String ps4 = 'PS';
const String xb1 = 'XB';
const String nsw = 'SW';
const String defaultFriendCodeMask = '@@@@-@@@@-@@@@@';

class AddFriendCodePage extends StatefulWidget {
  const AddFriendCodePage({Key? key}) : super(key: key);

  @override
  _AddFriendCodeState createState() => _AddFriendCodeState();
}

class _AddFriendCodeState extends State<AddFriendCodePage> {
  late AddFriendCodeViewModel friendCodeVm;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late Map<String, bool Function()> _validationMap;
  TextEditingController _codeController = maskedTextController(
    mask: defaultFriendCodeMask,
    defaultText: '',
  );
  bool _showValidation = false;
  bool _isLoading = false;

  List<Widget> options = [
    const SegmentedControlOption(pc),
    const SegmentedControlOption(ps4),
    const SegmentedControlOption(xb1),
    const SegmentedControlOption(nsw)
  ];

  @override
  void initState() {
    super.initState();
    friendCodeVm = AddFriendCodeViewModel.initial()..languageCode = 'en';
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
    String friendCodeMask = '';
    String text = _codeController.text;
    if (isSwitch) {
      friendCodeMask = '@@-@@@@-@@@@-@@@@';
      _validationMap['code'] = () => switchFriendCodeValidator(text);
    } else {
      friendCodeMask = defaultFriendCodeMask;
      _validationMap['code'] = () => friendCodeValidator(text);
    }

    if (((_codeController as dynamic)?.mask ?? '') != friendCodeMask) {
      getLog().i(friendCodeMask);
      _codeController = maskedTextController(
        mask: friendCodeMask,
        defaultText: '',
        afterChange: (String prev, String next) {
          _codeController.text = next.toUpperCase();
          _codeController.selection = TextSelection.collapsed(
            offset: prev.length,
          );
        },
      );
    }
  }

  updateApiObj() {
    setState(() {
      friendCodeVm = friendCodeVm.copyWith(
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
      child: AdaptiveSegmentedControl(
        controlItems: options,
        currentSelection: friendCodeVm.lastPlatformIndex,
        onSegmentChosen: (index) => friendCodeVm.setPlatformIndex(index),
      ),
    ));

    if (isSwitch) {
      widgets.add(const EmptySpace3x());
      widgets.add(Padding(
        padding: textEditingPadding,
        child: const Center(
          child: Text(
            'Not available yet',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ));
    } else {
      widgets.add(Padding(
        padding: textEditingPadding,
        child: TextField(
          controller: _nameController,
          decoration: getTextFieldDecoration(
            context,
            LocaleKey.name,
            _validationMap['name']!,
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
                _validationMap['email']!,
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
            _validationMap['code']!,
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

    widgets.add(const EmptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
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
      if (validate == null) continue;
      var vResult = validate();
      if (vResult == false) return false;
    }
    return true;
  }
}
