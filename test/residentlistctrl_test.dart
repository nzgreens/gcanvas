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
        lastname: "Kate"
        //new DateTime(1973, 4, 10),
        //address: address
        );

    var voter2 = new Resident.create(
        id: 2,
        firstname: "Bobby",
        lastname: "Kate"
        //new DateTime(1973, 4, 10),
        //address: address2
        );

    var voter3 = new Resident.create(
        id: 3,
        firstname: "Bobby3",
        lastname: "Kate"
        //new DateTime(1973, 4, 10),
        //address: address2
        );

    var residentMap = {"${voter2.id}": voter2.toMap(), "${voter3.id}": voter3.toMap()};
    var residentList = [voter2, voter3];
    var store = new Store("test", "residents");
    var residentCtrl = new ResidentListCtrl(store);

    setUp((){
      schedule(() {
        return store.open().then((_) => store.nuke().then((_) => store.batch(residentMap)));
      });
      currentSchedule.onComplete.schedule(() => store.nuke());
    });



    test("add a resident", () {
      schedule(() {
        Future<bool> future = residentCtrl.add(voter);
        future.then((success) {
          expect(success, isTrue);
        });
        expect(future, completes);

        return future;
      });
    });



    test("remove a resident", () {
      schedule(() {
        Future<bool> future = residentCtrl.remove(voter);
        future.then((success) {
          expect(success, isTrue);
        });
        expect(future, completes);

        return future;
      });
    });


    test("gets resident list", () {
      schedule(() {
        Future<List<Resident>> future = residentCtrl.getResidents();
        future.then((residents) {
          expect(residents.map((resident) => resident.toMap()).toList(), equals(residentList.map((resident) => resident.toMap()).toList()));
        });
        expect(future, completes);

        return future;
      });
    });
  });
}