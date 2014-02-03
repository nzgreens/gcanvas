library warhammer_army_builder_test;

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


  group("[gcanvas StoreCtrl", () {
    var storeCtrl = new StoreCtrl();
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

    setUp(() {
      Completer completer = new Completer();
      var batched = {"2": address2.toMap(), "3": address3.toMap()};
      if(!storeCtrl.addressStore.isOpen) {
        return storeCtrl.addressStore.open()
          ..then((_) => storeCtrl.addressStore.nuke())
          ..then((_) => storeCtrl.addressStore.batch(batched).then((_) => completer.complete()));
      } else {
        return storeCtrl.addressStore
          ..nuke().then((_) => storeCtrl.addressStore.batch(batched).then((_) => completer.complete()));
      }


      return completer.future;
    });

    test("adds an address", () {
      var address = new Address(
          1,
          "48 Bignell street",
          "Gonville",
          "Wanganui",
          "4501",
          169.201928,
          49.21112);
      Future future = storeCtrl.addAddress(address);
      expect(future, completion(equals(address.id)));
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
      var batched = {"2": address2.toMap(), "3": address3.toMap()};
      Future future = storeCtrl.addressStore.batch(batched).then((_) {
        Future future = storeCtrl.getAddressList();
        future.then((addresses) {
          expect(addresses.length, equals(2));
          expect(addresses.firstWhere((item) => item.id == 2) != null, isTrue);
          expect(addresses.firstWhere((item) => item.id == 3) != null, isTrue);
        });

      });
      expect(future, completes);
    });

    test("gets a list of residents at adrees", () {
        Future future = storeCtrl.getResidentsAtAddress(address2);
        future.then((residents) {
          expect(residents.length, equals(2));
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



  group("[gCanvas Service]", () {
    DatabaseCtrl service;
    Http http;
    StoreCtrl store;

    setUp((){
      http = new Http();
      store = new StoreMock();
      service = new DatabaseCtrl(http, store);
    });


    tearDown((){
    });


    test("adds a record", () {
      service.add({'mok':"Mock data"});
      service.getLogs(callsTo("add", {'mok':"Mock data"}))
        .verify(happenedOnce);
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

