part of gcanvas.client;

class UserCtrl extends JsProxy {
  final Http _http;
  @reflectable String baseURL = '';
  static final String statusURI = 'accounts/user.json';
  static final String loginURI = 'accounts/login';
  static final String registerURI = 'accounts/register';

  UserCtrl(this._http);


  factory UserCtrl.create({Http http}) {
    http = http != null ? http : new Http();

    return new UserCtrl(http);
  }

  Future<Map> status() {
    Completer<Map> completer = new Completer<Map>();

    _http.get('accounts/user.json').then((HttpRequest request) {
      var user = JSON.decode(request.response);
      completer.complete(user);
    });

    return completer.future;
  }


  Future<bool> login(email, password) {
    Completer<bool> completer = new Completer<bool>();

    _http.post('accounts/login', data: JSON.encode({'email': email, 'password': password})).then((HttpRequest request) {
      Map response = JSON.decode(request.response);

      completer.complete(response.keys.contains('status') && response['status'] == 'authenticated');
    });


    return completer.future;

    //return new Future.value(true);
  }



  Future<bool> registration(User user, {String password}) async {
    var data = user.toMap();
    data['password'] = password;

    /*($['ajax'] as CoreAjax)
      ..url = '$baseURL/$registerURI'
      ..headers = {'Content-Type': 'application/json:;odata=verbose'}
      ..method = 'POST'
      ..body = JSON.encode(data)
      ..go()
      ..onCoreResponse.listen((_) {
        completer.complete(response.keys.contains('status') && response['status'] == 'authenticated');
      })
      ;*/
    var request = await HttpRequest.request('$baseURL/$registerURI', method: 'POST', responseType: 'json', mimeType: 'application/json', sendData: JSON.encode(data));
    if(request.status == 200) {

      return true;
    }

    return false;
  }
}