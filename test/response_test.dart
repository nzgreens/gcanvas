part of gcanvas_test;

void response_test() {
  group("[Response]", () {
    ResidentResponse resResponse;

    var address = new Address.create(
        id: 1.toString(),
        address1: "48 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    var address2 = new Address.create(
        id: 2.toString(),
        address1: "50 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

    var address3 = new Address.create(
        id: 3.toString(),
        address1: "52 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);

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
        resResponse = new ResidentResponse.create(resident: voter);
      });
    });


    test("response is created from resident", () {
      schedule(() {
        var response = new ResidentResponse.create(resident: voter2);
        expect(response, isNotNull);
        expect(response.resident, voter2);
      });
    });


    test("has correct resident", () {
      expect(resResponse.resident, voter);
    });



    test("response response", () {
      schedule(() {
        expect(resResponse.response, -1);
        resResponse.response = 1;
        expect(resResponse.response, 1);
      });
    });


    test("response toMap()", () {
      schedule(() {
        var expected = {
          "id": 1,
          "response": 1,
          "support": 1,
          "resident": voter.toMap(),
          "involvement": {}
        };

        resResponse
          ..id = 1
          ..response = 1
          ..support = 1
        ;
        expect(resResponse.toMap(), equals(expected));
      });
    });


    test("response fromMap()", () {
      schedule(() {
        var map = {
          "id": 1,
          "response": 1,
          "support": 1,
          "resident": voter.toMap(),
          "involvement": {}
        };

        var copy = new ResidentResponse.fromMap(map);

        expect(copy.toMap(), map);
      });
    });
  });
}
