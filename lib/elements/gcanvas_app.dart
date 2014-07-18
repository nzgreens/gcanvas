import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/gcanvas.dart';

import 'package:core_elements/core_drawer_panel.dart';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @published ResidentResponseCtrl responseCtrl = new ResidentResponseCtrl.create();
  @published State appState = new State.create();

  @observable final List<Address> addresses = toObservable([]);

  @observable String refreshIcon = 'refresh';
  @observable String accountIcon = 'account-box';
  @observable String menuIcon = "menu";

  @observable User user = new User.blank();
  @observable var phoneScreen;

  var addressService;
  var appstateService;


  GCanvasApp.created() : super.created();

  domReady() {
    super.domReady();
    addressService = window.document.querySelector('#address-service');
    appstateService = window.document.querySelector('#appstate-service');
    _loadAppState();
  }

  //@TODO: shift service elements to index.html, and use querySelector to get a reference to them.
  void _loadAppState() {
    addressService.getAddressList().then((addrList) {
      addresses
        ..clear()
        ..addAll(addrList);
      appstateService.get().then((state) {
        appState = state;
        if(addresses.isNotEmpty) {
          Address address = addresses.firstWhere((address) => !address.visited, orElse: () {});
          appState.address = address;
        }
        appstateService.save(appState); //@TODO: make sure this is only done when no state is stored in browser DB
      });
    });
  }


  void refresh() {
    addressService.sync();
  }


  void showAddress(event) {
    var address = event.detail as Address;
    appState.selectAddressView(address);

    appstateService.save(appState);
  }


  nextAddress(event) {
    _setVisited();

    if(addresses.last.id != appState.address.id) {
      int pos = addresses.indexOf(appState.address);
      appState.address = addresses[pos+1];
      appstateService.save(appState);
    }
  }


  prevAddress(event) {
    _setVisited();

    if(addresses.first.id != appState.address.id) {
      int pos = addresses.indexOf(appState.address);
      appState.address = addresses[pos-1];
      appstateService.save(appState);
    }
  }


  hideAddress(event) {
    _setVisited();
  }


  void _setVisited() {
    appState.address.visited = true;
    addressService.update(appState.address);
  }


  setUpAccount([e]) {

  }


  menu(e) {
    (shadowRoot.querySelector('#panel') as CoreDrawerPanel).jsElement.callMethod("togglePanel");
  }

  submitResponse(e) {
    responseCtrl.add(e.detail);
  }


  addressesChanged() {
    print("addressesChanged");
    //_loadAppState();
  }


  reverseAddresses(e) {
    var reversed = addresses.reversed.toList();
    addresses.clear();
    addresses.addAll(reversed);
    var address = addresses.firstWhere((address) => !address.visited, orElse: () {});;
    appState.selectAddressView(address);

    appstateService.save(appState);
  }
}
