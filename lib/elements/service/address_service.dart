import 'dart:async' show Future;

import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/address.dart';

@CustomTag('address-service')
class AddressService extends PolymerElement {
  @published String userEmail;
  @published bool synced;

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