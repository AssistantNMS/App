import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/rowHelper.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/settingTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/viewModel/syncPageViewModel.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({Key key}) : super(key: key);

  @override
  _SyncWidget createState() => _SyncWidget();
}

class _SyncWidget extends State<SyncPage> {
  int rebuildCounter = 0;
  _SyncWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.syncPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.synchronize),
      body: StoreConnector<AppState, SyncPageViewModel>(
          converter: (store) => SyncPageViewModel.fromStore(store),
          builder: (_, viewModel) => getBody(context, viewModel)),
    );
  }

  Widget getBody(BuildContext context, SyncPageViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);
    User user = getFirebase().getCurrentUser();
    if (user != null) {
      widgets.add(headingSettingTilePresenter(
        getTranslations().fromKey(LocaleKey.account),
      ));
      widgets.add(Card(
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: networkImage(user.photoURL, height: 50, width: 50),
              ),
              title: Text(
                user.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            rowWith2Columns(
              positiveButton(
                context,
                title: getTranslations().fromKey(LocaleKey.switchUser),
                onPress: () async {
                  await getFirebase().signOutFromGoogle();
                  await getFirebase().signInwithGoogle();
                  setState(() {
                    rebuildCounter++;
                  });
                },
              ),
              negativeButton(
                title: getTranslations().fromKey(LocaleKey.logout),
                onPress: () async {
                  await getFirebase().signOutFromGoogle();
                  setState(() {
                    rebuildCounter++;
                  });
                },
              ),
            ),
          ],
        ),
        margin: const EdgeInsets.all(0.0),
      ));

      // widgets.add(
      //   headingSettingTilePresenter(
      //       getTranslations().fromKey(LocaleKey.portals)),
      // );

      // widgets.add(AsyncSettingTilePresenter(
      //   title: getTranslations().fromKey(LocaleKey.backupPortals),
      //   icon: Icons.cloud_upload,
      //   futureFunc: () => asyncSettingTileGenericFunc(
      //     context,
      //     () => writePortalJsonFileToGoogleDrive(
      //       account,
      //       viewModel.portalState.toGoogleJson(),
      //     ),
      //     LocaleKey.portalsNotUploaded,
      //     LocaleKey.portalsUploaded,
      //   ),
      // ));

      // widgets.add(AsyncSettingTilePresenter(
      //   title: getTranslations().fromKey(LocaleKey.restorePortals),
      //   icon: Icons.cloud_download,
      //   futureFunc: () => asyncSettingTileWithSuccessFunc(
      //     context,
      //     () => readPortalJsonFileFromGoogleDrive(account),
      //     LocaleKey.portalsNotRestored,
      //     viewModel.restorePortals,
      //     LocaleKey.portalsRestored,
      //   ),
      // ));

      // widgets.add(
      //   headingSettingTilePresenter(
      //       getTranslations().fromKey(LocaleKey.inventoryManagement)),
      // );

      // widgets.add(
      //   AsyncSettingTilePresenter(
      //       title: getTranslations().fromKey(LocaleKey.backupInventory),
      //       icon: Icons.cloud_upload,
      //       futureFunc: () => asyncSettingTileGenericFunc(
      //             context,
      //             () => writeInventoryJsonFileToGoogleDrive(
      //               account,
      //               viewModel.inventoryState.toGoogleJson(),
      //             ),
      //             LocaleKey.inventoryNotUploaded,
      //             LocaleKey.inventoryUploaded,
      //           )),
      // );

      // widgets.add(AsyncSettingTilePresenter(
      //   title: getTranslations().fromKey(LocaleKey.restoreInventory),
      //   icon: Icons.cloud_download,
      //   futureFunc: () => asyncSettingTileWithSuccessFunc(
      //     context,
      //     () => readInventoryJsonFileFromGoogleDrive(account),
      //     LocaleKey.inventoryNotRestored,
      //     viewModel.restoreInventory,
      //     LocaleKey.inventoryRestored,
      //   ),
      // ));
    } else {
      widgets.add(emptySpace3x());
      // widgets.add(
      //   genericItemText('It is not possible to link with your NMS save'),
      // );
      // widgets.add(emptySpace1x());
      widgets.add(Center(
        child: AuthButton.google(
          onPressed: () async {
            try {
              await getFirebase().signInwithGoogle();
              setState(() {
                rebuildCounter++;
              });
            } catch (exception) {
              getLog().e('signInWithGoogle exception' + exception.toString());
              getDialog().showSimpleDialog(
                context,
                getTranslations().fromKey(LocaleKey.error),
                Text(
                  getTranslations()
                      .fromKey(LocaleKey.unableToLogInToGoogleAccount),
                ),
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
    }

    widgets.add(emptySpace3x());
    // widgets.add(genericItemDescription(
    //     'This sync feature is only intended to allow you to back up your app data to Google Drive.'));
    // widgets.add(localImage(AppImage.underConstruction, height: 150.0));
    // widgets.add(emptySpace1x());
    // widgets.add(genericItemDescription(
    //     'There is currently an issue with the Google Drive integration.'));
    // widgets.add(genericItemDescription(
    //     'I am working on an alternative way to back up your app data'));

    widgets.add(emptySpace3x());

    return listWithScrollbar(
      key: Key('counter: ${rebuildCounter.toString()}'),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }
}
