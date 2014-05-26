import 'package:polymer/polymer.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/gcanvas.dart';
//import 'package:gcanvas/map/map.dart';

import 'dart:html';

import 'dart:js';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @observable final List<Address> addresses = toObservable([]);

  @observable var refreshIcon = 'refresh';
  @observable var accountIcon = 'account';

  @published ResidentResponseCtrl responseCtrl = new ResidentResponseCtrl.create();
  @published SyncCtrl syncCtrl = new SyncCtrl.create();
  @published State appState = new State.create();
  @published AppStateCtrl appStateCtrl = new AppStateCtrl.create();
  @published AddressListCtrl addressListCtrl = new AddressListCtrl.create();

  GCanvasApp.created() : super.created();


  void attached() {
    super.attached();

    _loadAppState();
  }


  void _loadAppState() {
    addressListCtrl.getList().then((addrList) {
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
    syncCtrl.sync().then((_) {
      _loadAppState();
    });
  }


  void showAddress(event) {
    var address = event.detail as Address;
    appState.selectAddressView(address);

    appStateCtrl.save(appState);

    doFlip();

    hideMenuItems();
  }

  void hideMenuItems() {
    $['refresh'].style.display = 'none';
    $['account'].style.display = 'none';
  }


  nextAddress(event) {
    _setVisited();

    if(addresses.last.id != appState.address.id) {
      int pos = addresses.indexOf(appState.address);
      appState.address = addresses[pos+1];
      appStateCtrl.save(appState);
      print(appState.address);
    } else {
      doFlip();
      showMenuIcons();
    }

  }


  hideAddress(event) {
    _setVisited();

    doFlip();

    showMenuIcons();
  }

  void showMenuIcons() {
    $['refresh'].style.display = 'inline-block';
    $['account'].style.display = 'inline-block';
  }

  void _setVisited() {
    appState.address.visited = true;
    addressListCtrl.update(appState.address);
  }


  doFlip() {
    var flipbox = new JsObject.fromBrowserObject($['flipbox']);
    flipbox.callMethod('toggle');
  }


  setUpAccount([e]) {

  }


  submitResponse(e) {
    responseCtrl.add(e.detail);
  }
}
