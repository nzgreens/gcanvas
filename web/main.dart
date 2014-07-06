import 'package:polymer/polymer.dart';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

import 'dart:html';

main() {
  initPolymer().run(() {
    /*var client_id = "136164851467-6lplrnlolpbd06omoqivfsckp9m7hjtq.apps.googleusercontent.com";
    GoogleOAuth2 auth = new GoogleOAuth2(client_id,
            ['https://www.googleapis.com/auth/userinfo.email',
                                      'https://www.googleapis.com/auth/datastore']);
    auth.login().then((token) {
      print(token);
      var userDB = querySelector('gcanvas-app').shadowRoot.querySelector('user-db');
      userDB.auth = auth;
      userDB.run();
    });*/
  });
}