part of gcanvas.client;


/**
 * Only used to store orphan residents, who are found not to live at an address
 * and it's not known where they live now.
 */
class ResidentListCtrl extends Observable {
  final Store _storeCtrl;

  ResidentListCtrl([this._storeCtrl]);

  Future<bool> _open() {
    Completer<bool> completer = new Completer<bool>();

    if(_storeCtrl.isOpen) {
      completer.complete(true);
    } else {
      _storeCtrl.open().then((_) => completer.complete(true));
    }

    return completer.future;
  }


  Future<bool> add(Resident resident) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _storeCtrl.save(resident.toMap(), "${resident.id}").then((key) => completer.complete(true));
    });

    return completer.future;
  }


  Future<List<Resident>> getResidents() {
    Completer<List<Resident>> completer = new Completer<List<Resident>>();

    _open().then((_) {
      _storeCtrl.all().toList().then((residents) => completer.complete(residents.map((resident) => new Resident.fromMap(resident)).toList()));
    });

    return completer.future;
  }


  Future<bool> remove(Resident resident) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _storeCtrl.removeByKey("${resident.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }
}