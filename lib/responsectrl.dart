part of gcanvas.client;

class ResidentResponseCtrl extends Observable {
  final Store _storeCtrl;

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
      var data;
      if(!detect.browser.isSafari) {
        data = response.toMap();
      } else {
        data = JSON.encode(response.toMap());
      }
      _storeCtrl.save(data, "${response.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }


  Future<List<ResidentResponse>> getResidentResponses() {
    Completer<List<ResidentResponse>> completer = new Completer<List<ResidentResponse>>();

    _open().then((_) {
      if(!detect.browser.isSafari) {
        _storeCtrl.all().toList().then((responses) => completer.complete(responses.map((response) => new ResidentResponse.fromMap(response)).toList()));
      } else {
        _storeCtrl.all().toList().then((responses) => completer.complete(responses.map((response) => new ResidentResponse.fromMap(JSON.decode(response))).toList()));
      }
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
