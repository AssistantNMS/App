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
import '../../contracts/generated/nomNomInventoryViewModel.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/redux/inventoryState.dart';
import '../../integration/dependencyInjection.dart';
import '../../integration/nomNom.dart';
import '../../redux/modules/viewModel/syncPageViewModel.dart';

class SyncWithNomNomBottomSheet extends StatefulWidget {
  const SyncWithNomNomBottomSheet({Key? key}) : super(key: key);

  @override
  createState() => _SyncWithNomNomBottomSheetState();
}

class _SyncWithNomNomBottomSheetState extends State<SyncWithNomNomBottomSheet> {
  NetworkState networkState = NetworkState.pending;

  Future<void> Function(String) codeInput(
    BuildContext innerContext,
    SyncPageViewModel viewModel,
  ) {
    return (String fullCode) async {
      setState(() {
        networkState = NetworkState.loading;
      });
      ResultWithValue<List<NomNomInventoryViewModel>> invResult =
          await getApiRepo().getInventoryFromNomNom(fullCode);
      if (invResult.hasFailed) {
        setState(() {
          networkState = NetworkState.error;
        });
        return;
      }

      try {
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
            icon: getInventoryIconsFromNomNomType(apiInv),
            name: apiInv.name,
            slots: newSlots,
          ));
        }
        viewModel.restoreInventory(InventoryState(
          containers: invs,
          orderByType: viewModel.inventoryState.orderByType,
        ));
      } catch (exception) {
        getLog().e(exception.toString());

        getDialog().showSimpleDialog(
          innerContext,
          "Something went wrong",
          Text(exception.toString()),
        );
      }

      getDialog().showSimpleDialog(
        innerContext,
        getTranslations().fromKey(LocaleKey.success) + '!',
        localImage(AppImage.base + 'inventory/special3.png', height: 100),
        buttonBuilder: (BuildContext buttonContext) => [
          getDialog().simpleDialogPositiveButton(
            buttonContext,
            title: LocaleKey.close,
            onTap: () => getNavigation().pop(buttonContext).then(
                  (value) => getNavigation().pop(innerContext),
                ),
          )
        ],
      );

      setState(() {
        networkState = NetworkState.success;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SyncPageViewModel>(
      converter: (store) => SyncPageViewModel.fromStore(store),
      builder: (BuildContext storeContext, SyncPageViewModel viewModel) {
        StreamController<ErrorAnimationType> errorController =
            StreamController<ErrorAnimationType>();

        List<Widget> widgets = List.empty(growable: true);
        widgets.add(emptySpace2x());
        widgets.add(genericItemName(
          getTranslations().fromKey(LocaleKey.nomNomCollaboration),
        ));
        widgets.add(genericItemDescription(
          getTranslations().fromKey(LocaleKey.nomNomCollaborationDesc),
        ));
        widgets.add(localImage(AppImage.nomNomHeader));
        widgets.add(emptySpace2x());
        widgets.add(positiveButton(
          context,
          title: getTranslations().fromKey(LocaleKey.instructions),
          onPress: () => getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateToNamed: Routes.nomNomInventoryTutorial,
          ),
        ));
        widgets.add(emptySpace2x());

        if (networkState == NetworkState.error) {
          widgets.add(Center(
            child: genericItemGroup(
              getTranslations().fromKey(LocaleKey.somethingWentWrong),
            ),
          ));
        }

        if (networkState == NetworkState.loading) {
          widgets.add(Center(child: getLoading().smallLoadingIndicator()));
        } else {
          widgets.add(Padding(
            padding: const EdgeInsets.all(32),
            child: PinCodeTextField(
              length: 5,
              obscureText: false,
              appContext: context,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
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
              onCompleted: codeInput(context, viewModel),
              onChanged: (value) {},
            ),
          ));
        }

        // if (networkState == NetworkState.success) {
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
