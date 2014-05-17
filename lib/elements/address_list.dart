import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';

import 'dart:html' show Event, CustomEvent;

@CustomTag("address-list")
class AddressList extends PolymerElement {
  @published List<Address> addresses = toObservable([]);

  AddressList.created() : super.created();

  void addressClicked(Event event) {
    var customEvent = new CustomEvent('address-clicked', detail: event.detail);

    dispatchEvent(customEvent);
  }
}