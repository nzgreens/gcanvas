@HtmlImport('gcanvas_status.html')
library gcanvas.gcanvas_status;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';
import 'dart:convert' show JSON;

@PolymerRegister('gcanvas-status')
class GCanvasStatusElement extends PolymerElement {
  var _userCtrl;
  @property get userCtrl {
    if(_userCtrl == null) {
      var ctrls = new PolymerDom(domHost).queryDistributedElements('#user-db');

      print(ctrls);

      _userCtrl = ctrls != null && ctrls.length > 0 ? ctrls[0] : new UserCtrl.create();
    }

    return _userCtrl;
  }

  GCanvasStatusElement.created() : super.created() {
  }


  void ready() {
    async(() => checkStatus());
  }

  void _setCSRFTokenCookie(token) {

  }

  void checkStatus() {
    userCtrl.status().then((status) {
      if(status.containsKey('status') && status['status'] == 'authenticated') {
        var user = new User.create(username: status['username'], firstname: status['firstname'], lastname: status['lastname'], email: status['email']);
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
