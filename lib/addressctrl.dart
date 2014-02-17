part of gcanvas.client;


@reflectable
class AddressListCtrl {
  @reflectable StoreCtrl _storeCtrl;

  AddressListCtrl(this._storeCtrl);


  factory AddressListCtrl.create() {
    return new AddressListCtrl(new StoreCtrl.create());
  }


  Future<int> add(Address addr) {
    Completer<int> completer = new Completer<int>();

    _storeCtrl.addAddress(addr).then((val){
      getList().then((_) {
        completer.complete(val);
      });

    });

    return completer.future;
  }


  Future<bool> remove(Address addr) {
    Completer<bool> completer = new Completer<bool>();
    _storeCtrl.removeAddress(addr).then((result) {
      getList().then((_) {
        completer.complete(result);
      });
    });

    return completer.future;
  }


  Future<List<Address>> getList() {
    Completer<List<Address>> completer = new Completer<List<Address>>();

    _storeCtrl.getAddressList().then((addrList) {
      completer.complete(addrList);
    });

    return completer.future;
  }


  Future<bool> update(Address addr) {
    return add(addr).then((id) {
      return new Future.value(addr.id == id);
    });
  }
}
