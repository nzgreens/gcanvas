@HtmlImport('gcanvas_signin.html')
library gcanvas.gcanvas_signin;

import 'dart:html' show Event, window;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_toast.dart';

import 'package:gcanvas/elements/fields/password_input.dart';
import 'package:gcanvas/elements/fields/email_input.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';

@PolymerRegister('gcanvas-signin')
class GCanvasLoggonElement extends PolymerElement {
  @property bool authenticated = false;

  get userCtrl => document.querySelector('#user-db');

  @property User user = new User.blank();

  GCanvasLoggonElement.created() : super.created();


  void attached() {
    super.attached();
  }

  @reflectable
  authenticate([_, __]) {
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