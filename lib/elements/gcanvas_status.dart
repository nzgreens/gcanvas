@HtmlImport('gcanvas_status.html')
library gcanvas.gcanvas_status;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';
import 'dart:convert' show JSON;

@PolymerRegister('gcanvas-status')
class GCanvasStatusElement extends PolymerElement {
  @property UserCtrl userCtrl = new UserCtrl.create();

  GCanvasStatusElement.created() : super.created() {
    checkStatus();
  }

  void checkStatus() {
    userCtrl.status().then((status) {
      if(status.containsKey('status') && status['status'] == 'authenticated') {
        var user = new User(status['firstname'], status['lastname'], status['email']);
        if(status.containsKey('verified') && status['verified'] == true) {
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
