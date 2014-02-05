library gcanvas_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
//import 'package:angular/angular.dart';
//import 'package:lawndart/lawndart.dart';
import 'package:unittest/mock.dart';
import 'package:gcanvas/gcanvas.dart';


part 'storectrl_test.dart';
part 'address_test.dart';
part 'resident_test.dart';
part 'gcanvas_app_element_test.dart';
part 'response_test.dart';

main() {
  useHtmlConfiguration(true);
  initPolymer();


  storectrl_test();
  address_test();
  resident_test();
  gcanvas_app_element_test();
  response_test();

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

