import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';

import 'dart:html';

@CustomTag('address-list-item')
class AddressListItemElement extends PolymerElement {
  @published Address address;
  AddressListItemElement.created() : super.created() {
    onClick.listen((_) {
      dispatchEvent(new CustomEvent("address-item-clicked", detail: address));
    });
  }
}