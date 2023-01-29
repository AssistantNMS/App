import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/app_duration.dart';
import '../../constants/Modal.dart';
import '../../constants/storage_key.dart';
import '../../contracts/auth/googleLoginModel.dart';
import '../../integration/dependencyInjection.dart';
import '../common/row_helper.dart';
import '../tilePresenters/setting_tile_presenter.dart';

class GoogleLoginBottomSheet extends StatefulWidget {
  const GoogleLoginBottomSheet({Key? key}) : super(key: key);

  @override
  _GoogleLoginBottomSheetWidget createState() =>
      _GoogleLoginBottomSheetWidget();
}

class _GoogleLoginBottomSheetWidget extends State<GoogleLoginBottomSheet> {
  int rebuildCounter = 0;

  Future<ResultWithValue<GoogleLoginModel>> getCurrentLoggedInUser() async {
    GoogleLoginModel model = GoogleLoginModel(
      aaAccessToken: '',
      username: '',
      profileUrl: '',
      email: '',
    );
    try {
      ResultWithValue<String> authTokenResult = await getSecureStorageRepo()
          .loadStringFromStorageCheckExpiry(StorageKey.assistantAppsApiToken);
      if (authTokenResult.hasFailed) {
        throw Exception(
          'AssistantApps Api expired: ' + authTokenResult.errorMessage,
        );
      }

      User? user = getFirebase().getCurrentUser();
      if (user == null) {
        throw Exception(
          'User is not logged in via Google: ' + authTokenResult.errorMessage,
        );
      }

      model.aaAccessToken = authTokenResult.value;
      model.username = user.displayName ?? '';
      model.profileUrl = user.photoURL ?? '';
      model.email = user.email ?? '';
      return ResultWithValue(true, model, '');
    } catch (exception) {
      return ResultWithValue(false, model, exception.toString());
    }
  }

  Future<void> signIn() async {
    ResultWithValue<OAuthUserViewModel> googleLoginResult =
        await getFirebase().signInwithGoogle();
    if (googleLoginResult.hasFailed) {
      throw Exception(
          'Google login: could not login. ' + googleLoginResult.errorMessage);
    }
    ResultWithValue<DateTime> loginResult =
        await getAssistantAppsAuthApi().login(googleLoginResult.value);

    if (!loginResult.isSuccess) {
      throw Exception(
          'AssistantApps Api could not login. ' + loginResult.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      future: getCurrentLoggedInUser(),
      whileLoading: () => getLoading().loadingIndicator(),
      whenDoneLoading: (ResultWithValue<GoogleLoginModel> modelResult) {
        List<Widget> widgets = List.empty(growable: true);

        if (modelResult.isSuccess) {
          widgets.addAll(renderLoggedInList(modelResult.value));
        } else {
          widgets.addAll(renderNotLoggedInList());
        }

        widgets.add(const EmptySpace3x());

        return AnimatedSize(
          duration: AppDuration.modal,
          child: Container(
            constraints: modalDefaultSize(context),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: widgets.length,
              itemBuilder: (_, int index) => widgets[index],
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }

  Widget singleLineText(String text) => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  List<Widget> renderLoggedInList(GoogleLoginModel model) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(headingSettingTilePresenter(
      getTranslations().fromKey(LocaleKey.account),
    ));
    widgets.add(FlatCard(
      child: Column(
        children: [
          ListTile(
            leading: ClipOval(
              child: ImageFromNetwork(
                  imageUrl: model.profileUrl, height: 50, width: 50),
            ),
            title: singleLineText(model.username),
            subtitle: singleLineText(model.email),
          ),
          rowWith2Columns(
            PositiveButton(
              title: getTranslations().fromKey(LocaleKey.switchUser),
              onTap: () async {
                signIn();
                setState(() {
                  rebuildCounter++;
                });
              },
            ),
            NegativeButton(
              title: getTranslations().fromKey(LocaleKey.logout),
              onTap: () async {
                await getFirebase().signOutFromGoogle();
                setState(() {
                  rebuildCounter++;
                });
              },
            ),
          ),
        ],
      ),
    ));
    return widgets;
  }

  List<Widget> renderNotLoggedInList() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const EmptySpace3x());
    widgets.add(Center(
      child: AuthButton.google(
        onPressed: () async {
          try {
            signIn();
            setState(() {
              rebuildCounter++;
            });
            // getNavigation().pop(context);
          } catch (exception) {
            getLog().e('signInWithGoogle exception' + exception.toString());

            getDialog().showSimpleDialog(
              context,
              getTranslations().fromKey(LocaleKey.error),
              Text(getTranslations()
                  .fromKey(LocaleKey.unableToLogInToGoogleAccount)),
              buttonBuilder: (BuildContext ctx) => [
                getDialog().simpleDialogCloseButton(
                  ctx,
                  onTap: () {
                    // Old signIn
                  },
                )
              ],
            );
          }
        },
      ),
    ));
    return widgets;
  }
}
