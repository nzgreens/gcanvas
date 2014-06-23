import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart' show UserCtrl, User;


@CustomTag('gcanvas-status')
class GCanvasStatusElement extends PolymerElement {
  @published UserCtrl userCtrl = new UserCtrl.create();

  GCanvasStatusElement.created() : super.created() {
    checkStatus();
  }

  void checkStatus() {
    userCtrl.userStatus().then((status) {
      if(status['status'] == 'authenticated') {
        var user = new User(status['firstname'], status['lastname'], status['email']);
        if(status['verified'] == true) {
          fireAuthenticated(user);
        } else {
          fireNotVerified(user);
        }
      } else {
        var user = new User.blank();
        fireNotAuthenticated(user);
      }
    });
  }


  fireAuthenticated(user) {
    fire("authenticated", detail: user);
  }


  fireNotAuthenticated(user) {
    fire('not-authenticated', detail: user);
  }


  fireNotVerified(user) {
    fire("not-verified", detail: user);
  }
}
