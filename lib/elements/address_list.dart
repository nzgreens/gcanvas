import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';

import 'dart:html' show Event;

@CustomTag("address-list")
class AddressList extends PolymerElement {
  @published List<Address> addresses;

  AddressList.created() : super.created();


  @override
  void ready() {
    super.ready();

    print("AddressList ready");
  }

  @override
  void enteredView() {
    super.enteredView();
  }


  void addressClicked(Event event) {
    fire('address-clicked', detail: event.detail);
  }
}