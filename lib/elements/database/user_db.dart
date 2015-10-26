@HtmlImport('user_db.html')
library gcanvas.user_db;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:gcanvas/gcanvas.dart';

@PolymerRegister('user-db')
class UserDB extends PolymerElement {
  String _clientId = '';
  @Property(notify: true)
  String get clientId => _clientId;
  @reflectable
  void set clientId(val) {
    _clientId = val;
    notifyPath('clientId', clientId);
  }

  String _baseURL;
  @Property(notify: true)
  String get baseURL => _baseURL;
  @reflectable
  void set baseURL(val) {
    _baseURL = val;
    notifyPath('baseURL', baseURL);
  }

  @Property(notify:true) Map response;

  static final String statusURI = 'accounts/user.json';
  static final String loginURI = 'accounts/login';
  static final String registerURI = 'accounts/register';

  @Property(notify: true, reflectToAttribute: true)   User user;
//  , observer: 'userChanged')

  UserDB.created() : super.created();


  attached() {
    super.attached();
  }


//  @Observe('user')
//  void userChanged([_]) {
//    print('user: $user');
//  }


  Future<Map> status() async {
    String jsonText = await HttpRequest.getString('$baseURL/$statusURI');
    response = JSON.decode(jsonText);

    print('status');

    return response;
  }


  Future<bool> login() {
    Completer<bool> completer = new Completer<bool>();

//    ($['ajax'] as CoreAjax)
//      ..url = '$baseURL/$loginURI'
//      ..method = 'GET'
//      ..go()
//      ..onCoreResponse.listen((status) {
//        var response = status.detail['response'];
//        if(response.keys.contains('status') && response['status'] != 'authenticated') {
//          completer.complete(false);
//          window.location.href = response.keys.contains('loginUrl') ? response['loginUrl'] : '';
//        } else {
//          completer.complete(true);
//        }
//      })
//      ;

//    return completer.future;
    return new Future.value(true);
  }


  @reflectable
  Future<bool> registration(User user, {String password: ''}) {
    Completer<bool> completer = new Completer<bool>();

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
    HttpRequest.request('$baseURL/$registerURI', method: 'POST', responseType: 'application/json', mimeType: 'application/json', sendData: JSON.encode(data)).
      then((request) {
      var response = JSON.decode(request.responseText);
      completer.complete(response.keys.contains('status') && response['status'] == 'authenticated');
    });

    return completer.future;
  }
}

