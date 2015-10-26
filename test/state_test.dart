part of gcanvas_test;

void state_test() {
  group("[State Test]", () {
    State state;

    Address address2 = new Address.create(
        id: 3.toString(),
        address1: "52 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    group('[default values]', () {
      setUp(() {
        schedule(() {
          state = new State.create();
        });
      });


      test("addressListView default value is true", () {
        expect(state.addressListView, isTrue);
      });

      test('addressView default value is false', () {
        expect(state.addressView, isFalse);
      });

      test('address default values is not null', () {
        expect(state.address, isNotNull);
      });
    });
    group('[values passed to constructor]', () {
      var address;
      setUp(() {
        address = new Address.create(id: 10.toString());
        state = new State.create(addressListView: false, addressView: true, address: address);
      });

      test("addressListView is false", () {
        expect(state.addressListView, isFalse);
      });

      test('addressView is true', () {
        expect(state.addressView, isTrue);
      });

      test('address is not null', () {
        expect(state.address, isNotNull);
      });

      test('address is the correct address', () {
        expect(state.address.id, equals(address.id));
      });
    });


    group("[only 1 of the states can be true at a time]", () {
      setUp(() {
        state = new State.create(addressListView: true, addressView: true);
      });

      tearDown(() {
        state = null;
      });

      test("after create setting both addressListView and addressListView to true", () {
        expect(state.addressListView, isTrue, reason: 'addressListView');
        expect(state.addressView, isFalse, reason: 'addressView');
      });

      test('setting addressView to true', () {
        state.addressView = true;
        expect(state.addressListView, isFalse, reason: 'addressListView');
        expect(state.addressView, isTrue, reason: 'addressView');
      });
    });


    group('[selector methods]', () {
      setUp(() {
        state = new State.create();
      });

      tearDown(() {
        state = null;
      });

      test("selectAddressView() sets addressView to true and others to false, and sets address", () {
        schedule(() {
          state.selectAddressView(address2);

          expect(state.addressListView, isFalse, reason: 'addressListView');
          expect(state.addressView, isTrue, reason: 'addressView');
          expect(state.address, isNotNull, reason: 'address');
          expect(state.address, address2, reason: 'address is address');
        });
      });

      test("selectAddressListView() sets addressListView to true and others to false, and uses already set address", () {
        schedule(() {
          state.address = address2;
          state.selectAddressListView();

          expect(state.addressListView, isTrue, reason: 'addressListView');
          expect(state.addressView, isFalse, reason: 'addressView');
          expect(state.address, isNotNull, reason: 'address');
          expect(state.address, address2, reason: 'address is address');
        });
      });


      test("selectAddressView() sets addressView to true and others to false, and sets address", () {
        schedule(() {
          var address = new Address.create(id: 10.toString());

          state.selectAddressView(address);

          expect(state.addressListView, isFalse);
          expect(state.addressView, isTrue);
          expect(state.address, isNotNull);
          expect(state.address.id, equals(address.id));
        });
      });
    });

    group('[serialisation]', () {
      test("toMap() works", () {
        var expected = {
          'addressListView': true,
          'addressView': false,
          'address': address2.toMap(),
        };

        state = new State.create(
            addressListView: true,
            addressView: false,
            address: address2
        );//, location: location2);

        var actual = state.toMap();

        expect(actual, equals(expected));
      });


      test("fromMap() factory works", () {
        var map = {
          'addressListView': true,
          'addressView': false,
          'addressSelector': false,
          'address': address2.toMap(),
        };


        var actual = new State.fromMap(map);

        //expect(actual.location.latitude, equals(location2.latitude));
        //expect(actual.location.longitude, equals(location2.longitude));
        expect(actual.address.id, equals(address2.id));
        expect(actual.addressListView, isTrue);
        expect(actual.addressView, isFalse);
      });
    });
  });
}