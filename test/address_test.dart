part of gcanvas_test;

void address_test() {
  group("[gcanvas address class]", () {
    var voter = new Resident.create(
      id: 1,
      firstname: "Bob",
      lastname: "Kate",
      occupation: '',
      gender: '',
      dob: new DateTime(1973, 4, 10),
      email : 'test@test.com',
      phone : '',
      notes : '',
      response : -1,
      support: -1,
      host_a_billboard: false,
      inferred_support_level: -1
      );
    var voter2 = new Resident.create(
        id: 2,
        firstname: "Bobby",
        lastname: "Kate",
        occupation: '',
        gender: '',
        dob: new DateTime(1973, 4, 10),
        email : 'test@test.com',
        phone : '',
        notes : '',
        response : -1,
        support: -1,
        host_a_billboard: false,
        inferred_support_level: -1
        //new DateTime(1973, 4, 10),
        //address: address2
        );

    var voter3 = new Resident.create(
        id: 3,
        firstname: "Bobby3",
        lastname: "Kate",
        occupation: '',
        gender: '',
        dob: new DateTime(1973, 4, 10),
        email : 'test@test.com',
        phone : '',
        notes : '',
        response : -1,
        support: -1,
        host_a_billboard: false,
        inferred_support_level: -1
        //new DateTime(1973, 4, 10),
        //address: address2
        );
    var address;

    setUp(() {
      address = new Address.create(
          id: 1.toString(),
          address1: "48 Bignell street",
          address2: "Gonville",
          city: "Wanganui",
          postcode: "4501",
          latitude: 169.201928,
          longitude: 49.21112,
          visited: false,
          residents: [voter, voter2, voter3]
      );

    });

    test("id is 1", () {
      expect(address.id, '1');
    });

    test("street is 48 Bignell street", () {
      schedule(() {expect(address.address1, equals("48 Bignell street"));});
    });


    test("suburb is Gonville", () {
      schedule(() {expect(address.address2, equals("Gonville"));});
    });


    test("city is Wanganui", () {
      schedule(() {expect(address.city, equals("Wanganui"));});
    });


    test("postcode is 4501", () {
      schedule(() {expect(address.postcode, equals("4501"));});
    });


    test("latitude is 169.201928", () {
      schedule(() {expect(address.latitude, equals(169.201928));});
    });

    test("longitude is 49.21112", () {
      schedule(() {expect(address.longitude, equals(49.21112));});
    });


    test("visited is false", () {
      schedule(() {expect(address.visited, isFalse);});
    });


    test("residents are present", () {
      schedule(() {
        var expected = [voter.toMap(), voter2.toMap(), voter3.toMap()];
        expect(address.residents.map((resident) => resident.toMap()).toList(), equals(expected));
      });
    });


    test("toMap generates map", () {
      var expected = {
        "id": 1.toString(),
        "address1": "48 Bignell street",
        "address2": "Gonville",
        "address3": "",
        "city": "Wanganui",
        "postcode": "4501",
        'meshblock': -1,
        'electorate': -1,
        "latitude": 169.201928,
        "longitude": 49.21112,
        "visited": false,
        "residents": [voter.toMap(), voter2.toMap(), voter3.toMap()]
      };

      schedule(() {expect(address.toMap(), equals(expected));});
    });


    test("constructor fromMap works", () {
      var map = {
        "id": 1.toString(),
        "address1": "48 Bignell street",
        "address2": "Gonville",
        "city": "Wanganui",
        "postcode": "4501",
        "latitude": 169.201928,
        "longitude": 49.21112,
        "visited": false,
        "residents": [voter.toMap(), voter2.toMap(), voter3.toMap()]
      };

      schedule(() {
        var copy = new Address.fromMap(map);
        var residents = [voter.toMap(), voter2.toMap(), voter3.toMap()];

        expect(address.id, equals(copy.id));
        expect(address.address1, equals(copy.address1));
        expect(address.address2, equals(copy.address2));
        expect(address.city, equals(copy.city));
        expect(address.postcode, equals(copy.postcode));
        expect(address.latitude, equals(copy.latitude));
        expect(address.longitude, equals(copy.longitude));
        expect(address.visited, equals(copy.visited));
        expect(address.residents.map((resident) => resident.toMap()).toList(), equals(residents));
      });
    });
  });
}