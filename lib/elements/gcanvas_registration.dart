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
  get userCtrl {
    var ctrl = new PolymerDom(domHost).queryDistributedElements('#user-db')[0];

    return ctrl != null ? ctrl : new UserCtrl.create();
  }


  String _username = '';
  @Property(notify: true, reflectToAttribute: true)
  String get username => _username;
  @reflectable
  void set username(val) {
    _username = val;
    notifyPath('username', username);
  }

  String _firstname = '';
  @Property(notify: true, reflectToAttribute: true)
  String get firstname => _firstname;
  @reflectable
  void set firstname(val) {
    _firstname = val;
    notifyPath('firstname', firstname);
  }

  String _lastname = '';
  @Property(notify: true, reflectToAttribute: true)
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


  String _password1 = '';
  @Property(notify: true, reflectToAttribute: true)
  String get password1 => _password1;
  @reflectable
  void set password1(val) {
    _password1 = val;
    notifyPath('password1', password1);
  }


  String _password2 = '';
  @Property(notify: true, reflectToAttribute: true)
  String get password2 => _password2;
  @reflectable
  void set password2(val) {
    _password2 = val;
    notifyPath('password2', password2);
  }


  String _email1 = '';
  @Property(notify: true, reflectToAttribute: true)
  String get email1 => _email1;
  @reflectable
  void set email1(val) {
    _email1 = val;
    notifyPath('email1', email1);
  }


  String _email2 = '';
  @Property(notify: true, reflectToAttribute: true)
  String get email2 => _email2;
  @reflectable
  void set email2(val) {
    _email2 = val;
    notifyPath('email2', email2);
  }

  GCanvasRegistrationElement.created() : super.created();


  attached() {
    super.attached();

  }


  bool get allFieldsNotEmpty =>
            username.length > 0 &&
            firstname.length > 0 &&
            lastname.length > 0 &&
            password1.length > 0 &&
            password2.length > 0 &&
            email1.length > 0 &&
            email2.length > 0;


  bool get emailsMatch => email1 == email2;

  bool get passwordsMatch => password1 == password2;


  bool get verified => allFieldsNotEmpty && emailsMatch && passwordsMatch;


  void _highlightProblemField(List fields) {
      fields.forEach((String field) {
        ($['${field}'] as HtmlElement).classes.add('duplicate');
        if(field == 'username') $['usernameAlreadyUsed'].toggle();
      });
  }

  @reflectable
  doRegistration([_, __]) async {
    updateFields();
    if(!emailsMatch) {
      $['emailMismatched'].toggle();
    }


    if(!passwordsMatch) {
      print("password don't match");
      $['passwordMismatched'].toggle();
    }

    if(!allFieldsNotEmpty) {
      $['missing'].toggle();
    }

    if(verified) {
      user = new User.create(username: username, firstname: firstname, lastname: lastname, email: email1);
      Map status = await userCtrl.registration(user, password: password1);
      print(status);
      switch(status['status']) {
        case 'registered':
          fireRegistered();
          break;
        case 'duplicate':
          _highlightProblemField(status['duplicates']);
          break;
        case 'error':
          print('error');
          $['error'].toggle();
          break;
      }
//      if(status['status'] == 'registered') {
//        fireRegistered();
//      } else {
//
//      }
    }
  }


  void fireRegistered() {
    fire('registered');
  }

  void updateFields() {
//    username = $['username'].value;
//    print(username);
//    print(firstname);
//    print(lastname);
//    print(email1);
//    print(email2);
//    print(password1);
//    print(password2);
//    firstname = $['firstname'].value;
//    lastname = $['lastname'].value;
//    email1 = $['email1'].value;
//    email2 = $['email2'].value;
//    password1 = $['password1'].value;
//    password2 = $['password2'].value;
  }
}