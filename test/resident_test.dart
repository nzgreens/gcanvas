part of gcanvas_test;

void resident_test() {
  group("[gCanvas Resident class]", () {
    var dob = new DateTime.now();


      var voter = new Resident.create(
          id: 1,
          firstname: "Bob",
          lastname: "Kate",
          dob: dob,
          email : 'test@test.com'
          // new DateTime(1973, 4, 10),
      );


    var address = new Address.create(
        id: 1.toString(),
        address1: "48 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false,
        residents: [voter]
    );

      test("id is 1", () {
        schedule(() {expect(voter.id, equals(1));});
      });


      test("firstname is Bob", () {
        schedule(() {expect(voter.firstname, equals("Bob"));});
      });


      test("lastname is Kate", () {
        schedule(() {expect(voter.lastname, equals("Kate"));});
      });


      /*test("dob is 10/4/1973", () {
        expect(voter.dob, equals(new DateTime(1973, 4, 10)));
        });*/


      test("address is address of voter", () {
        schedule(() {expect(address.residents, contains(voter));});
      });


      test("toMap works", () {
        schedule(() {
          var expected = {
            'id': 1,
            'title': '',
            'firstname': 'Bob',
            'middlenames': '',
            'lastname': 'Kate',
            'occupation': '',
            'gender': '',
            'dob': dob.toString(),
            'email' : 'test@test.com',
            'phone' : '',
            'notes' : '',
            'response' : -1,
            'support': -1,
            'host_a_billboard': false,
            'inferred_support_level': -1
            //'address': address.toMap()
          };

          expect(voter.toMap(), equals(expected));
        });
      });


      test("fromMap works", () {
        schedule(() {
          var map = {
            'id': 1,
            'firstname': 'Bob',
            'lastname': 'Kate'
              //'dob': new DateTime(1973, 4, 10).toString(),
            //'address': address.toMap()
          };

          var copy = new Resident.fromMap(map);
          expect(copy.id, equals(1));
          expect(copy.firstname, equals("Bob"));
          expect(copy.lastname, equals("Kate"));
          //expect(copy.dob, equals(new DateTime(1973, 4, 10)));
          //expect(copy.address.id, equals(1));
        });
      });
    });
}