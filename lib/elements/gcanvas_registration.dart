import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart';

import 'dart:html';

@CustomTag('gcanvas-registration')
class GCanvasRegistrationElement extends PolymerElement {
  get userCtrl => document.querySelector('#user-db');

  @PublishedProperty(reflect: true)
  String get firstname => readValue(#firstname);
  set firstname(val) => writeValue(#firstname, val);

  @PublishedProperty(reflect: true)
  String get lastname => readValue(#lastname);
  set lastname(val) => writeValue(#lastname, val);

  /*@PublishedProperty(reflect: true)
  String get password1 => readValue(#password1);
  set password1(val) => writeValue(#password1, val);

  @PublishedProperty(reflect: true)
  String get password2 => readValue(#password2);
  set password2(val) => writeValue(#password2, val);

  @PublishedProperty(reflect: true)
  String get email1 => readValue(#email1);
  set email1(val) => writeValue(#email1, val);

  @PublishedProperty(reflect: true)
  String get email2 => readValue(#email2);
  set email2(val) => writeValue(#email2, val);*/

  GCanvasRegistrationElement.created() : super.created();


  attached() {
    super.attached();


  }


  bool get allFieldsNotEmpty =>
            firstname.length > 0 &&
            lastname.length > 0;// &&
            //password1.length > 0 &&
            //password2.length > 0 &&
            //email1.length > 0 &&
            //email2.length > 0;


  bool get emailsMatch => true;//email1 == email2;

  bool get passwordsMatch => true;//password1 == password2;


  bool get verified => allFieldsNotEmpty && emailsMatch && passwordsMatch;


  doRegistration(e) {
    updateFields();
    if(!emailsMatch) {
      $['emailMismatched'].toggle();
    }


    if(!passwordsMatch) {
      $['passwordMismatched'].toggle();
    }

    if(!allFieldsNotEmpty) {
      $['missing'].toggle();
    }

    if(verified) {
      var user = new User.create(firstname: firstname, lastname: lastname);
      userCtrl.registration(user).
        then((status) {
          if(status) {
            fireRegistered();
          }
        }).
        catchError(print);
    }
  }


  fireRegistered() {
    fire('registered');
  }

  void updateFields() {
    firstname = $['firstname'].value;
    lastname = $['lastname'].value;
  }
}