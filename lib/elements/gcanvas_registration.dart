import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart';

@CustomTag('gcanvas-registration')
class GCanvasRegistrationElement extends PolymerElement {
  @published User user = new User.blank();

  GCanvasRegistrationElement.created() : super.created();

  doRegistration(e) {

  }
}