@HtmlImport('gcanvas_app.html')
library gcanvas.gcanvas_app;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/gcanvas.dart';

import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/iron_media_query.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_toolbar.dart';

import 'package:gcanvas/elements/address_list.dart';
import 'package:gcanvas/elements/address_view.dart';
import 'package:gcanvas/elements/gcanvas_signin.dart';
import 'package:gcanvas/elements/twitter_signin.dart';
import 'package:gcanvas/elements/gcanvas_status.dart';
import 'package:gcanvas/elements/register_user.dart';
import 'package:gcanvas/elements/gcanvas_registration.dart';
import 'package:gcanvas/elements/route/app_route.dart';
import 'package:gcanvas/elements/database/user_db.dart';
import 'package:gcanvas/elements/database/address_db.dart';
import 'package:gcanvas/elements/service/address_service.dart';
import 'package:gcanvas/elements/service/appstate_service.dart';

@PolymerRegister("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @property ResidentResponseCtrl responseCtrl = new ResidentResponseCtrl.create();
  @property State appState = new State.create();

  @property final List<Address> addresses = [];

  String _refreshIcon = 'refresh';
  @property String get refreshIcon => _refreshIcon;
  @reflectable void set refreshIcon(val) {
    _refreshIcon = val;
    notifyPath('refreshIcon', refreshIcon);
  }

  String _accountIcon = 'account-box';
  @property String get accountIcon => _accountIcon;
  @reflectable void set accountIcon(val) {
    _accountIcon = val;
    notifyPath('accountIcon', accountIcon);
  }

  String _menuIcon = "menu";
  @property String get menuIcon => _menuIcon;
  @reflectable void set menuIcon(val) {
    _menuIcon = val;
    notifyPath('menuIcon', menuIcon);
  }

  User _user = new User.blank();
  @Property(notify: true, reflectToAttribute: true) User get user => _user;
  @reflectable void set user(val) {
    _user = val;
    notifyPath('user', user);
  }

  var _userCtrl;
  @Property(notify: true, reflectToAttribute: true)
  get userCtrl => _userCtrl;
  @reflectable
  void set userCtrl(val) {
    _userCtrl = val;
    notifyPath('userCtrl', userCtrl);
  }

  @property var phoneScreen;

  get addressService => new PolymerDom(this).querySelector('#address-service');
  get appstateService => new PolymerDom(this).querySelector('#appstate-service');


  GCanvasApp.created() : super.created();

  void ready() {
    async(() {
      userCtrl = new PolymerDom(this).querySelector('#user-db');
      _loadAppState();
    });
  }

  //@TODO: shift service elements to index.html, and use querySelector to get a reference to them.
  _loadAppState() async {
    List addrList = await addressService.getAddressList();
    addresses
      ..clear()
      ..addAll(addrList);
    appState = await appstateService.get();
    if(addresses.isNotEmpty) {
      Address address = addresses.firstWhere((address) => !address.visited, orElse: () {});
      appState.address = address;
    }
    appstateService.save(appState); //@TODO: make sure this is only done when no state is stored in browser DB
  }


  @reflectable
  refresh([_, __]) async {
    print('syncing addresses');
    await addressService.syncAddress();
    print('syncing addresses finished');
  }


  @reflectable
  void showAddress(event, [_]) {
    var address = event.detail as Address;
    appState.selectAddressView(address);

    appstateService.save(appState);
  }


  @reflectable
  void nextAddress(event, [_]) {
    _setVisited();

    if(addresses.last.id != appState.address.id) {
      int pos = addresses.indexOf(appState.address);
      appState.address = addresses[pos+1];
      appstateService.save(appState);
    }
  }


  @reflectable
  void prevAddress(event, [_]) {
    _setVisited();

    if(addresses.first.id != appState.address.id) {
      int pos = addresses.indexOf(appState.address);
      appState.address = addresses[pos-1];
      appstateService.save(appState);
    }
  }


  @reflectable
  void hideAddress(event, [_]) {
    _setVisited();
  }


  void _setVisited() {
    appState.address.visited = true;
    addressService.update(appState.address);
  }


  @reflectable
  void setUpAccount([_, __]) {

  }


  @reflectable
  void menu([_, __]) {
    (shadowRoot.querySelector('#panel') as PaperDrawerPanel).jsElement.callMethod("togglePanel");
  }

  @reflectable
  void submitResponse(e, [_]) {
    responseCtrl.add(e.detail);
  }


  @reflectable
  void addressesChanged([_, __]) {
    _loadAppState();
  }


  @reflectable
  void reverseAddresses([_, __]) {
    var reversed = addresses.reversed.toList();
    addresses.clear();
    addresses.addAll(reversed);
    var address = addresses.firstWhere((address) => !address.visited, orElse: () {});;
    appState.selectAddressView(address);

    appstateService.save(appState);
  }


  @reflectable
  void onRegistered([_, __]) {
    $['status'].checkStatus();
  }


  @reflectable
  void onAuthenticated([_, __]) {
    $['status'].checkStatus();
  }


  @reflectable
  void onNotAuthenticated([_, __]) {
    $['status'].checkStatus();
  }
}
