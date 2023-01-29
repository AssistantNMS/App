import '../../../contracts/redux/portalState.dart';

import '../../../contracts/portal/portal_record.dart';
import '../base/persistToStorage.dart';

class AddPortalAction extends PersistToStorage {
  final PortalRecord portalRecord;
  AddPortalAction(this.portalRecord);
}

class EditPortalAction extends PersistToStorage {
  final PortalRecord portalRecord;
  EditPortalAction(this.portalRecord);
}

class RemovePortalAction extends PersistToStorage {
  final String uuid;
  RemovePortalAction(this.uuid);
}

class RemoveAllPortalsAction extends PersistToStorage {
  RemoveAllPortalsAction();
}

class AddPortalTagAction extends PersistToStorage {
  String newTag;
  AddPortalTagAction(this.newTag);
}

class RemovePortalTagAction extends PersistToStorage {
  String oldTag;
  RemovePortalTagAction(this.oldTag);
}

class RestorePortalsAction extends PersistToStorage {
  PortalState newState;
  RestorePortalsAction(this.newState);
}
