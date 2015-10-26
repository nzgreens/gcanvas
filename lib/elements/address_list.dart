@HtmlImport('address_list.html')
library gcanvas.address_list;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/address.dart';

import 'package:gcanvas/elements/address_list_item.dart';

import 'dart:html' show Event, CustomEvent;

@PolymerRegister('address-list')
class AddressList extends PolymerElement {
  List<Address> _addresses = [];
  @property List<Address> get addresses => _addresses;
  @reflectable void set addresses(val) {
    _addresses = val;
    notifyPath('addresses', addresses);
  }

  AddressList.created() : super.created();

  @reflectable
  void addressClicked(CustomEvent event, [_]) {
    var customEvent = new CustomEvent('address-clicked', detail: event.detail);

    dispatchEvent(customEvent);
  }
}