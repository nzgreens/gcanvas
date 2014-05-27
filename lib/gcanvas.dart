library gcanvas.client;

//@TODO create admin view where they can move around a map and allocate houses to people

import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:browser_detect/browser_detect.dart' as detect;
import 'package:observe/observe.dart';
import 'package:lawndart/lawndart.dart';
import 'package:uuid/uuid_client.dart';

import 'address.dart';
import 'resident.dart';
import 'response.dart';

part 'addressctrl.dart';
part 'residentctrl.dart';
part 'responsectrl.dart';
part 'delayedhttp.dart';
part 'state.dart';
part 'appstatectrl.dart';
part 'syncctrl.dart';




class Http {// extends BrowserClient {
  Future<HttpRequest> get(url, {headers, responseType: ''}) {
    headers = headers != null ? headers : {};

    return HttpRequest.request(url, method: 'GET', responseType: responseType, requestHeaders: headers);
  }
}