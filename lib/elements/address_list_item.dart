@HtmlImport('address_list_item.html')
library gcanvas.address_list_item;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:gcanvas/address.dart';

import 'dart:html';

@PolymerRegister('address-list-item')
class AddressListItemElement extends PolymerElement {
  String _visited;
  Address _address;

  @Property(notify: true, observer: 'addressChanged') Address get address => _address;
  @reflectable void set address(val) {
    _address = val;
    notifyPath('address', address);
    _setVisited();
  }

  @property String get visited => _visited;
  @reflectable void set visited(val) {
    _visited = val;
    notifyPath('visited', visited);
  }

  AddressListItemElement.created() : super.created() {
    onClick.listen((_) {
      dispatchEvent(new CustomEvent("address-item-clicked", detail: address));
    });
  }

  @Observe('address')
  addressChanged([_, __]) {
    _setVisited();
  }


  _setVisited() {
    visited = address.visited == true ? "visited" : "";
  }
}