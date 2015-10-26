library gcanvas.client;

//@TODO create admin view where they can move around a map and allocate houses to people

import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:browser_detect/browser_detect.dart' as detect;
import 'package:reflectable/reflectable.dart';
import 'package:lawndart/lawndart.dart';
import 'package:uuid/uuid.dart';
import 'package:polymer/polymer.dart' show JsProxy, reflectable;

import 'address.dart';
import 'resident.dart';
import 'response.dart';

part 'addressctrl.dart';
part 'residentctrl.dart';
part 'responsectrl.dart';
//part 'delayedhttp.dart';
part 'state.dart';
part 'appstatectrl.dart';
part 'syncctrl.dart';
part 'user.dart';
part 'userctrl.dart';


class Http extends JsProxy {// extends BrowserClient {
  @reflectable final HttpRequest request = new HttpRequest();

  Http();

  _safariFix(responseType) {
    if(detect.browser.isSafari) {
      return "";  //Only needed for Safari, other browsers are sain
    }

    return responseType;
  }

  Future<HttpRequest> get(String url, {Map<String, String> headers, String responseType: 'application/json'}) {

    headers = headers != null ? headers : {};

    return HttpRequest.request(url, method: 'GET', responseType: _safariFix(responseType), requestHeaders: headers);
  }


  Future<HttpRequest> post(String url, {String data, Map<String, String> headers, String responseType: 'application/json'}) {
    headers = headers != null ? headers : {};

    return HttpRequest.request(url, method: 'POST', responseType: _safariFix(responseType), sendData: data);

    //return HttpRequest.postFormData(url, data, responseType: _safariFix(responseType), requestHeaders: headers);
  }
}