import 'package:polymer/polymer.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/gcanvas.dart';

import 'package:core_elements/core_drawer_panel.dart';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @published ResidentResponseCtrl responseCtrl = new ResidentResponseCtrl.create();
  @published SyncCtrl syncCtrl = new SyncCtrl.create();
  @published State appState = new State.create();
  @published AppStateCtrl appStateCtrl = new AppStateCtrl.create();
  @published AddressListCtrl addressListCtrl = new AddressListCtrl.create();

  @observable final List<Address> addresses = toObservable([]);

  @observable String refreshIcon = 'refresh';
  @observable String accountIcon = 'account-box';
  @observable String menuIcon = "menu";

  @observable User user = new User.blank();
  @observable var phoneScreen;

  GCanvasApp.created() : super.created() {
    _loadAppState();
  }

  void _loadAppState() {
    addressListCtrl.getList().then((addrList) {
      addresses
        ..clear()
        ..addAll(addrList);
      appStateCtrl.get().then((state) {
        appState = state;
        if(addresses.isNotEmpty) {
          Address address = addresses.firstWhere((address) => !address.visited, orElse: () {});
          appState.address = address;
        }
        appStateCtrl.save(appState); //@TODO: make sure this is only done when no state is stored in browser DB
      });
    });
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
    } else {
      showMenuIcons();
    }

  }


  hideAddress(event) {
    _setVisited();

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

    appStateCtrl.save(appState);
  }

  phoneScreenChanged() {
    print("phoneScreen: $phoneScreen");
  }
}
