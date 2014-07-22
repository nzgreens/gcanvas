part of gcanvas.server;

typedef RequestHandler(HttpRequest request);

final POST = 'POST';


//need these for the pattern matching like \d+ to work.
UrlPattern serveAddrMatch = new UrlPattern(r'/address/(-?\d+\.\d+)/(\d+\.\d+)');
UrlPattern indivAddrMatch = new UrlPattern(r'/address/(\d+)');
UrlPattern serveAddrJsonMatch = new UrlPattern(r'/address');

UrlPattern userStatusMatch = new UrlPattern(r'/accounts/user.json');
UrlPattern userRegisterMatch = new UrlPattern(r'/accounts/register');
UrlPattern nationbuilderRedirectURLMatch = new UrlPattern(r'/nationbuilder/callback');


Router setupRouter(HttpServer server) {
  Router router = new Router(server)
    ..serve(userStatusMatch).listen(getUserStatus())
    ..serve(userRegisterMatch, method: POST).listen(registerUser())
    ..serve(nationbuilderRedirectURLMatch).listen(handleNationBuilderCallback())
    //..defaultStream.listen(defaultHandler())
/*    ..serve(serveAddrMatch).listen(serveAddresses(conn))
    ..serve(serveAddrJsonMatch, method: 'get'.toUpperCase()).listen((getAddressesJson(conn)))
    ..serve(indivAddrMatch, method: 'get'.toUpperCase()).listen((getAddressJson(conn)))*/
    ;

  return router;
}


RequestHandler registerUser() {
  var type = 'application';
  var subType = 'json';

  return (HttpRequest request) {
    request.response.headers.contentType = new ContentType(type, subType);
    Map<String, String> status = {};

    BytesBuilder builder = new BytesBuilder();

    print(request);

    request.listen((buffer) {
      builder.add(buffer);
      print("Buffer: $buffer");
    }, onDone: () {
      print('builder');
      Map<String, String> userDataMap;
      try {
        String jsonString = UTF8.decode(builder.takeBytes());
        print(jsonString);
        userDataMap = JSON.decode(jsonString);
      } on FormatException catch(e) {
        print(e);
        userDataMap = {};
      }
      if(userDataMap.containsKey('firstname') && userDataMap.containsKey('lastname') && userDataMap.containsKey('email') && userDataMap.containsKey('password') ) {
        register(userDataMap['firstname'], userDataMap['lastname'], userDataMap['email'], userDataMap['password']).then((registered) {

          if(registered) {
            status['status'] = 'registered';
          } else {
            status['status'] = 'not registered';
          }
        });
      } else {
        status['status'] = 'not registered';
      }

      request.response
        ..write(JSON.encode(status))
        ..close()
        ;
    });
  };
}


RequestHandler handleNationBuilderCallback() {
  return (HttpRequest request) {
    futureConnection.then((DatastoreConnection connection) {
      Datastore datastore = new Datastore(connection);

      datastore.withTransaction((Transaction transaction) {
        Key key = new Key('OAuth2Credentials', name: Platform.environment['client_id'.toUpperCase()]);
        return datastore.lookup(key).then((entityResult) {
          if(entityResult.isPresent) {
            OAuth2Credentials oauth2Creds = entityResult.entity;

            var handler = new OAuth2Handler.create(
                oauth2Creds.client_id,
                oauth2Creds.client_secret,
                oauth2Creds.client_name,
                oauth2Creds.redirect_url,
                oauth2Creds.access_token_url,
                oauth2Creds.authorise_url,
                oauth2Creds.base_url);
            handler.get_tokens(request.uri.queryParameters).then((tokens) {
              oauth2Creds.access_token = tokens['access_token'];
              transaction.update.add(oauth2Creds);
            });
            //oauth2.Credentials creds = new oauth2.Credentials(oauth2Creds.access_token);
          } else {
          }
        });
      });
    });
  };
}


RequestHandler getUserStatus() {
  var type = 'application';
  var subType = 'json';

  return (HttpRequest request) {
    var data = request.session.isNew == true ? {'status': 'unauthenticated'} : {'status': isAuthenticated(request.session) ? 'authenticated' : 'unauthenticated'};
    request.response.headers.contentType = new ContentType(type, subType);

    request.response
      ..write(JSON.encode(data))
      ..close()
      ;
  };
}


RequestHandler defaultHandler() {
  var type = 'application';
  var subType = 'json';

  return (HttpRequest request) {
    var data = request.session.isNew == true ? {'status': request.uri.toString()} : {};
    request.response.headers.contentType = new ContentType(type, subType);

    request.response
      ..write(JSON.encode(data))
      ..close()
      ;
  };
}
