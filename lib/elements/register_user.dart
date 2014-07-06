import 'package:polymer/polymer.dart';

import 'dart:html';

@CustomTag('register-user-button')
class RegisterUserElement extends PolymerElement {
  RegisterUserElement.created() : super.created();

  registerUser(e) {
    fire('register-user');
    window.location.hash = '/register';
  }
}