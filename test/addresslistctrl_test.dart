part of gcanvas_test;


void addresslistctrl_test() {
  group("[Address List Ctrl]", () {
    var voter = new Resident.create(
        id: 1,
        firstname: "Bob",
        lastname: "Kate",
        dob: new DateTime(1973, 4, 10)
        //address: address
        );

    var voter2 = new Resident.create(
        id: 2,
        firstname: "Bobby",
        lastname: "Kate",
        dob: new DateTime(1973, 4, 10)
        //address: address2
        );

    var voter3 = new Resident.create(
        id: 3,
        firstname: "Bobby3",
        lastname: "Kate",
        dob: new DateTime(1973, 4, 10)
        //address: address2
        );

    var address = new Address.create(
        id: 1.toString(),
        address1: "48 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false,
        residents: [voter]
    );

    var address2 = new Address.create(
        id: 2.toString(),
        address1: "50 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false,
        residents: [voter2]
    );

    var address3 = new Address.create(
        id: 3.toString(),
        address1: "52 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false,
        residents: [voter3]
    );

    var store;// = new Store();
    var addressMap = {"${address.id}": address.toMap(), "${address2.id}": address2.toMap()};
    var addressList = [address, address2];
    var addressCtrl;


    setUp(() async {
        store = await Store.open('test', 'address');
        addressCtrl = new AddressListCtrl(new Future.value(store));
        return store.nuke().then((_) => store.batch(addressMap));
    });

    tearDown(() {
      store.nuke();
    });



    test("gets an address list", () {
      schedule(() {
        Future future = addressCtrl.getList();
        future.then((addresses){
          expect(addresses, hasLength(2));
          expect(addresses.map((addr) => addr.toMap()), equals(addressList.map((addr) => addr.toMap())));
        });
        expect(future, completes);

        return future;
      });
    });


    test("adds an address", () {
      schedule(() {
        var expectedId = address3.id;
        Future<String> future = addressCtrl.add(address3);
        future.then((id) {
          expect(id, equals(expectedId));
        });
        expect(future, completes);

        return future;
      });
    });



    test("removes an address", () {
      schedule(() {
        Future<bool> future = addressCtrl.remove(address2);
        future.then((success) {
          expect(success, isTrue);
        });
        expect(future, completes);

        return future;
      });
    });


    test("updates an address", () {
      schedule(() {
        address3.visited = true;
        Future<bool> future = addressCtrl.update(address3);
        future.then((success) {
          expect(success, isTrue);
        });
        expect(future, completes);

        return future;
      });
    });
  });
}