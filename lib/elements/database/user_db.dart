import 'package:polymer/polymer.dart';

import 'package:core_elements/core_ajax_dart.dart';

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:gcanvas/gcanvas.dart';

@CustomTag('user-db')
class UserDB extends PolymerElement {
  @PublishedProperty(reflect: true)
  String get clientId => readValue(#clientId) != null ? readValue(#clientId) : '';
  set clientId(val) => writeValue(#clientId, val);

  @PublishedProperty(reflect: true)
  String get baseURL => readValue(#baseURL) != null ? readValue(#baseURL) : '';
  set baseURL(val) => writeValue(#baseURL, val);

  @observable var response;

  static final String statusURI = 'accounts/user.json';
  static final String loginURI = 'accounts/login';
  static final String registerURI = 'accounts/register';

  UserDB.created() : super.created() {
    print('UserDB: $baseURL');
  }


  attached() {
    super.attached();
    print("baseURL: $baseURL");
  }


  Future<Map> status() {
    Completer<Map> completer = new Completer<Map>();

    ($['ajax'] as CoreAjax)
      ..url = '$baseURL/$statusURI'
      ..method = 'GET'
      ..go()
      ..onCoreResponse.listen((_) {
        completer.complete(response);
      })
      ;

    return completer.future;
  }


  Future<bool> login() {
    Completer<bool> completer = new Completer<bool>();

    ($['ajax'] as CoreAjax)
      ..url = '$baseURL/$loginURI'
      ..method = 'GET'
      ..go()
      ..onCoreResponse.listen((status) {
        var response = status.detail['response'];
        if(response.keys.contains('status') && response['status'] != 'authenticated') {
          completer.complete(false);
          window.location.href = response.keys.contains('loginUrl') ? response['loginUrl'] : '';
        } else {
          completer.complete(true);
        }
      })
      ;

    return completer.future;
  }


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

