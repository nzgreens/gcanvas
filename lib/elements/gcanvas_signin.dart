@HtmlImport('gcanvas_signin.html')
library gcanvas.gcanvas_signin;

import 'dart:html' show Event, window;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
//import 'package:polymer_elements/paper_toast.dart';

import 'package:gcanvas/elements/fields/password_input.dart';
//import 'package:gcanvas/elements/fields/email_input.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;

import 'dart:html';

@PolymerRegister('gcanvas-signin')
class GCanvasLoggonElement extends PolymerElement {
  bool _authenticated = false;
  @Property(notify:true, reflectToAttribute: true)
  bool get authenticated => _authenticated;
  @reflectable
  void set authenticated(val) {
    _authenticated = val;
    notifyPath('authenticated', authenticated);
  }


  var _userCtrl;
  @Property(notify: true, reflectToAttribute: true)
  get userCtrl => _userCtrl;
//  {
//    var ctrl = new PolymerDom(domHost).queryDistributedElements('#user-db')[0];
//
//    return ctrl != null ? ctrl : new UserCtrl.create();
//  }
  @reflectable
  void set userCtrl(val) {
    _userCtrl = val;
    print('userCtrl: ${userCtrl}');
    notifyPath('userCtrl', userCtrl);
  }

  @Property(notify: true, reflectToAttribute: true) User user = new User.blank();

  String _username = '';
  @Property(notify: true, reflectToAttribute: true)
  String get username => _username;
  @reflectable
  void set username(val) {
    _username = val;
    notifyPath('username', username);
  }

  String _password = '';
  @Property(notify: true, reflectToAttribute: true)
  String get password => _password;
  @reflectable
  void set password(val) {
    _password = val;
    notifyPath('password', password);
  }

  GCanvasLoggonElement.created() : super.created();


  void attached() {
    super.attached();
  }

  @reflectable
  authenticate([_, __]) async {
    var result = await userCtrl.login(username, password);
    if(result) {
      fireAuthenticated();
    } else {
      fireNotAuthenticated();
    }
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
}