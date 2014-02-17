import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'package:gcanvas/gcanvas.dart';

import 'dart:html';
import 'dart:convert' show JSON;

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @observable final List<Address> addresses = toObservable([]);
  @observable Address address;
  @observable final List<Resident> residentsAtAddress = toObservable([]);

  @observable AddressListCtrl _addressListCtrl;

  @observable bool addressListView = true;
  @observable bool addressView = false;

  GCanvasApp.created() : super.created() {
    _addressListCtrl = new AddressListCtrl.create();
    _addressListCtrl.getList().then((addrList) {
      addresses.addAll(addrList);
    });
  }


  @override
  void enteredView() {
    super.enteredView();

    $['back'].hidden = true;
  }


  void navBack() {
    addressView = false;
    addressListView = true;
    $['back'].hidden = true;
    _addressListCtrl.getList().then((addrList) {
      addresses.clear();
      addresses.addAll(addrList.where((address) => !address.visited));
    });
  }


  void refresh() {
    try {
      window.navigator.geolocation.getCurrentPosition().then((position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;
        DelayedHttp http = new DelayedHttp.create();
        http.get("/address/${latitude}/${longitude}").then((request) {
          List addressList = JSON.decode(request.response);
          addresses.clear();
          addressList.forEach((map) {
            Address addr = new Address.fromMap(map);
            _addressListCtrl.add(addr);
            addresses.add(addr);
          });
        });
      });
    } on PositionError catch(e) {
      print(e);
    }
  }


  void showAddress(Event event) {
    address = event.detail as Address;
    address.visited = true;
    _addressListCtrl.update(address);
    addressView = true;
    addressListView = false;
    $['back'].hidden = false;
  }
}