@HtmlImport('address_edit.html')
library gcanvas.address_edit;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'dart:html' show Event, window;

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_checkbox.dart';

@PolymerRegister('address-edit')
class AddressEditElement extends PolymerElement {
  @property Address address = new Address.create();
  @property List<Resident> residents = [];

  String _latitude;
  @property String get latitude => _latitude;
  @reflectable void set latitude(val) {
    _latitude = val;
    notifyPath('latitude', latitude);
    try {
      address.latitude = double.parse(latitude);
      validLatitude = true;
    } on FormatException {
      validLatitude = false;
    }
  }

  String _longitude;
  @property String get longitude => _longitude;
  @reflectable void set longitude(val) {
    _longitude = val;
    notifyPath('longitude', longitude);
    try {
      address.longitude = double.parse(longitude);
      validLongitude = true;
    } on FormatException {
      validLongitude = false;
    }
  }

  bool validLatitude = false;
  bool validLongitude = false;

  AddressEditElement.created() : super.created() {
    address.visited = false;
  }


  bool validate() {
    if(!validLatitude) {
      return false;
    }


    if(!validLongitude) {
      return false;
    }


    return address.city.length > 0 && address.postcode.length > 0 &&
        address.address1.length > 0 && address.address2.length > 0 &&
        address.visited != null;

  }

  void submit(Event event, [_, __]) {
    event.preventDefault();

    if(validate()) {
      fire("address-creation-save", detail: address);
    } else {
      window.alert("All fields must be filled in and valid values used");
    }
  }


  void cancel(Event event, [_, __]) {
    fire("address-creation-cancel");
  }

  @Observe('residents.*')
  void residentsChanged([_]) {
    notifyPath('residents', residents);
  }
}
