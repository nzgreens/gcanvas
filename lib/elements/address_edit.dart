import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'dart:html' show Event, window;

@CustomTag('address-edit')
class AddressEditElement extends PolymerElement {
  @observable Address addr = new Address();
  @observable String latitude;
  @observable String longitude;

  bool validLatitude = false;
  bool validLongitude = false;

  AddressEditElement.created() : super.created() {
    addr.visited = false;
  }


  bool validate() {
    if(!validLatitude) {
      return false;
    }


    if(!validLongitude) {
      return false;
    }


    return addr.city.length > 0 && addr.postcode.length > 0 &&
        addr.street.length > 0 && addr.suburb.length > 0 &&
        addr.visited != null;

  }

  void submit(Event event) {
    event.preventDefault();

    if(validate()) {
      fire("address-creation-save", detail: addr);
    } else {
      window.alert("All fields must be filled in and valid values used");
    }
  }


  void cancel() {
    fire("address-creation-cancel");
  }


  latitudeChanged() {
    try {
      addr.latitude = double.parse(latitude);
      validLatitude = true;
    } on FormatException {
      validLatitude = false;
    }
  }


  longitudeChanged() {
    try {
      addr.longitude = double.parse(longitude);
      validLongitude = true;
    } on FormatException {
      validLongitude = false;
    }
  }
}