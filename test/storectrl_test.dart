part of gcanvas_test;


void storectrl_test() {
  group("[gcanvas StoreCtrl]", () {
      var storeCtrl = new StoreCtrl.create();

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


      setUp(() {
        schedule(() {
          Completer completer = new Completer();
          var batched = {"2": address2.toMap(), "3": address3.toMap()};
          storeCtrl.addressStore.open()
            .then((_) => storeCtrl.addressStore.nuke())
            .then((_) => storeCtrl.addressStore.batch(batched)).then((_) => completer.complete());

          print("setup");

          return completer.future;
        });
      });


      test("adds an address", () {
        schedule(() {
          Future future = storeCtrl.addAddress(address);

          future.then((id) {
            expect(id, equals(address.id));
            var check = storeCtrl.addressStore.getByKey("${address.id}");
            check.then((addr) {
              expect(address.toMap(), equals(addr));
            });
            expect(check, completes);
          });

          expect(future, completes);

          return future;
        });
      });


      test("retreives an address", () {
        schedule(() {
          Future future = storeCtrl.getAddressById(2);
          future.then((address) {
            expect(address.id, equals(address2.id));
            expect(address.address1, equals(address2.address1));
            expect(address.address2, equals(address2.address2));
            expect(address.city, equals(address2.city));
            expect(address.postcode, equals(address2.postcode));
          });
          expect(future, completes);

          return future;
        });
      });



      test("gets a list of all addresses", () {
        schedule(() {
          var nullAddress = new Address.create();

          var batched = {"2": address2.toMap(), "3": address3.toMap()};
          Future future = storeCtrl.addressStore.batch(batched).then((_) {
            Future future = storeCtrl.getAddressList();
            future.then((addresses) {
              expect(addresses.length, equals(2));
              expect(addresses.firstWhere((item) => item.id == 2), isNotNull);
              expect(addresses.firstWhere((item) => item.id == 3), isNotNull);
              expect(addresses.firstWhere((item) => item.id == 2).id, equals(address2.id));
              expect(addresses.firstWhere((item) => item.id == 3).id, equals(address3.id));
              expect(addresses.firstWhere((item) => item.id == 1, orElse: () => nullAddress).id, equals(nullAddress.id));
            });

          });
          expect(future, completes);

          return future;
        });
      });




      test("gets a list of residents at address", () {
        schedule(() {
          var nullResident = new Resident.create(
              id: -1,
              firstname: "",
              lastname: ""
          );

          Future future = storeCtrl.getResidentsAtAddress(address2);
          future.then((residents) {
            expect(residents.length, equals(2));
            expect(residents.firstWhere((resident) => resident.id == 2), isNotNull);
            expect(residents.firstWhere((resident) => resident.id == 3), isNotNull);
            expect(residents.firstWhere((resident) => resident.id == 2).id, equals(voter2.id));
            expect(residents.firstWhere((resident) => resident.id == 3).id, equals(voter3.id));
            expect(residents.firstWhere((resident) => resident.id == 1, orElse: () => nullResident).id, equals(nullResident.id));
          });
          expect(future, completes);

          return future;
        });
      });



      test("removes an address", () {
        schedule(() {
          Future<bool> future = storeCtrl.removeAddress(address2);

          future.then((success) {
            expect(success, isTrue);
            Future<bool> check = storeCtrl.addressStore.exists("${address2.id}");
            check.then((exists) {
              expect(exists, isFalse);
            });
            expect(check, completes);
          });

          expect(future, completes);

          return future;
        });
      });





      test("gets current null state", () {
        schedule(() {
          Future future = storeCtrl.appstateStore.nuke().then((_) {
            Future<State> future = storeCtrl.getState();
            future.then((state) {
              expect(state, isNull);
            });
          });
          expect(future, completes);

          return future;
        });
      });



      test("saves app state", () {
        schedule(() {
          State state = new State.create();
          Future<bool> future = storeCtrl.saveState(state);
          future.then((success) {
            expect(success, isTrue);
          });
          expect(future, completes);

          return future;
        });
      });


      test("gets a saved state", () {
        schedule(() {
          State state = new State.create();
          Future<State> future = storeCtrl.saveState(state).then((_) {
            return storeCtrl.getState();
          });

          future.then((state) {
            expect(state, isNotNull);
            expect(state.address.id, equals(-1.0));
            expect(state.addressListView, isTrue);
            expect(state.addressView, isFalse);
          });
          expect(future, completes);

          return future;
        });
      });

  });
}