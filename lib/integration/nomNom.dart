import '../contracts/generated/nomNomInventoryViewModel.dart';

String getInventoryIconsFromNomNomType(NomNomInventoryViewModel apiInv) {
  if (apiInv.type == NomNomInventoryType.exosuit) return 'special0.png';
  if (apiInv.type == NomNomInventoryType.starship) return 'starship.png';
  if (apiInv.type == NomNomInventoryType.roamer) return 'vehicle1.png';
  if (apiInv.type == NomNomInventoryType.nomad) return 'vehicle5.png';
  if (apiInv.type == NomNomInventoryType.pilgrim) return 'vehicle2.png';
  if (apiInv.type == NomNomInventoryType.colossus) return 'vehicle4.png';
  if (apiInv.type == NomNomInventoryType.minotaur) return 'vehicle6.png';
  if (apiInv.type == NomNomInventoryType.nautilon) return 'vehicle3.png';
  if (apiInv.type == NomNomInventoryType.freighter) return 'freighter.png';
  if (apiInv.type == NomNomInventoryType.multiTool) return 'multitool.png';

  if (apiInv.type == NomNomInventoryType.nutrientProcessor) {
    return 'cooking.png';
  }

  if (apiInv.type == NomNomInventoryType.storageContainer0) {
    return 'container0.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer1) {
    return 'container1.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer2) {
    return 'container2.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer3) {
    return 'container3.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer4) {
    return 'container4.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer5) {
    return 'container5.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer6) {
    return 'container6.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer7) {
    return 'container7.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer8) {
    return 'container8.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer9) {
    return 'container9.png';
  }
  if (apiInv.type == NomNomInventoryType.storageContainer9) {
    return 'container9.png';
  }

  return 'unknown.png';
}
