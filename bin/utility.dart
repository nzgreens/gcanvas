part of gcanvas.server;

Future<DatastoreConnection> futureConnection =
    DatastoreConnection.open('500010562745', 'nzgcanvas');

Uint8List createUint8ListFromString( String s ) {
  var ret = new Uint8List(s.length);
  for( var i=0 ; i<s.length ; i++ ) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}


String md5PasswordWithSalt(String password, String salt) {
  var digest = new Digest("MD5");
  var newPassword = digest.process(createUint8ListFromString(password)).join("");

  return "$salt$newPassword";
}


String createSalt() {
  var rand = new Random();
  var ret = new Uint8List(10);

  return ret.map((_) => rand.nextInt(2048)).join("");
}


Future<bool> register(String firstname,
              String lastname,
              String email,
              String password
              ) {
  Completer<bool> completer = new Completer<bool>();

  futureConnection.then((connection) {
    Datastore datastore = new Datastore(connection);

    datastore.logger.onRecord.listen(print);

    datastore.withTransaction((transaction) {
      var key = new Key("User", name: email);
      return datastore.lookup(key).then((entityResult) {
                if (entityResult.isPresent) {
                  completer.complete(false);
                  return;
                }
                DoorKnocker user = new DoorKnocker(key)
                  ..email = email
                  ..firstname = firstname
                  ..lastname = lastname;

                setPassword(user, password);

                transaction.insert.add(user);

                isValidDoorKnocker(email).then((result) {
                  if(result == true) {
                    sendConfirmationEmail(user);
                    completer.complete(true);
                  } else {
                    completer.complete(false);
                  }
                }, onError: () => completer.complete(false));


              });
    });
  });

  return completer.future;
}

// TODO: Make a separate NationBuilder library to do this
// TODO: Check to see if email is associated with a valid NationBuilder user
Future<bool> isValidDoorKnocker(String email) {
  return new Future.value(true);
}

void sendConfirmationEmail(DoorKnocker user) {

}


void setPassword(DoorKnocker user, String password) {
  user.salt = createSalt();
  user.password = md5PasswordWithSalt(password, user.salt);
}


bool match(String str1, String str2) => str1.isNotEmpty && str2.isNotEmpty && str1 == str2;

bool isAuthenticated(HttpSession session) => session.keys.contains('doorknocker');

bool saveToHttpSession(var key, var value, HttpSession session) => session[key] = value;

