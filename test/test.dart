library warhammer_army_builder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'package:gcanvas/elements/address_list.dart';

main() {
  useHtmlConfiguration(true);
  initPolymer();

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


    test("hass address list", () {
      AddressList addressList = querySelector("gcanvas-app").shadowRoot.querySelector("address-list");
      expect(
          addressList,
          isNotNull
      );
    });


    test("address list contains an address", () {
      new Timer(
          new Duration(milliseconds: 2500),
          expectAsync0(() {
            expect(
              querySelector("gcanvas-app").shadowRoot.querySelector("address-list").shadowRoot.querySelector('address-view'),
              isNotNull
            );
          })
      );
    });
  });



  solo_group("[gCanvas Service]", () {
    Element _el;

    //uses events
    setUp((){
      _el = createElement('<gcanvas-service></gcanvas-service>');
      document.body.append(_el);
    });


    tearDown((){
      _el.remove();
    });


    test("element exists", () {
      var element = querySelector("gcanvas-service");
      expect(
          element,
          isNotNull
      );
      expect(
          element.shadowRoot,
          isNotNull
      );
    });


    test("element is hidden", () {
      var element = querySelector("gcanvas-service");
      expect(
          element.hidden,
          isTrue
      );
    });


    test("element gets a record", () {
      //var
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

