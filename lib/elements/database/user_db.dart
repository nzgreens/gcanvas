import 'package:polymer/polymer.dart';

import 'dart:html';

@CustomTag('user-db')
class UserDB extends PolymerElement {
  @published String client_id;

  UserDB.created() : super.created();



  attached() {
    super.attached();


  }
}

