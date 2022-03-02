import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/GoogleDrive.dart';
import '../contracts/redux/inventoryState.dart';
import '../contracts/redux/portalState.dart';
import '../integration/google.dart';
import '../integration/googleDrive.dart';

// ----------------------- PORTAL ----------------------- //
Future<Result> writePortalJsonFileToGoogleDrive(
    GoogleSignInAccount account, String data) async {
  Result newWayResult =
      await writeJsonFileToGoogleDrive(account, GoogleDrive.portalJson, data);
  getLog().d(
    'writePortalJsonFileToGoogleDrive new way worked: ' +
        newWayResult.isSuccess.toString(),
  );
  // if (newWayResult.isSuccess) return newWayResult;
  // Result oldWayResult =
  //     await writeJsonFileToGoogleDriveOLD(GoogleDrive.portalJsonOLD, data);
  // getLog().d(
  //   'writePortalJsonFileToGoogleDrive old way worked: ' +
  //       oldWayResult.isSuccess.toString(),
  // );
  // return oldWayResult;
  return newWayResult;
}

Future<ResultWithValue<PortalState>> readPortalJsonFileFromGoogleDrive(
    GoogleSignInAccount account) async {
  ResultWithValue<PortalState> newWayResult =
      await readGenericJsonFileFromGoogleDrive(
    account,
    GoogleDrive.portalJson,
    (Map<String, dynamic> json) => PortalState.fromJson(json),
  );
  getLog().d(
    'readPortalJsonFileFromGoogleDrive new way worked: ' +
        newWayResult.isSuccess.toString(),
  );
  if (newWayResult.isSuccess) return newWayResult;
  ResultWithValue<PortalState> oldWayResult =
      await readGenericJsonFileFromGoogleDriveOLD(
    GoogleDrive.portalJsonOLD,
    (Map<String, dynamic> json) => PortalState.fromJson(json),
  );
  getLog().d(
    'readPortalJsonFileFromGoogleDrive old way worked: ' +
        oldWayResult.isSuccess.toString(),
  );
  return oldWayResult;
}

// ----------------------- INVENTORY ----------------------- //
Future<Result> writeInventoryJsonFileToGoogleDrive(
    GoogleSignInAccount account, String data) async {
  Result newWayResult = await writeJsonFileToGoogleDrive(
      account, GoogleDrive.inventoryJson, data);
  getLog().d(
    'writeInventoryJsonFileToGoogleDrive new way worked: ' +
        newWayResult.isSuccess.toString(),
  );
  // if (newWayResult.isSuccess) return newWayResult;
  // Result oldWayResult =
  //     await writeJsonFileToGoogleDriveOLD(GoogleDrive.inventoryJsonOLD, data);
  // getLog().d(
  //   'writeInventoryJsonFileToGoogleDrive old way worked: ' +
  //       oldWayResult.isSuccess.toString(),
  // );
  // return oldWayResult;
  return newWayResult;
}

Future<ResultWithValue<InventoryState>> readInventoryJsonFileFromGoogleDrive(
    GoogleSignInAccount account) async {
  ResultWithValue<InventoryState> newWayResult =
      await readGenericJsonFileFromGoogleDrive(
    account,
    GoogleDrive.inventoryJson,
    (Map<String, dynamic> json) => InventoryState.fromJson(json),
  );
  getLog().d(
    'readInventoryJsonFileFromGoogleDrive new way worked: ' +
        newWayResult.isSuccess.toString(),
  );
  if (newWayResult.isSuccess) return newWayResult;
  ResultWithValue<InventoryState> oldWayResult =
      await readGenericJsonFileFromGoogleDriveOLD(
    GoogleDrive.inventoryJsonOLD,
    (Map<String, dynamic> json) => InventoryState.fromJson(json),
  );
  getLog().d(
    'readInventoryJsonFileFromGoogleDrive old way worked: ' +
        oldWayResult.isSuccess.toString(),
  );
  return oldWayResult;
}
