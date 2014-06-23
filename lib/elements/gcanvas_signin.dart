import 'dart:html' show Event, window;

import 'package:polymer/polymer.dart';// show CustomTag, PolymerElement, published, observable;

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;
//import

@CustomTag('gcanvas-signin')
class GCanvasLoggonElement extends PolymerElement {
  @published bool authenticated = false;
  @published UserCtrl userCtrl = new UserCtrl.create();

  @observable User user = new User.blank();
  @observable String email;
  @observable String password;

  GCanvasLoggonElement.created() : super.created();

  authenticate(Event e) {
    userCtrl.userLogin(email, password).then((result) {
      if(result) {
        user = new User.blank();
        fireNotAuthenticated();
      } else {
        user = new User("James", "Hurford", email);
        fireAuthenticated();
      }
    });
  }


  fireAuthenticated() {
    fire("authenticated", detail: user);
    authenticated = true;
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