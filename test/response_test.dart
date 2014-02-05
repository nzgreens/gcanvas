part of gcanvas_test;

void response_test() {
  group("[Response]", () {
    var resResponse;

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

    var voter = new Resident(
        1,
        "Bob",
        "Kate",
        new DateTime(1973, 4, 10),
        address);

    var voter2 = new Resident(
        2,
        "Bobby",
        "Kate",
        new DateTime(1973, 4, 10),
        address2);

    var voter3 = new Resident(
        3,
        "Bobby3",
        "Kate",
        new DateTime(1973, 4, 10),
        address2);

    setUp(() {
      resResponse = new ResidentResponse(address);
    });


    test("response from address", () {
      var response = new ResidentResponse(address2);
      expect(response, isNotNull);
    });


    test("has correct address", () {
      expect(resResponse.address.id, equals(address.id));
    });



    test("response response", () {
      expect(resResponse.response, equals(""));
      resResponse.response = "No Answer";
      expect(resResponse.response, equals("No Answer"));
    });


    test("response reason", () {
      expect(resResponse.reason, equals(""));
      resResponse.reason = "No Answer";
      expect(resResponse.reason, equals("No Answer"));
    });


    test("response presentResidents", () {
      expect(resResponse.presentResidents, hasLength(0));
      resResponse.presentResidents.add(voter);
      expect(resResponse.presentResidents, hasLength(1));
    });


    test("response toMap()", () {
      var expected = {
        "response": "No Answer",
        "reason": "No Answer",
        "address": address.toMap(),
        "presentResidents": [voter.toMap()]
      };

      resResponse
        ..response = "No Answer"
        ..reason = "No Answer"
        ..presentResidents.add(voter);

      expect(resResponse.toMap(), equals(expected));
    });


    test("response fromMap()", () {
      var map = {
        "response": "No Answer",
        "reason": "No Answer",
        "address": address.toMap(),
        "presentResidents": [voter.toMap()]
      };

      var copy = new ResidentResponse.fromMap(map);

      expect(copy.response, equals("No Answer"));
      expect(copy.reason, equals("No Answer"));
      expect(copy.address.id, equals(address.id));
      expect(copy.presentResidents, hasLength(1));
      expect(copy.presentResidents[0].id, equals(voter.id));
    });
  });
}