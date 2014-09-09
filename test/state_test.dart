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


    setUp(() {
      schedule(() {
        state = new State.create();
      });
    });


    test("default values are set", () {
      schedule(() {
        expect(state.addressListView, isTrue);
        expect(state.addressView, isFalse);
        expect(state.address, isNotNull);
      });
    });


    test("values passed to state are set", () {
      schedule(() {
        var address = new Address.create(id: 10.toString());
        state = new State.create(addressListView: false, addressView: true, addressSelector: false, address: address);

        expect(state.addressListView, isFalse);
        //expect(state.addressSelector, isFalse);
        expect(state.addressView, isTrue);
        expect(state.address, isNotNull);
        //expect(state.location, isNotNull);
        expect(state.address.id, equals(address.id));
      });
    });



    test("only 1 of the states can be true at a time when state is initialised with create", () {
      schedule(() {
        state = new State.create(addressListView: true, addressView: true, addressSelector: true);

        expect(state.addressListView, isTrue);
        //expect(state.addressSelector, isFalse);
        expect(state.addressView, isFalse);
        //expect(state.location, isNotNull);
        expect(state.address, isNotNull);
      });
    });


    test("selectAddressSelector() sets addressSelector to true and others to false, and sets location", () {
      schedule(() {
        //var location = new GeoCoordinates.create(-39.94622585, 175.02286207);
        //state.selectAddressSelector(location);

        expect(state.addressListView, isFalse);
        //expect(state.addressSelector, isTrue);
        expect(state.addressView, isFalse);
        expect(state.address, isNotNull);
        //expect(state.location, isNotNull);
        //expect(state.location.latitude, equals(location.latitude));
      });
    });

    test("selectAddressSelector() sets addressSelector to true and others to false, and uses already set location", () {
      schedule(() {
        //var location = new GeoCoordinates.create(-39.94622585, 175.02286207);
        //state.location = location;
        //state.selectAddressSelector();

        expect(state.addressListView, isFalse);
        //expect(state.addressSelector, isTrue);
        expect(state.addressView, isFalse);
        expect(state.address, isNotNull);
        //expect(state.location, isNotNull);
        //expect(state.location.latitude, equals(location.latitude));
      });
    });



    test("selectAddressListView() sets addressListView to true and others to false", () {
      schedule(() {
        state.selectAddressListView();

        expect(state.addressListView, isTrue);
        //expect(state.addressSelector, isFalse);
        expect(state.addressView, isFalse);
        expect(state.address, isNotNull);
        //expect(state.location, isNotNull);
      });
    });


    test("selectAddressView() sets addressView to true and others to false, and sets address", () {
      schedule(() {
        var address = new Address.create(id: 10.toString());

        state.selectAddressView(address);

        expect(state.addressListView, isFalse);
        //expect(state.addressSelector, isFalse);
        expect(state.addressView, isTrue);
        expect(state.address, isNotNull);
        //expect(state.location, isNotNull);
        expect(state.address.id, equals(address.id));
      });
    });


    test("toMap() works", () {
      schedule(() {
        var expected = {
                        'addressListView': true,
                        'addressView': false,
                        'addressSelector': false,
                        'address': address2.toMap(),
          //              'location': location2.toMap()
                      };

        state = new State.create(addressListView: true, addressView: false, addressSelector: false, address: address2);//, location: location2);

        var actual = state.toMap();

        expect(actual, equals(expected));
      });
    });


    test("fromMap() factory works", () {
      schedule(() {
        var map = {
          'addressListView': true,
          'addressView': false,
          'addressSelector': false,
          'address': address2.toMap(),
          //'location': location2.toMap()
        };


        var actual = new State.fromMap(map);

        //expect(actual.location.latitude, equals(location2.latitude));
        //expect(actual.location.longitude, equals(location2.longitude));
        expect(actual.address.id, equals(address2.id));
        expect(actual.addressListView, isTrue);
        expect(actual.addressView, isFalse);
        //expect(actual.addressSelector, isFalse);
      });
    });
  });
}