import 'dart:html' show Event, window;

import 'package:polymer/polymer.dart';// show CustomTag, PolymerElement, published, observable;

import 'package:paper_elements/paper_input.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';

@CustomTag('gcanvas-signin')
class GCanvasLoggonElement extends PolymerElement {
  @published bool authenticated = false;

  get userCtrl => document.querySelector('#user-db');

  @observable User user = new User.blank();

  GCanvasLoggonElement.created() : super.created();


  void attached() {
    super.attached();
  }

  authenticate(Event e) {
    userCtrl.login().then((result) {
      if(result) {
        user = new User.blank();
        fireAuthenticated();
      } else {
        user = new User.blank();
        fireNotAuthenticated();
      }
    });
  }


  fireAuthenticated() {
    fire("authenticated", detail: user);
    authenticated = true;
    print("authenticated");
  }


  fireNotAuthenticated() {
    fire('not-authenticated', detail: user);
    authenticated = false;
  }


  fireNotVerified() {
    fire("not-verified", detail: user);
    authenticated = false;
  }
}