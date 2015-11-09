@HtmlImport('address_db.html')
library gcanvas.address_db;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';


import 'dart:async';
import 'dart:html';
import 'dart:convert';

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
  @property AddressListCtrl get ctrl => _ctrl;
  @reflectable void set ctrl(val) {
    _ctrl = val;
    notifyPath('ctrl', ctrl);
  }

  @property var response;

  static final String peopleDownloadURI =  'json/people.json';
  static final String residentsUploadURI = 'json/residents';

  AddressDB.created() : super.created() {
    ctrl = new AddressListCtrl.create();
  }

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
    Completer<bool> completer = new Completer<bool>();

    var addresses = {};

//    ($['ajax'] as IronAjax)
//        ..url = '$baseURL/$peopleDownloadURI'
//        ..method = 'GET'
//        ..go()
//        ..onCoreResponse.listen((Event e) {
//            response['results'].forEach((Map item) {
//              var id = item['id'];
//              var firstname = item['first_name'];
//              var lastname = item['last_name'];
//              var occupation = item['occupation'];
//              var gender = item['sex'];
//              var dob = DateTime.parse(item['birthdate']);
//              var notes = item['note'];
//              var email = item['email'];
//              var phone = item['phone'];
//
//              var resident = new Resident.create(id: id, firstname: firstname, lastname: lastname, occupation: occupation, gender: gender, dob: dob, notes: notes, email: email, phone: phone);
//
//              var addr = item['primary_address'];
//              var latitude = addr['lat'];
//              var longitude = addr['lng'];
//              var address1 = addr['address1'];
//              var address2 = addr['address2'];
//              var address3 = addr['address3'];
//              var city = addr['city'];
//              var postcode = addr['zip'];
//              if(!addresses.containsKey("$latitude,$longitude,$address1,$address2,$address3,$city")) {
//                Address address = new Address.create(id: "$latitude,$longitude,$address1,$address2,$address3,$city", address1: address1, address2: address2, address3: address3, city: city, postcode: postcode, latitude: latitude, longitude: longitude, residents: [resident]);
//                addresses["$latitude,$longitude,$address1,$address2,$address3,$city"] = address;
//              } else {
//                Address address = addresses["$latitude,$longitude,$address1,$address2,$address3,$city"];
//                address.residents.add(resident);
//              }
//            });
//
//            int count = 0;
//            addresses.values.forEach((address) => ctrl.add(address).then((_) => count++));
//
//            Timer timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
//              if(count == addresses.length) {
//                completer.complete(e.detail.request.readyState == 200);
//                timer.cancel();
//              }
//            });
//        })
//        ;
//
//
//    return completer.future;

    return false;
  }


  Future<bool> _upload() async {
    Completer<bool> completer = new Completer<bool>();

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
    return false;
  }
}
