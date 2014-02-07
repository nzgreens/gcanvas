part of gcanvas_test;

class StoreCtrlMock extends Mock implements StoreCtrl {

}


class HttpMock extends Mock implements Http {}

void addresslistctrl_test() {
  group("[Address List Ctrl]", () {
    var address = new Address(
        1,
        "48 Bignell street",
        "Gonville",
        "Wanganui",
        "4501",
        169.201928,
        49.21112);

    var address2 = new Address(
        2,
        "50 Bignell street",
        "Gonville",
        "Wanganui",
        "4501",
        169.201928,
        49.21112);

    var address3 = new Address(
        3,
        "52 Bignell street",
        "Gonville",
        "Wanganui",
        "4501",
        169.201928,
        49.21112);

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
      Future future = addressCtrl.getList();
      future.then((addresses){
        expect(addresses, hasLength(2));
        expect(addresses, equals(addressList));
      });
      expect(future, completes);
      store.getLogs(callsTo('getAddressList')).verify(happenedOnce);
    });


    test("adds an address", () {
      var expectedId = address3.id;
      Future<int> future = addressCtrl.add(address3);
      future.then((id) {
        expect(id, equals(expectedId));
      });
      expect(future, completes);
      store.getLogs(callsTo('addAddress')).verify(happenedOnce);
    });



    test("removes an address", () {
      Future<bool> future = addressCtrl.remove(address2);
      future.then((success) {
        expect(success, isTrue);
      });
      expect(future, completes);
      store.getLogs(callsTo('removeAddress')).verify(happenedOnce);
    });
  });
}