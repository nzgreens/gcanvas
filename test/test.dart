@TestOn('dartium')
library gcanvas_test;

import 'package:test/test.dart';
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'package:gcanvas/response.dart';

import 'package:lawndart/lawndart.dart';

import 'package:gcanvas/elements/gcanvas_app.dart';
import 'package:gcanvas/elements/address_list.dart';
import 'package:gcanvas/elements/database/user_db.dart';

part 'storectrl_test.dart';
part 'address_test.dart';
part 'resident_test.dart';
part 'response_test.dart';
part 'addresslistctrl_test.dart';
part 'residentlistctrl_test.dart';
part 'appstatectrl_test.dart';
part 'script_response_test.dart';
part 'state_test.dart';
part 'configctrl_test.dart';
part 'residentresponsectrl_test.dart';

part 'elements/gcanvas_app_element_test.dart';
part 'elements/address_list_element_test.dart';
part 'elements/userdb_test.dart';



main() async {
  await initPolymer();

//  storectrl_test();
//  address_test();
//  resident_test();
//  state_test();
//  response_test();
//  addresslistctrl_test();
//  residentlistctrl_test();
//  appstatectrl_test();
//
//  address_list_element_test();
//  gcanvas_app_element_test();

  residentresponsectrl_test();
  //pollForDone(testCases);
}

schedule(dynamic callback) {
  callback();
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


class PageComponent {
  final PolymerElement el;

  const PageComponent(this.el);

  Future flush() {
    Completer completer = new Completer();
    el.async(() => completer.complete());

    return completer.future;
  }
}
