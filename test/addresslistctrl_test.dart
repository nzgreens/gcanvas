part of gcanvas_test;

class StoreCtrlMock extends Mock implements StoreCtrl {}

class HttpMock extends Mock implements DelayedHttp {}

void addresslistctrl_test() {
  group("[Address List Ctrl]", () {
    var address = new Address.create(
        id: 1,
        street: "48 Bignell street",
        suburb: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    var address2 = new Address.create(
        id: 2,
        street: "50 Bignell street",
        suburb: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    var address3 = new Address.create(
        id: 3,
        street: "52 Bignell street",
        suburb: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    var store = new StoreCtrlMock();
    var addressList = [address, address2];
    var addressCtrl = new AddressListCtrl(store);


    setUp((){
      store.when(callsTo('getAddressList'))
        ..thenReturn(new Future.value(addressList));
      store.when(callsTo('addAddress', address3))
        ..thenReturn(new Future.value(address3.id));
      store.when(callsTo('removeAddress', address2))
              ..thenReturn(new Future.value(true));

    });



    test("gets an address list", () {
      schedule(() {
        Future future = addressCtrl.getList();
        future.then((addresses){
          expect(addresses, hasLength(2));
          expect(addresses, equals(addressList));
        });
        expect(future, completes);
        store.getLogs(callsTo('getAddressList')).verify(happenedOnce);

        return future;
      });
    });


    test("adds an address", () {
      schedule(() {
        var expectedId = address3.id;
        Future<int> future = addressCtrl.add(address3);
        future.then((id) {
          expect(id, equals(expectedId));
        });
        expect(future, completes);
        store.getLogs(callsTo('addAddress')).verify(happenedAtLeastOnce);

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
        store.getLogs(callsTo('removeAddress')).verify(happenedOnce);

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
        store.getLogs(callsTo('addAddress')).verify(happenedAtLeastOnce);

        return future;
      });
    });
  });
}