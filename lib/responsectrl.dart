part of gcanvas.client;

@reflectable
class ResidentResponseCtrl {
  @reflectable final Store _storeCtrl;

  ResidentResponseCtrl([this._storeCtrl]);

  factory ResidentResponseCtrl.create() {
    return new ResidentResponseCtrl(new Store("gcanvas", "response"));
  }


  Future<bool> _open() {
    Completer<bool> completer = new Completer<bool>();

    if(_storeCtrl.isOpen) {
      completer.complete(true);
    } else {
      _storeCtrl.open().then((_) => completer.complete(true));
    }

    return completer.future;
  }


  Future<bool> add(ResidentResponse response) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _storeCtrl.save(response.toMap(), "${response.id}").then((key) => completer.complete(true));
    });

    return completer.future;
  }


  Future<List<ResidentResponse>> getResidentResponses() {
    Completer<List<ResidentResponse>> completer = new Completer<List<ResidentResponse>>();

    _open().then((_) {
      _storeCtrl.all().toList().then((responses) => completer.complete(responses.map((response) => new ResidentResponse.fromMap(response)).toList()));
    });

    return completer.future;
  }


  Future<bool> remove(ResidentResponse response) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _storeCtrl.removeByKey("${response.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }
}
