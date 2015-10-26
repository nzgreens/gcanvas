@HtmlImport('register_user.html')
library gcanvas.register_user;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'dart:html';

import 'package:polymer_elements/paper_button.dart';

@PolymerRegister('register-user-button')
class RegisterUserElement extends PolymerElement {
  RegisterUserElement.created() : super.created();

  @reflectable
  void registerUser([_, __]) {
    fire('register-user');
    window.location.hash = '/register';
  }
}