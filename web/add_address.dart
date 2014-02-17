import 'package:polymer/polymer.dart';
import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/address.dart';
import 'dart:html' show querySelector, Event;

main() {
  AddressListCtrl addrListCtrl = new AddressListCtrl.create();
  initPolymer().run((){
    querySelector("address-edit").on["address-creation-save"].listen((Event event) {
      if(event.detail != null) {
        Address addr = event.detail;
        addr.id = 0;
        addrListCtrl.add(addr);
      } else {
        print("detail is null");
      }
    });
  });
}
