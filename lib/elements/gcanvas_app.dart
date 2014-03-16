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
  @observable final List<Element> xnodes = toObservable([]);
  @observable List<int> layout = toObservable([
    [ 1, 2, 3, 4 ],
    [ 5, 5, 5, 5 ]
  ]);


  GCanvasApp.created() : super.created() {
    _addressListCtrl = new AddressListCtrl.create();
    _appStateCtrl = new AppStateCtrl.create();

    _loadAppState();

    xnodes.add($['back_button_box']);
    xnodes.add($['title_element']);
    xnodes.add($['show_map_button_box']);
    xnodes.add($['refresh_button_box']);
    xnodes.add($['content']);
  }


  void _loadAppState() {
    _addressListCtrl.getList().then((addrList) {
      addresses.addAll(addrList);
      availableAddresses.addAll(addresses);
      _appStateCtrl.get().then((state) {
        appState = state;
        _appStateCtrl.save(appState); //@TODO: make sure this is only done when no state is stored in browser DB
      });
    });
  }


  void navBack() {
    appState.selectAddressListView();

    _addressListCtrl.getList().then((addrList) {
      addresses.clear();
      addresses.addAll(addrList.where((address) => !address.visited));
    });

    _appStateCtrl.save(appState);
  }


  void refresh() {
    DelayedHttp http = new DelayedHttp.create();
    var url =
    _addressListCtrl.getList().then((addresses) {
      var visitedAddrs = addresses.where((address) => address.visited);
      //http.post(url)
    });
  }


  void showAddress(event) {
    var address = event.detail as Address;
    appState.selectAddressView(address);

    _appStateCtrl.save(appState);
  }



  void setupMarker(event) {
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



  void showMap(event) {
    try {
      new GeoLocation.create().getCurrent().then((position) {
        location = position;

        appState.selectAddressSelector();

        _appStateCtrl.save(appState);
      });
    } on PositionError catch(e) {
      print(e);
    }
  }
}
