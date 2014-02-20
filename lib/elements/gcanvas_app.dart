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

  @observable State appState;
  AppStateCtrl _appStateCtrl;
  AddressListCtrl _addressListCtrl;

  GCanvasApp.created() : super.created() {
    _addressListCtrl = new AddressListCtrl.create();
    _appStateCtrl = new AppStateCtrl.create();
    _addressListCtrl.getList().then((addrList) {
      addresses.addAll(addrList);
      _appStateCtrl.get().then((state) {
        appState = state;
      });
    });

    var count = 10;
    var generator = (n) => n;

    var it = new Iterable.generate(count, generator);
  }


  @override
  void enteredView() {
    super.enteredView();
  }


  void navBack() {
    appState.addressView = false;
    appState.addressListView = true;
    _addressListCtrl.getList().then((addrList) {
      addresses.clear();
      addresses.addAll(addrList.where((address) => !address.visited));
    });

    _appStateCtrl.save(appState);
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
    appState.address = event.detail as Address;
    appState.addressView = true;
    appState.addressListView = false;

    _appStateCtrl.save(appState);
  }
}