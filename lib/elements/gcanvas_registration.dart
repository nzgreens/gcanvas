@HtmlImport('gcanvas_registration.html')
library gcanvas.gcanvas_registration;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_toast.dart';

import 'package:gcanvas/elements/fields/password_input.dart';
import 'package:gcanvas/elements/fields/email_input.dart';

import 'package:gcanvas/gcanvas.dart';

import 'dart:html';

@PolymerRegister('gcanvas-registration')
class GCanvasRegistrationElement extends PolymerElement {
  UserCtrl get userCtrl => new UserCtrl.create();

  String _firstname;
  @Property(reflectToAttribute: true)
  String get firstname => _firstname;
  @reflectable
  void set firstname(val) {
    _firstname = val;
    notifyPath('firstname', firstname);
  }

  String _lastname;
  @Property(reflectToAttribute: true)
  String get lastname => _lastname;
  @reflectable
  void set lastname(val) {
    _lastname = val;
    notifyPath('lastname', lastname);
  }


  User _user;
  @Property(notify: true, reflectToAttribute: true)
  User get user => _user;
  @reflectable
  void set user(val) {
    _user = val;
    notifyPath('user', user);
  }

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
    async(() {
      fireRegistered();
    });

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


  @reflectable
  void doRegistration([_, __]) async {
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
      user = new User.create(firstname: firstname, lastname: lastname);
//      userCtrl.user = user;
      bool status = await userCtrl.registration(user);
      if(status) {
        fireRegistered();
      }
    }
  }


  void fireRegistered() {
    fire('registered');
  }

  void updateFields() {
    firstname = $['firstname'].value;
    lastname = $['lastname'].value;
  }
}