part of gcanvas_test;

void resident_test() {
  group("[gCanvas Resident class]", () {
      var address = new Address(
          1,
          "48 Bignell street",
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
        address
      );


      test("id is 1", () {
        expect(voter.id, equals(1));
      });


      test("firstname is Bob", () {
        expect(voter.firstname, equals("Bob"));
      });


      test("lastname is Kate", () {
        expect(voter.lastname, equals("Kate"));
      });


      test("dob is 10/4/1973", () {
        expect(voter.dob, equals(new DateTime(1973, 4, 10)));
      });


      test("address is address", () {
        expect(voter.address.id, equals(address.id));
      });


      test("toMap works", () {
        var expected = {
          'id': 1,
          'firstname': 'Bob',
          'lastname': 'Kate',
          'dob': new DateTime(1973, 4, 10).toString(),
          'address': address.toMap()
        };

        expect(voter.toMap(), equals(expected));
      });


      test("fromMap works", () {
        var map = {
          'id': 1,
          'firstname': 'Bob',
          'lastname': 'Kate',
          'dob': new DateTime(1973, 4, 10).toString(),
          'address': address.toMap()
        };

        var copy = new Resident.fromMap(map);
        expect(copy.id, equals(1));
        expect(copy.firstname, equals("Bob"));
        expect(copy.lastname, equals("Kate"));
        expect(copy.dob, equals(new DateTime(1973, 4, 10)));
        expect(copy.address.id, equals(1));
      });
    });
}