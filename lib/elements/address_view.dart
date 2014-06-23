import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';

import 'dart:html' show Event;

@CustomTag('address-view')
class AddressViewElement extends PolymerElement {
  @published Address address;

  @observable String response = "";
  @observable String reason = "";

  @observable Resident selectedResident = new Resident.create();


  @observable bool showAddress = true;

  AddressViewElement.created() : super.created();


  void residentSelected(Event event, var detail) {
    selectedResident = detail;
    toggleFlip();
  }


  void residentDeselected(Event event, var detail) {
  }


  submitResponse(e) {
    toggleFlip();
  }


  responseCanceled(e) {
    toggleFlip();
  }


  showResident(e) {
    toggleFlip();
  }

  toggleFlip([e]) {
    print('address flip');

    if(showAddress) {
      showAddress = false;
    } else {
      showAddress = true;
    }

    if(e != null) {
      e.preventDefault();
    }
  }


  emitDone(Event e) {
    fire('address-done');
    e.preventDefault();
  }


  emitNextAddress(Event e) {
    fire('address-next');
    e.preventDefault();
  }
}