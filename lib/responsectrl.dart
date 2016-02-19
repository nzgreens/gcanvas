part of gcanvas.client;

class ResidentResponseCtrl extends JsProxy {
  Future<Store> _storeCtrl;

  ResidentResponseCtrl([this._storeCtrl]);

  factory ResidentResponseCtrl.create() {
    return new ResidentResponseCtrl(Store.open("gcanvas", "response"));
  }

  Future<bool> _open() async {
    var store = await _storeCtrl;

    return store != null;
  }


  Future<bool> add(ResidentResponse response) async {

    await _open();
    var data = JSON.encode(response.toMap());

    Store store = await _storeCtrl.then((store) => store);


    var key = await store.save(data, "${response.id}");

    return key != null;
  }


  Future<List<ResidentResponse>> getResidentResponses() async {
    bool opened = await _open();
    if(opened) {
      Store store = await _storeCtrl;

      List response = (await store.all().toList()).map((response) => new ResidentResponse.fromMap(JSON.decode(response))).toList();

      return response;
    }

    return [];
  }


  Future<bool> remove(ResidentResponse response) async {
    bool opened = await _open();
    if(opened) {
      Store store = await _storeCtrl.then((store) => store);
      String key = await store.removeByKey("${response.id}");

      return key != null;
    }

    return false;
  }
}
