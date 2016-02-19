@HtmlImport('address_service.html')
library gcanvas.address_service;

import 'dart:html';
import 'dart:async' show Future;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/address.dart';

import 'package:polymer_elements/paper_toast.dart';

@PolymerRegister('address-service')
class AddressService extends PolymerElement {
  @Property(notify: true, reflectToAttribute: true) String userEmail;
  @Property(notify: true, reflectToAttribute:true) bool synced;
  @Property(notify: true, reflectToAttribute: true) final List<Address> addresses = [];

  final AddressListCtrl addrCtrl = new AddressListCtrl.create();
  get ctrl => new PolymerDom(this).querySelector('#address-db');

  AddressService.created() : super.created();

  attached() {
    super.attached();
  }


  Future<bool> syncAddress() async {
    print('syncing addresses with server: ${ctrl}');
    bool result = await ctrl.sync();
    synced = result;
    if(synced == true) {
      $['synced'].toggle();
    } else {
      $['notSynced'].toggle();
    }

    return synced;
  }


  Future<List<Address>> getAddressList() async {
    return addresses
      ..clear()
      ..addAll(await addrCtrl.getList());
  }


  Future<bool> update(Address addr) {
    return addrCtrl.update(addr);
  }
}