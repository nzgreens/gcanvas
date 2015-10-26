part of gcanvas.client;


class AddressListCtrl extends JsProxy {
  @reflectable Future<Store> _store;

  AddressListCtrl([this._store]);


  factory AddressListCtrl.create() {
    return new AddressListCtrl(Store.open("gcanvas", "addresses"));
  }


  Future<bool> _open() {
    return _store.then((store) => store != null);
  }


  Future<String> add(Address addr) {
    Completer<String> completer = new Completer<String>();

    _open().then((_) {
      String data = JSON.encode(addr.toMap());
      _store.then((store) {
        store.save(data, "${addr.id}").then((key) {
          completer.complete(key);
        });
      });
    });

    return completer.future;
  }


  Future<bool> remove(Address addr) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _store.then((store) => store.removeByKey("${addr.id}").then((_) => completer.complete(true)));
    });

    return completer.future;
  }


  Future<List<Address>> getList() {
    Completer<List<Address>> completer = new Completer<List<Address>>();
    _open().then((_) {
      _store.then((store){
          store.all().toList().then((values) {
            List<Address> addresses = new List<Address>();
            for(var map in values) {
              var data;
              if(!detect.browser.isSafari) {
                data = map;
              } else {
                data = JSON.decode(map);
              }
              addresses.add(new Address.fromMap(data));
            }
            completer.complete(addresses);
          });
        });
      });

    return completer.future;
  }


  Future<bool> update(Address addr) {
    return add(addr).then((id) {
      return new Future.value(addr.id == id);
    });
  }
}
