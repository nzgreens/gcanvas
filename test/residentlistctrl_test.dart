part of gcanvas_test;


void residentlistctrl_test() {
  group("[ResidentListCtrl]", () {
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


    var voter = new Resident.create(
        id: 1,
        firstname: "Bob",
        lastname: "Kate",
        //new DateTime(1973, 4, 10),
        address: address);

    var voter2 = new Resident.create(
        id: 2,
        firstname: "Bobby",
        lastname: "Kate",
        //new DateTime(1973, 4, 10),
        address: address2);

    var voter3 = new Resident.create(
        id: 3,
        firstname: "Bobby3",
        lastname: "Kate",
        //new DateTime(1973, 4, 10),
        address: address2);

    var residentList = [voter2, voter3];
    var store = new StoreCtrlMock();
    var residentCtrl = new ResidentListCtrl(store);

    setUp((){
      store.when(callsTo('getResidentsAtAddress', address2))
        ..thenReturn(new Future.value(residentList));
      store.when(callsTo('addResident', voter3))
        ..thenReturn(new Future.value(voter3.id));
      store.when(callsTo('removeResident', voter2))
        ..thenReturn(new Future.value(true));
    });



    test("resident list at address2", () {
      Future future = residentCtrl.getResidentsAtAddress(address2);
      future.then((residents){
        expect(residents, hasLength(2));
        expect(residents, equals(residentList));
      });
      expect(future, completes);
      store.getLogs(callsTo('getResidentsAtAddress')).verify(happenedOnce);
    });



    test("add a resident", () {
      var expectedId = voter3.id;
      Future<int> future = residentCtrl.add(voter3);
      future.then((id) {
        expect(id, equals(expectedId));
      });
      expect(future, completes);
      store.getLogs(callsTo('addResident')).verify(happenedOnce);
    });



    test("remove a resident", () {
      Future<bool> future = residentCtrl.remove(voter2);
      future.then((success) {
        expect(success, isTrue);
      });
      expect(future, completes);
      store.getLogs(callsTo('removeResident')).verify(happenedOnce);
    });
  });
}