import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'dart:html';

import 'dart:html' show Event;

@CustomTag("address-list")
class AddressList extends PolymerElement {
  @published List<Address> addresses;

  AddressList.created() : super.created();

  void addressClicked(Event event) {
    var customEvent = new CustomEvent('address-clicked', detail: event.detail);
    dispatchEvent(customEvent);
  }
}