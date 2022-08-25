import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantapps_flutter_common/contracts/enum/networkState.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:assistantnms_app/contracts/generated/nomNomInventoryViewModel.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/AppDuration.dart';
import '../../constants/Modal.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/shareViewModel.dart';
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
                // viewModel.restoreInventory();

                setState(() {
                  networkState = NetworkState.Success;
                });
              },
              onChanged: (value) {},
            ),
          ));
        }

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
