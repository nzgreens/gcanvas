library gcanvas_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:angular/angular.dart';
import 'package:lawndart/lawndart.dart';
import 'package:unittest/mock.dart';
import 'package:gcanvas/gcanvas.dart';

class StoreCtrlMock extends Mock implements StoreCtrl {

}

class DatabaseCtrlMock extends Mock implements DatabaseCtrl {

}



main() {
  useHtmlConfiguration(true);
  initPolymer();

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


  group("[gcanvas StoreCtrl]", () {
    var storeCtrl = new StoreCtrl();



    setUp(() {
      Completer completer = new Completer();
      var batched = {"2": address2.toMap(), "3": address3.toMap()};
      var batched2 = {"2": voter2.toMap(), "3": voter3.toMap()};
      storeCtrl.addressStore.open()
        ..then((_) => storeCtrl.addressStore.nuke())
        ..then((_) => storeCtrl.addressStore.batch(batched).then((_) =>
            storeCtrl.residentsStore.open()
              ..then((_) => storeCtrl.residentsStore.nuke())
              ..then((_) => storeCtrl.residentsStore.batch(batched2).then((_) => completer.complete()))
        ));


      return completer.future;
    });


    test("adds an address", () {

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
    });


    test("retreives an address", () {
      Future future = storeCtrl.getAddressById(2);
      future.then((address) {
        expect(address.id, equals(address2.id));
        expect(address.street, equals(address2.street));
        expect(address.suburb, equals(address2.suburb));
        expect(address.city, equals(address2.city));
        expect(address.postcode, equals(address2.postcode));
      });
      expect(future, completes);
    });



    test("gets a list of all addresses", () {
      var nullAddress = new Address(
              -1,
              "",
              "",
              "",
              "",
              0,
              0);
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
    });



    test("adds a resident", () {
      Future future = storeCtrl.addResident(voter);
      future.then((id) {
        expect(id, equals(voter.id));
        var check = storeCtrl.residentsStore.getByKey("${voter.id}");
        check.then((resident) {
          expect(voter.toMap(), equals(resident));
        });
        expect(check, completes);
      });
      expect(future, completes);
    });


    test("gets a list of residents at address", () {
        var nullResident = new Resident(
            -1,
            "",
            "",
            new DateTime(1, 1, 1),
            address3
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
    });


    test("retreives a resident", () {
      Future<Resident> future = storeCtrl.getResidentById(2);

      future.then((copy) {
        expect(copy.id, equals(voter2.id));
        expect(copy.firstname, equals(voter2.firstname));
        expect(copy.lastname, equals(voter2.lastname));
        expect(copy.dob, equals(voter2.dob));
        expect(copy.address.id, equals(voter2.address.id));
      });

      expect(future, completes);
    });



    test("removes an address", () {
      Future<bool> future = storeCtrl.removeAddressById(address2.id);

      future.then((success) {
        expect(success, isTrue);
        Future<bool> check = storeCtrl.addressStore.exists("${address2.id}");
        check.then((exists) {
          expect(exists, isFalse);
        });
        expect(check, completes);
      });

      expect(future, completes);
    });



    test("remove a resident", () {
      Future<bool> future = storeCtrl.removeResidentById(voter2.id);

      future.then((success) {
        expect(success, isTrue);
        Future<bool> check = storeCtrl.residentsStore.exists("${voter2.id}");
        check.then((exists) {
          expect(exists, isFalse);
        });
        expect(check, completes);
      });

      expect(future, completes);
    });
  });


  group("[gcanvas address class]", () {
    var address;

    setUp(() {
      address = new Address(
          1,
          "48 Bignell street",
          "Gonville",
          "Wanganui",
          "4501",
          169.201928,
          49.21112);

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


    test("toMap generates map", () {
      var expected = {
        "id": 1,
        "street": "48 Bignell street",
        "suburb": "Gonville",
        "city": "Wanganui",
        "postcode": "4501",
        "latitude": 169.201928,
        "longitude": 49.21112
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
        "longitude": 49.21112
      };

      var copy = new Address.fromMap(map);

      expect(address.id, equals(copy.id));
      expect(address.street, equals(copy.street));
      expect(address.suburb, equals(copy.suburb));
      expect(address.city, equals(copy.city));
      expect(address.postcode, equals(copy.postcode));
      expect(address.latitude, equals(copy.latitude));
      expect(address.longitude, equals(copy.longitude));
    });
  });


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

  group("[gcanvas-app]", () {
    Element _el;

    setUp((){
      _el = createElement('<gcanvas-app></gcanvas-app>');
      document.body.append(_el);
    });


    tearDown((){
      _el.remove();
    });

    test("gCanvas Title is present", () {
      var content = querySelector("gcanvas-app").shadowRoot.text;
      expect(
          content,
          contains("gCanvas"));
    });


    test("Has refresh button", () {
      ButtonElement refresh = querySelector("gcanvas-app").shadowRoot.querySelector("#refresh");
      expect(
        refresh,
        isNotNull
      );
    });

    test("has back button", () {
      ButtonElement back = querySelector("gcanvas-app").shadowRoot.querySelector("#back");
      expect(
        back,
        isNotNull
      );
    });

    test("start screen back button is hidden", () {
      ButtonElement back = querySelector("gcanvas-app").shadowRoot.querySelector("#back");
      expect(
        back.hidden,
        isTrue
      );
    });
  });


  group("[address-list]", () {
    Element _el;

    setUp((){
      _el = createElement('<gcanvas-app></gcanvas-app>');
      document.body.append(_el);
    });


    tearDown((){
      _el.remove();
    });




  });


  group("[Response]", () {
    var resResponse;

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


    solo_test("response fromMap()", () {
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

  //pollForDone(testCases);
}


pollForDone(List tests) {
  if (tests.every((t)=> t.isComplete)) {
    window.postMessage('dart-main-done', window.location.href);
    return;
  }

  var wait = new Duration(milliseconds: 100);
  new Timer(wait, ()=> pollForDone(tests));
}


createElement(String html) =>
  new Element.html(html, treeSanitizer: new NullTreeSanitizer());

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(node) {}
}

