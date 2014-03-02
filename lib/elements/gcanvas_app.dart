import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/map/map.dart';

import 'dart:html';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @observable final List<Address> addresses = toObservable([]);
  @observable final List<Address> availableAddresses = toObservable([]);
  @observable Address address;
  @observable final List<Resident> residentsAtAddress = toObservable([]);
  @observable GeoCoordinates location;

  @observable State appState;
  AppStateCtrl _appStateCtrl;
  AddressListCtrl _addressListCtrl;

  GCanvasApp.created() : super.created() {
    _addressListCtrl = new AddressListCtrl.create();
    _appStateCtrl = new AppStateCtrl.create();
    _addressListCtrl.getList().then((addrList) {
      addresses.addAll(addrList);
      availableAddresses.addAll(addresses);
      _appStateCtrl.get().then((state) {
        appState = state;
      });
    });

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
      new GeoLocation.create().getCurrent().then((position) {
        var latitude = position.latitude;
        var longitude = position.longitude;
        location = position;
        /*DelayedHttp http = new DelayedHttp.create();
        http.get("/address/${latitude}/${longitude}").then((request) {
          List addressList = JSON.decode(request.response);
          //addresses.clear();
          addressList.forEach((map) {
            Address addr = new Address.fromMap(map);
            _addressListCtrl.add(addr);
            addresses.add(addr);
          });
        });*/
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



  void setupMarker(Event event) {
    MapMarker marker = event.detail['marker'] as MapMarker;
    Address address = event.detail['address'] as Address;
    /*marker.onClick.listen((MouseEvent event) {
      if(!marker.selected) {
        marker.setIcon("/assets/gcanvas/images/selected_address.png");
        marker.selected = true;
        print("selected");
      } else {
        marker.resetIcon();
        marker.selected = false;
      }
    });*/
  }
}