import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';

import 'dart:html';

@CustomTag('address-list-item')
class AddressListItemElement extends PolymerElement {
  @published Address address;
  @observable String visited = "";
  AddressListItemElement.created() : super.created() {
    onClick.listen((_) {
      dispatchEvent(new CustomEvent("address-item-clicked", detail: address));
    });
  }

  addressChanged() {
    _setVisited();
    address.changes.listen((records) {
      PropertyChangeRecord record = records.last;
      Symbol name = record.name;
      bool value = record.newValue;

      if(name == new Symbol('visited') && value == true) {
        _setVisited();
      }

    });
  }


  _setVisited() {
    visited = address.visited == true ? "visited" : "";
  }
}