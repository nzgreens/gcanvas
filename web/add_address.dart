import 'package:polymer/polymer.dart';
import 'package:gcanvas/gcanvas.dart';
import 'package:gcanvas/address.dart';
import 'dart:html' show querySelector, Event;
import 'dart:math' show max;


main() {
  AddressListCtrl addrListCtrl = new AddressListCtrl.create();
  initPolymer().run((){
    querySelector("address-edit").on["address-creation-save"].listen((Event event) {
      if(event.detail != null) {
        Address addr = event.detail;
        addrListCtrl.getList().then((addresses) {
          List<int> ids = addresses.map((address) => address.id).toList();
          addr.id = ids.length > 0 ? ids.reduce((int a, int b) {
            if (b == null) {
              return a;
            }

            return max(a, b);
          }) + 1 : 1;
          addrListCtrl.add(addr);
        });

      } else {
        print("detail is null");
      }
    });
  });
}
