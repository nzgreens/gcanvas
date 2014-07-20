part of gcanvas.client;

@reflectable
class UserCtrl {
  final Http _http;

  UserCtrl(this._http);


  factory UserCtrl.create({Http http}) {
    http = http != null ? http : new Http();

    return new UserCtrl(http);
  }

  Future<Map> userStatus() {
    Completer<Map> completer = new Completer<Map>();

    _http.get('accounts/user.json').then((HttpRequest request) {
      var user = JSON.decode(request.response);
      completer.complete(user);
    });

    return completer.future;
  }


  Future<bool> userLogin(email, password) {
    Completer<bool> completer = new Completer<bool>();

    _http.post('accounts/login', data: {'email': email, 'password': password}).then((HttpRequest request) {
      Map response = JSON.decode(request.response);

      completer.complete(response.keys.contains('status') && response['status'] == 'authenticated');
    });


    return completer.future;

    //return new Future.value(true);
  }



  Future<bool> userRegistration(User user, String password) {
    Completer<bool> completer = new Completer<bool>();

    _http.post('accounts/register', data: {'firstname': user.firstname, 'lastname': user.lastname, 'email': user.email, 'password': password}).then((HttpRequest request) {
      Map response = JSON.decode(request.response);

      completer.complete(response.keys.contains('status') && response['status'] == 'authenticated');
    });


    return completer.future;

    //return new Future.value(true);
  }
}