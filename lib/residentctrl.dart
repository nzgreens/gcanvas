part of gcanvas.client;


/**
 * Only used to store orphan residents, who are found not to live at an address
 * and it's not known where they live now.
 */
class ResidentListCtrl extends JsProxy {
  final Future<Store> _storeCtrl;

  ResidentListCtrl([this._storeCtrl]);

  Future<bool> _open() async {
    var store = _storeCtrl.then((store) => store);

    return store != null;
  }


  Future<bool> add(Resident resident) async {
    bool opened = await _open();
    if(opened) {
      var data = JSON.encode(resident.toMap());
      Store store = await _storeCtrl.then((store) => store);
      String key = await store.save(data, "${resident.id}");

      return key != null;
    }

    return false;
  }


  Future<List<Resident>> getResidents() async {
    bool opened = await _open();
    if(opened) {
      Store store = await _storeCtrl.then((store) => store);
      List<Resident> residents = (await store.all().toList()).map((entry) => new Resident.fromMap(JSON.decode(entry))).toList();

      return residents;
    }

    return [];
  }


  Future<bool> remove(Resident resident) async {
    bool opened = await _open();
    if(opened) {
      Store store = await _storeCtrl.then((store) => store);
      return await store.removeByKey("${resident.id}").then((_) => true);
    }

    return false;
  }
}