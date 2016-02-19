part of gcanvas.client;


class AddressListCtrl extends JsProxy {
  @reflectable Future<Store> futureStore;
  @reflectable Store dataStore;
  @reflectable bool isOpen = false;

  AddressListCtrl({this.futureStore, this.dataStore});


  factory AddressListCtrl.create() {
    return new AddressListCtrl(futureStore: Store.open("gcanvas", "addresses"));
  }



  Future<bool> _open() async {
    if(!isOpen) {
      try {
        dataStore = await futureStore;
        isOpen = dataStore != null;
      } catch(e) {
        print('error');
        isOpen = false;
      }
    }

    return isOpen;
  }


  Future<bool> _add(addr) async {
    var data = JSON.encode(addr.toMap());
    try {
      var key = await dataStore.save(data, "${addr.id}");

      return key == "${addr.id}";
    } catch(e) {
      print(e);
    }

    return false;
  }

  Future<bool> add(Address addr) async {
    if(!isOpen) await _open();

    return _add(addr);
  }


  Future<bool> remove(Address addr) async {
    if(!isOpen) await _open();
    try {
      var val = await dataStore.removeByKey("${addr.id}");

      return val == addr.id;
    } catch(e) {
      print(e);
    }

    return false;
  }


  Future<List<Address>> getList() async {
    if(!isOpen) await _open();
    try {
      List values = await dataStore.all().toList();
      List<Address> addresses = new List<Address>();
      values.forEach((map) {
        var data;
        if (map is Map) {
          data = map;
        } else {
          data = JSON.decode(map);
        }
        Address address = new Address.fromMap(data);
        addresses.add(address);
        print(address.toMap());
      });
      print('got addresses and now returning them');

      return addresses;
    } catch(e) {
      print(e);
    }
  }


  Future<bool> update(Address addr) async {
    try {
      var id = await add(addr);

      return addr.id == id;
    } catch(e) {
      print(e);
    }

    return false;
  }

  Future<bool> clear() async {
    if(!isOpen) await _open();

    await dataStore.nuke();

    return true;
  }
}
