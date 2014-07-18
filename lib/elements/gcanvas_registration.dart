import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart';

@CustomTag('gcanvas-registration')
class GCanvasRegistrationElement extends PolymerElement {
  @published UserCtrl userCtrl = new UserCtrl.create();

  @PublishedProperty(reflect: true) String firstname = "";
  @PublishedProperty(reflect: true) String lastname = "";
  @PublishedProperty(reflect: true) String password1 = "";
  @PublishedProperty(reflect: true) String password2 = "";
  @PublishedProperty(reflect: true) String email1 = "";
  @PublishedProperty(reflect: true) String email2 = "";

  GCanvasRegistrationElement.created() : super.created();


  attached() {
    super.attached();


  }


  domReady() {
    super.domReady();

  }


  bool get allFieldsNotEmpty =>
            firstname.length > 0 &&
            lastname.length > 0 &&
            password1.length > 0 &&
            password2.length > 0 &&
            email1.length > 0 &&
            email2.length > 0;


  bool get emailsMatch => email1 == email2;

  bool get passwordsMatch => password1 == password2;


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
      var user = new User(firstname, lastname, email1);
      userCtrl.userRegistration(user, password1).then((success) {

      }).catchError((error) {

      });
    }
  }

  void updateFields() {
    firstname = $['firstname'].value;
    lastname = $['lastname'].value;
    email1 = $['email1'].value;
    email2 = $['email2'].value;
    password1 = $['password1'].value;
    password2 = $['password2'].value;
  }
}