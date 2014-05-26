import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';

import 'dart:html' show Event;
import 'dart:js' show JsObject;

@CustomTag('address-view')
class AddressViewElement extends PolymerElement {
  @published Address address;
  @published String script;


  @observable String response = "";
  @observable String reason = "";

  @observable Resident selectedResident = new Resident.create();

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
    var flipbox = new JsObject.fromBrowserObject($['address-flipbox']);
    flipbox.callMethod('toggle');
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