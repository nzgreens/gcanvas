part of gcanvas_test;

void address_test() {
  group("[gcanvas address class]", () {
      var address;

      setUp(() {
        address = new Address.create(
            id: 1,
            street: "48 Bignell street",
            suburb: "Gonville",
            city: "Wanganui",
            postcode: "4501",
            latitude: 169.201928,
            longitude: 49.21112,
            visited: false);

      });

      test("id is 1", () {
        expect(address.id, equals(1));
      });


      test("street is 48 Bignell street", () {
        expect(address.street, equals("48 Bignell street"));
      });


      test("suburb is Gonville", () {
        expect(address.suburb, equals("Gonville"));
      });


      test("city is Wanganui", () {
        expect(address.city, equals("Wanganui"));
      });


      test("postcode is 4501", () {
        expect(address.postcode, equals("4501"));
      });


      test("latitude is 169.201928", () {
        expect(address.latitude, equals(169.201928));
      });

      test("longitude is 49.21112", () {
        expect(address.longitude, equals(49.21112));
      });


      test("visited is false", () {
        expect(address.visited, isFalse);
      });


      test("toMap generates map", () {
        var expected = {
          "id": 1,
          "street": "48 Bignell street",
          "suburb": "Gonville",
          "city": "Wanganui",
          "postcode": "4501",
          'meshblock': -1,
          'electorate': -1,
          "latitude": 169.201928,
          "longitude": 49.21112,
          "visited": false
        };

        expect(address.toMap(), equals(expected));
      });


      test("constructor fromMap works", () {
        var map = {
          "id": 1,
          "street": "48 Bignell street",
          "suburb": "Gonville",
          "city": "Wanganui",
          "postcode": "4501",
          "latitude": 169.201928,
          "longitude": 49.21112,
          "visited": false
        };

        var copy = new Address.fromMap(map);

        expect(address.id, equals(copy.id));
        expect(address.street, equals(copy.street));
        expect(address.suburb, equals(copy.suburb));
        expect(address.city, equals(copy.city));
        expect(address.postcode, equals(copy.postcode));
        expect(address.latitude, equals(copy.latitude));
        expect(address.longitude, equals(copy.longitude));
        expect(address.visited, equals(copy.visited));
      });
    });
}