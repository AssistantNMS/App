import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/row_helper.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/async_setting_tile_presenter.dart';
import '../../components/tilePresenters/setting_tile_presenter.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/GoogleDrive.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/redux/inventoryState.dart';
import '../../contracts/redux/portalState.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/viewModel/syncPageViewModel.dart';
import '../../services/base/fileService.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({Key? key}) : super(key: key);

  @override
  _SyncWidget createState() => _SyncWidget();
}

class _SyncWidget extends State<SyncPage> {
  int rebuildCounter = 0;
  _SyncWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.syncPage);
  }

  @override
  Widget build(BuildContext buildCtx) {
    return simpleGenericPageScaffold(
      buildCtx,
      title: getTranslations().fromKey(LocaleKey.synchronize),
      body: StoreConnector<AppState, SyncPageViewModel>(
          converter: (store) => SyncPageViewModel.fromStore(store),
          builder: (_, viewModel) => getBody(buildCtx, viewModel)),
    );
  }

  List<Widget> getGoogleDriveWidgets(BuildContext authCtx) {
    List<Widget> widgets = List.empty(growable: true);
    User? user = getFirebase().getCurrentUser();
    if (user != null) {
      widgets.add(headingSettingTilePresenter(
        getTranslations().fromKey(LocaleKey.account),
      ));
      widgets.add(Card(
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: ImageFromNetwork(
                    imageUrl: user.photoURL!, height: 50, width: 50),
              ),
              title: Text(
                user.displayName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                user.email!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            rowWith2Columns(
              PositiveButton(
                title: getTranslations().fromKey(LocaleKey.switchUser),
                onTap: () async {
                  await getFirebase().signOutFromGoogle();
                  await getFirebase().signInwithGoogle();
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
      widgets.add(const EmptySpace3x());
      // widgets.add(
      //   GenericItemText('It is not possible to link with your NMS save'),
      // );
      // widgets.add(const EmptySpace1x());
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
                authCtx,
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

    widgets.add(const EmptySpace3x());
    return widgets;
  }

  Widget getBody(BuildContext bodyCtx, SyncPageViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);
    // widgets.addAll(getAuthWidgets(bodyCtx));

    widgets.add(GestureDetector(
      child: Container(
        color: Colors.red[900],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            getTranslations().fromKey(LocaleKey.syncDocumentationNotice),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onTap: () => launchExternalURL(ExternalUrls.assistantAppsDocsSyncNotice),
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.portals)),
    );

    widgets.add(
      AsyncSettingTilePresenter(
        title: getTranslations().fromKey(LocaleKey.backupPortals),
        icon: Icons.file_download_sharp,
        futureFunc: () => asyncSettingTileGenericFunc(
          context,
          () async {
            FileService service = FileService();
            String jsonContent = viewModel.portalState.toGoogleJson();
            return service.saveFileLocally(
              jsonContent,
              'Please select a location to save the file',
              GoogleDrive.portalJson,
            );
          },
          LocaleKey.portalsNotUploaded,
          LocaleKey.portalsUploaded,
        ),
      ),
    );

    widgets.add(
      AsyncSettingTilePresenter(
        title: getTranslations().fromKey(LocaleKey.restorePortals),
        icon: Icons.file_open_rounded,
        futureFunc: () => asyncSettingTileWithSuccessFunc(
          context,
          () => FileService().readFileFromLocal(
            (jsonContent) => PortalState.fromGoogleJson(jsonContent),
          ),
          LocaleKey.portalsNotRestored,
          viewModel.restorePortals,
          LocaleKey.portalsRestored,
        ),
      ),
    );

    widgets.add(
      headingSettingTilePresenter(
          getTranslations().fromKey(LocaleKey.inventoryManagement)),
    );

    widgets.add(
      AsyncSettingTilePresenter(
        title: getTranslations().fromKey(LocaleKey.backupInventory),
        icon: Icons.file_download_sharp,
        futureFunc: () => asyncSettingTileGenericFunc(
          context,
          () async {
            FileService service = FileService();
            String jsonContent = viewModel.inventoryState.toGoogleJson();
            return service.saveFileLocally(
              jsonContent,
              'Please select a location to save the file',
              GoogleDrive.inventoryJson,
            );
          },
          LocaleKey.inventoryNotUploaded,
          LocaleKey.inventoryUploaded,
        ),
      ),
    );

    widgets.add(AsyncSettingTilePresenter(
      title: getTranslations().fromKey(LocaleKey.restoreInventory),
      icon: Icons.file_open_rounded,
      futureFunc: () => asyncSettingTileWithSuccessFunc(
        context,
        () => FileService().readFileFromLocal(
          (jsonContent) => InventoryState.fromGoogleJson(jsonContent),
        ),
        LocaleKey.inventoryNotRestored,
        viewModel.restoreInventory,
        LocaleKey.inventoryRestored,
      ),
    ));

    widgets.add(FlatCard(
      child: nomNomOpenSyncModalTile(context),
    ));

    // widgets.add(GenericItemDescription(
    //     'This sync feature is only intended to allow you to back up your app data to Google Drive.'));
    // widgets.add(LocalImage(imagePath:AppImage.underConstruction, height: 150.0));
    // widgets.add(const EmptySpace1x());
    // widgets.add(GenericItemDescription(
    //     'There is currently an issue with the Google Drive integration.'));
    // widgets.add(GenericItemDescription(
    //     'I am working on an alternative way to back up your app data'));

    widgets.add(const EmptySpace3x());

    return listWithScrollbar(
      key: Key('counter: ${rebuildCounter.toString()}'),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
