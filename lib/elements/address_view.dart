import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';

import 'dart:html' show Event;

@CustomTag('address-view')
class AddressViewElement extends PolymerElement {
  @published Address address;
  @published List<Resident> residents;
  @published String script;

  @observable bool showAddress = true;
  @observable bool showScript = false;

  @observable List<Resident> presentResidentsList = toObservable([]);
  @observable String response = "";
  @observable String reason = "";

  AddressViewElement.created() : super.created();


  void reasonSelected(Event event) {

  }

  void residentSelected(Event event, var detail) {
    presentResidentsList.add(detail);
  }


  void residentDeselected(Event event, var detail) {
    presentResidentsList.remove(detail);
  }


  void responseEvent(Event event, var detail) {
    response = detail;
  }


  void reasonEvent(Event event, var detail) {
    reason = detail;
  }

  void saveScriptResults(Event event, var detail) {

  }


  void cancelScriptResults(Event event, var detail) {

  }


  void askQuestions() {
    showScript = true;
    showAddress = false;
  }
}