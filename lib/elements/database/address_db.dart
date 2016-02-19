@HtmlImport('address_db.html')
library gcanvas.address_db;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:lawndart/lawndart.dart';

import 'package:gcanvas/gcanvas.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';


@PolymerRegister('address-db')
class AddressDB extends PolymerElement {
  String _clientId;
  @property String get clientId => _clientId;
  @reflectable void set clientId(val) {
    _clientId = val;
    notifyPath('clientId', clientId);
  }

  int _baseURL;
  @property int get baseURL => _baseURL;
  @reflectable void set baseURL(val) {
    _baseURL = val;
    notifyPath('baseURL', baseURL);
  }

  AddressListCtrl _ctrl;
  @property Future<AddressListCtrl> get ctrl async {
    if(_ctrl == null) {
      _ctrl = new AddressListCtrl.create();
    }

    return _ctrl;
  }

  SyncCtrl _syncCtrl;
  Future<SyncCtrl> get syncCtrl async {
    if(_syncCtrl == null) {
      _syncCtrl = new SyncCtrl.create(ctrl: await ctrl);
    }

    return _syncCtrl;
  }


  @property var response;

  static final String peopleDownloadURI =  'json/people.json';
  static final String residentsUploadURI = 'json/residents';

  AddressDB.created() : super.created();

  /**
   * This is about uploading updated voters details, if any exist, and
   * download a new list of people.  Each persons details downloaded has their
   * address. Using this address as a key to a dictionary, adds each person
   * who lives at that address to the dictionary, using the address as the
   * dictionary key.  This way we can create a list of addresses, which
   * contain a list of it's residents, rather than have a list of voters with
   * an address duplicated accross all the residents at that address.
   */
  Future<bool> sync() async {
    bool result = await _upload();
    if(result == true) {
      return _download();
    }

    return false;
  }


  Future<bool> _download() async {
    return await (await syncCtrl).sync();
  }


  Future<bool> _upload() async {
//    Completer<bool> completer = new Completer<bool>();

//    ctrl.getList().then((addresses) {
//      if(addresses.length > 0) {
//        var residents = addresses.map((address) => address.residents.map((resident) => resident.toMap())).expand((resident) => resident).toList();
//        var data = JSON.encode(residents);
////        ($['ajax'] as CoreAjax)
////          ..url = '$baseURL/$residentsUploadURI'
////          ..method = 'POST'
////          ..body = data
////          ..go()
////          ..onCoreResponse.listen((Event e) {
////            completer.complete(e.detail.request.readyState == 200);
////          })
////          ;
//      } else {
//        completer.complete(true);
//      }
//    });
//
//    return completer.future;
    return true;
  }
}
