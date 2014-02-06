part of gcanvas;

class StoreCtrl {
  Store addressStore;
  Store residentsStore;

  StoreCtrl() {
    addressStore = new Store("gcanvas", "addresses");

    residentsStore = new Store("gcanvas", "residents");
  }


  Future<bool> _open() {
    Completer<bool> completer = new Completer<bool>();

    if(addressStore.isOpen && residentsStore.isOpen) {
      completer.complete(true);
    } else {
      if(!addressStore.isOpen) {
        addressStore.open().then((_) {
          if(!residentsStore.isOpen) {
            residentsStore.open().then((_) {
              completer.complete(true);
            });
          } else {
            completer.complete(true);
          }
        });
      } else {
        residentsStore.open().then((_) => completer.complete(true));
      }
    }

    return completer.future;
  }

  Future<int> addAddress(Address address) {
    Completer<int> completer = new Completer<int>();

    _open().then((_) {
      addressStore.save(address.toMap(), "${address.id}").then((key) {
        completer.complete(int.parse(key));
      });
    });

    return completer.future;
  }


  Future<Address> getAddressById(int id) {
    Completer<Address> completer = new Completer<Address>();

    _open().then((_) {
      addressStore.getByKey("${id}").then((map) {
        Address address = new Address.fromMap(map);
        completer.complete(address);
      });
    });

    return completer.future;
  }


  Future<List<Address>> getAddressList() {
    Completer<List<Address>> completer = new Completer<List<Address>>();

    _open().then((_) {
      addressStore.all().toList().then((values) {
        List<Address> addresses = new List<Address>();
        for(var map in values) {
          addresses.add(new Address.fromMap(map));
        }
        completer.complete(addresses);
      });
    });

    return completer.future;
  }



  Future<bool> removeAddress(Address address) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      addressStore.removeByKey("${address.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }



  Future<int> addResident(Resident resident) {
    Completer<int> completer = new Completer<int>();

    _open().then((_) {
      residentsStore.save(resident.toMap(), "${resident.id}").then((key) {
        completer.complete(int.parse(key));
      });
    });


    return completer.future;
  }


  Future<Resident> getResidentById(int id) {
    Completer<Resident> completer = new Completer<Resident>();

    _open().then((_) {
      residentsStore.getByKey("${id}").then((map) {
        Resident resident = new Resident.fromMap(map);
        completer.complete(resident);
      });
    });

    return completer.future;
  }


  Future<List<Resident>> getResidentsAtAddress(Address address) {
    Completer<List<Resident>> completer = new Completer<List<Resident>>();

    _open().then((_) {
      residentsStore.all().where((resident) => resident['address']['id'] == address.id).toList().then((values) {
        List<Resident> residents = new List<Resident>();
        for(var map in values) {
          residents.add(new Resident.fromMap(map));
        }

        completer.complete(residents);
      });
    });

    return completer.future;
  }



  Future<bool> removeResident(Resident resident) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      residentsStore.removeByKey("${resident.id}").then((_) => completer.complete(true));
    });

    return completer.future;
  }
}