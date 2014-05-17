import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'dart:html' show Event, window;

@CustomTag('address-edit')
class AddressEditElement extends PolymerElement {
  @published Address address = new Address.create();
  @observable List<Resident> residents = toObservable([]);
  @observable String latitude;
  @observable String longitude;

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

  void submit(Event event) {
    event.preventDefault();

    if(validate()) {
      fire("address-creation-save", detail: address);
    } else {
      window.alert("All fields must be filled in and valid values used");
    }
  }


  void cancel() {
    fire("address-creation-cancel");
  }


  latitudeChanged() {
    try {
      address.latitude = double.parse(latitude);
      validLatitude = true;
    } on FormatException {
      validLatitude = false;
    }
  }


  longitudeChanged() {
    try {
      address.longitude = double.parse(longitude);
      validLongitude = true;
    } on FormatException {
      validLongitude = false;
    }
  }
}