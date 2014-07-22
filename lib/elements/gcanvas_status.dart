import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';

@CustomTag('gcanvas-status')
class GCanvasStatusElement extends PolymerElement {
  @published UserCtrl userCtrl = new UserCtrl.create();

  GCanvasStatusElement.created() : super.created() {
    checkStatus();
  }

  void checkStatus() {
    userCtrl.userStatus().then((status) {
      if(status['status'] == 'authenticated') {
        var user = new User(status['firstname'], status['lastname'], status['email']);
        if(status['verified'] == true) {
          fireAuthenticated(user);
        } else {
          fireNotVerified(user);
        }
      } else {
        var user = new User.blank();
        fireNotAuthenticated(user);
      }
    });
  }


  fireAuthenticated(user) {
    fire("authenticated", detail: user);
    window.location.hash = '/home';
  }


  fireNotAuthenticated(user) {
    fire('not-authenticated', detail: user);
    window.location.hash = '/signin';
  }


  fireNotVerified(user) {
    fire("not-verified", detail: user);
    window.location.hash = '/register';
  }
}
