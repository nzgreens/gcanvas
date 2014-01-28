library warhammer_army_builder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';


main() {
  useHtmlConfiguration(true);


  group("[gcanvas-app]", () {
    initPolymer();
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

    
    test("hass address list", () {
      Element addressList = querySelector("gcanvas-app").shadowRoot.querySelector("address-list");
      expect(
          addressList,
          isNotNull
      );
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

