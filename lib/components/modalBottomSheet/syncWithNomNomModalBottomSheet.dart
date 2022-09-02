import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/AppDuration.dart';
import '../../constants/AppImage.dart';
import '../../constants/Modal.dart';
import '../../constants/Routes.dart';
import '../../constants/NmsUIConstants.dart';
import '../../constants/UserSelectionIcons.dart';
import '../../contracts/generated/nomNomInventoryViewModel.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/redux/inventoryState.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/viewModel/syncPageViewModel.dart';

class SyncWithNomNomBottomSheet extends StatefulWidget {
  const SyncWithNomNomBottomSheet({Key key}) : super(key: key);

  @override
  createState() => _SyncWithNomNomBottomSheetState();
}

class _SyncWithNomNomBottomSheetState extends State<SyncWithNomNomBottomSheet> {
  NetworkState networkState = NetworkState.Pending;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SyncPageViewModel>(
      converter: (store) => SyncPageViewModel.fromStore(store),
      builder: (BuildContext storeContext, SyncPageViewModel viewModel) {
        StreamController<ErrorAnimationType> errorController =
            StreamController<ErrorAnimationType>();

        List<Widget> widgets = List.empty(growable: true);
        widgets.add(emptySpace2x());
        widgets.add(genericItemName('NomNom collaboration'));
        widgets.add(genericItemDescription(
            'Sync your in game inventory with the app through the NomNom save editor!\nOnly available for PC'));
        widgets.add(localImage(AppImage.nomNomHeader));
        widgets.add(emptySpace2x());
        widgets.add(positiveButton(
          context,
          title: 'Instructions',
          onPress: () => getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateToNamed: Routes.nomNomInventoryTutorial,
          ),
        ));
        widgets.add(emptySpace2x());

        if (networkState == NetworkState.Error) {
          widgets.add(Center(
            child: genericItemGroup(
              getTranslations().fromKey(LocaleKey.somethingWentWrong),
            ),
          ));
        }

        if (networkState == NetworkState.Loading) {
          widgets.add(Center(child: getLoading().smallLoadingIndicator()));
        } else {
          widgets.add(Padding(
            padding: const EdgeInsets.all(32),
            child: PinCodeTextField(
              length: 5,
              obscureText: false,
              appContext: context,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: getTheme().getSecondaryColour(context),
                activeColor: Colors.black,
                selectedColor: getTheme().getSecondaryColour(context),
                selectedFillColor: getTheme().getSecondaryColour(context),
                inactiveFillColor:
                    getTheme().getScaffoldBackgroundColour(context),
                inactiveColor: getTheme().getBackgroundColour(context),
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              cursorColor: Colors.black,
              textStyle: const TextStyle(color: Colors.black),
              errorAnimationController: errorController,
              controller: TextEditingController(),
              onCompleted: (String fullCode) async {
                setState(() {
                  networkState = NetworkState.Loading;
                });
                ResultWithValue<List<NomNomInventoryViewModel>> invResult =
                    await getApiRepo().getInventoryFromNomNom(fullCode);
                if (invResult.hasFailed) {
                  setState(() {
                    networkState = NetworkState.Error;
                  });
                  return;
                }

                List<Inventory> invs = List.empty(growable: true);
                for (NomNomInventoryViewModel apiInv in invResult.value) {
                  List<InventorySlot> newSlots = List.empty(growable: true);
                  for (NomNomInventorySlotViewModel apiSlots in apiInv.slots) {
                    newSlots.add(InventorySlot(
                      uuid: getNewGuid(),
                      quantity: apiSlots.quantity,
                      id: apiSlots.appId,
                    ));
                  }
                  invs.add(Inventory(
                    icon: UserSelectionIcons
                        .nomNomInventoryTypeIcons[apiInv.type],
                    name: apiInv.name,
                    slots: newSlots,
                  ));
                }
                viewModel.restoreInventory(InventoryState(
                  containers: invs,
                  orderByType: viewModel.inventoryState.orderByType,
                ));

                // setState(() {
                //   networkState = NetworkState.Success;
                // });

                await getNavigation().popUntil(
                  context,
                  [
                    Routes.inventoryList,
                    Routes.syncPage,
                    Routes.catalogueHome,
                    Routes.customHome,
                    Routes.home,
                  ],
                );
              },
              onChanged: (value) {},
            ),
          ));
        }

        // if (networkState == NetworkState.Success) {
        //   Future.delayed(const Duration(milliseconds: 250)).then(
        //     (value) => getSnackbar().showSnackbar(
        //       context,
        //       LocaleKey.success,
        //       onPositive: (() async {
        //         await getNavigation().pop(context);
        //         await getNavigation().pop(context);
        //       }),
        //     ),
        //   );
        // }

        widgets.add(emptySpace8x());

        return AnimatedSize(
          duration: AppDuration.modal,
          child: Container(
            constraints: modalDefaultSize(context),
            child: ListView.builder(
              padding: NMSUIConstants.buttonPadding,
              itemCount: widgets.length,
              itemBuilder: (_, int index) => widgets[index],
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }
}
