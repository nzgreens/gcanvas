@HtmlImport('address_service.html')
library gcanvas.address_service;

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

  final AddressListCtrl addrCtrl = new AddressListCtrl.create();
  get ctrl => querySelector('#address-db');

  AddressService.created() : super.created();

  attached() {
    super.attached();
  }


  Future<bool> sync() {
    return ctrl.sync().then((result) {
      synced = result;
      if(synced == true) {
        $['synced'].toggle();
      } else {
        $['notSynced'].toggle();
      }
    });
  }


  Future<List<Address>> getAddressList() {
    return addrCtrl.getList();
  }


  Future<bool> update(Address addr) {
    return addrCtrl.update(addr);
  }
}