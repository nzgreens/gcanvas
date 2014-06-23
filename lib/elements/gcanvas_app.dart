import 'package:polymer/polymer.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/gcanvas.dart';


@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @published ResidentResponseCtrl responseCtrl = new ResidentResponseCtrl.create();
  @published SyncCtrl syncCtrl = new SyncCtrl.create();
  @published State appState = new State.create();
  @published AppStateCtrl appStateCtrl = new AppStateCtrl.create();
  @published AddressListCtrl addressListCtrl = new AddressListCtrl.create();

  @observable final List<Address> addresses = toObservable([]);
  @observable bool loggedIn = false;

  @observable var refreshIcon = 'refresh';
  @observable var accountIcon = 'account-box';

  @observable User user = new User.blank();

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


  authenticated(e) {
    loggedIn = true;
    user = e.detail;
  }


  notAuthenticated(e) {
    loggedIn = true;
    user = e.detail;
  }

  submitResponse(e) {
    responseCtrl.add(e.detail);
  }


  addressesChanged() {
    print("addressesChanged");
    //_loadAppState();
  }


  setLoggedIn(e) {
    loggedIn = true;
    user = e.detail;
  }


  setNotLoggedIn(e) {
    loggedIn = false;
    user = new User.blank();
  }


  registerUser(e) {

  }
}
