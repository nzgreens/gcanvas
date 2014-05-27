part of gcanvas.client;


@reflectable
class AddressListCtrl {
  @reflectable Store _store;

  AddressListCtrl([this._store]);


  factory AddressListCtrl.create() {
    return new AddressListCtrl(new Store("gcanvas", "addresses"));
  }


  Future<bool> _open() {
    return _store.open();
  }


  Future<String> add(Address addr) {
    Completer<String> completer = new Completer<String>();

    _open().then((_) {
      _store.save(addr.toMap(), "${addr.id}").then((key) {
        completer.complete(key);
      });
    });

    return completer.future;
  }


  Future<bool> remove(Address addr) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _store.removeByKey("${addr.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }


  Future<List<Address>> getList() {
    Completer<List<Address>> completer = new Completer<List<Address>>();
    safariPrint("AddressListCtrl.getList");
    _open().then((_) {
      safariPrint("AddressListCtrl.getList2");
      _store.all().toList().then((values) {
        safariPrint("AddressListCtrl.getList3");
        List<Address> addresses = new List<Address>();
        for(var map in values) {
          safariPrint("AddressListCtrl.getList3b: ${map == null}");
          safariPrint("AddressListCtrl.getList3b: $map");
          addresses.add(new Address.fromMap(map));
        }
        safariPrint("AddressListCtrl.getList4");
        completer.complete(addresses);
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
