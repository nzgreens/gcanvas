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

  String _baseURL = '';
  @Property(notify: true)
  String get baseURL => _baseURL;
  @reflectable
  void set baseURL(val) {
    _baseURL = val;
    notifyPath('baseURL', baseURL);
  }

  User _user = new User.blank();
  @Property(notify: true, reflectToAttribute: true)
  User get user => _user;
  @reflectable
  void set user(val) {
    _user = val;
    notifyPath('user', user);
  }

  @Property(notify:true) Map response;

  static final String statusURI = 'accounts/user.json';
  static final String loginURI = 'accounts/login';
  static final String registerURI = 'accounts/register';

  UserDB.created() : super.created();


  attached() {
    super.attached();
  }


  Future<Map> status() async {
    String jsonText = await HttpRequest.getString('$baseURL/$statusURI');
    response = JSON.decode(jsonText);
    document.cookie = "csrftoken=${response['token']}";
    document.cookie = "csrf_token=${response['token']}";

    return response;
  }


  Future<bool> login(String username, String password) async {
    var data = {'username': username, 'password' : password};
    Map headers = {};
    if(window.document.cookie.contains('csrftoken')) {
      var csrftoken = new Map.fromIterable(window.document.cookie.split(';').map((cookie) => cookie.split('=')), key: (item) => item[0], value: (item) => item[1])['csrftoken'];
      print('Token: ${csrftoken}');
      headers['X-CSRFToken'] = csrftoken;
    }

    var request = await HttpRequest.request('$baseURL/$loginURI', method: 'POST', responseType: 'json', mimeType: 'application/json', requestHeaders: headers, sendData: JSON.encode(data));
    print(request.status);
    var response = request.response;
//    String jsonText = await HttpRequest.getString('$baseURL/$loginURI');
//    Map response = JSON.decode(jsonText);
    if(response.keys.contains('status') && response['status'] != 'authenticated') {
//      window.location.href = response.keys.contains('loginUrl') ? response['loginUrl'] : '';

      print(response);

      return false;
    }

    user = new User.fromMap(response);

    return true;
  }


  Future<Map> registration(User user, {String password: ''}) async {
    var data = user.toMap();
    data['password'] = password;

    Map headers = {};
    if(window.document.cookie.contains('csrftoken')) {
      var csrftoken = new Map.fromIterable(window.document.cookie.split(';').map((cookie) => cookie.split('=')), key: (item) => item[0], value: (item) => item[1])['csrftoken'];
      print('Token: ${csrftoken}');
      headers['X-CSRFToken'] = csrftoken;
    }

    var request = await HttpRequest.request('$baseURL/$registerURI', method: 'POST', responseType: 'json', mimeType: 'application/json', requestHeaders: headers, sendData: JSON.encode(data));
    print(request.status);
    var response = request.response;

    print(response);

    return response;
  }
}

