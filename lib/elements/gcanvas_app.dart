import 'package:polymer/polymer.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'package:gcanvas/gcanvas.dart';
//import 'package:gcanvas/map/map.dart';

import 'dart:html';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @observable final List<Address> addresses = toObservable([]);
  @observable final List<Address> availableAddresses = toObservable([]);
  @observable Address address;
  @observable final List<Resident> residentsAtAddress = toObservable([]);
  //@observable GeoCoordinates location;


  @published SyncCtrl syncCtrl = new SyncCtrl.create();
  @published State appState = new State.create();
  @published AppStateCtrl appStateCtrl = new AppStateCtrl.create();
  @published AddressListCtrl addressListCtrl = new AddressListCtrl.create();
  @observable final List<Element> xnodes = toObservable([]);
  @observable List<int> layout = toObservable([
    [ 1, 2, 3 ],
    [ 4, 4, 4 ]
  ]);


  GCanvasApp.created() : super.created() {

  }


  void enteredView() {
    super.enteredView();


    _loadAppState();

    xnodes.add($['back_button_box']);
    xnodes.add($['title_element']);
    xnodes.add($['refresh_button_box']);
    xnodes.add($['content']);
  }


  void _loadAppState() {
    addressListCtrl.getList().then((addrList) {
      print(addrList);
      addresses
      ..clear()
      ..addAll(addrList);
      //availableAddresses.addAll(addresses);
      appStateCtrl.get().then((state) {
        appState = state;
        appStateCtrl.save(appState); //@TODO: make sure this is only done when no state is stored in browser DB
      });//,
      //onError: () => appState = new State.create());
    });
  }


  void navBack() {
    appState.selectAddressListView();

    addressListCtrl.getList().then((addrList) {
      addresses
      ..clear()
      ..addAll(addrList);
    });

    appStateCtrl.save(appState);
  }


  void refresh() {
    //var syncCtrl = SyncCtrl(new Http(), _addressListCtrl);
    syncCtrl.sync().then((_) {
      _loadAppState();
    });
    /*DelayedHttp http = new DelayedHttp.create();
    var url =
    _addressListCtrl.getList().then((addresses) {
      var visitedAddrs = addresses.where((address) => address.visited);
      //http.post(url)
    });*/
  }


  void showAddress(event) {
    var address = event.detail as Address;
    appState.selectAddressView(address);

    appStateCtrl.save(appState);
  }



  /*void setupMarker(event) {
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
  }*/



  /*void showMap(event) {
    try {
      new GeoLocation.create().getCurrent().then((position) {
        location = position;

        appState.selectAddressSelector();

        _appStateCtrl.save(appState);
      });
    } on PositionError catch(e) {
      print(e);
    }
  }*/
}
