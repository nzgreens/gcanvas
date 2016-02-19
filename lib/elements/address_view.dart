@HtmlImport('address_view.html')
library gcanvas.address_view;

import 'dart:html' show Event;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_button.dart';

import 'package:gcanvas/elements/resident_view.dart';
import 'package:gcanvas/elements/response_view.dart';

import 'package:gcanvas/address.dart';
import 'package:gcanvas/resident.dart';
import 'package:gcanvas/response.dart';



@PolymerRegister('address-view')
class AddressViewElement extends PolymerElement {
  Address _address;
  @Property(notify: true, reflectToAttribute: true) Address get address => _address;
  @reflectable void set address(val) {
    _address = val;
    print('address: ${address}');
    notifyPath('address', address);
  }

  String _response = "";
  @Property(notify: true, reflectToAttribute: true) String get response => _response;
  @reflectable void set response(val) {
    _response = val;
    notifyPath('response', response);
  }

  String _reason = "";
  @Property(notify: true, reflectToAttribute: true) String get reason => _reason;
  @reflectable void set reason(val) {
    _reason = val;
    notifyPath('reason', reason);
  }

  @Property(notify: true, reflectToAttribute: true) Resident selectedResident = new Resident.create();


  bool _showAddress = true;
  @Property(notify: true, reflectToAttribute: true) bool get showAddress => _showAddress;
  @reflectable void set showAddress(val) {
    _showAddress = val;
    notifyPath('showAddress', showAddress);
  }

  AddressViewElement.created() : super.created();

  @reflectable
  void residentSelected(Event event, var detail) {
    set('selectedResident', detail);
    print('resident selected');
    toggleFlip();
  }


  @reflectable
  void residentDeselected(Event event, var detail) {
  }


  @reflectable
  submitResponse(e, [_]) {

    address.visited = true;
    var response = (e.detail as ResidentResponse);
    Resident resident = address.residents.firstWhere((resident) => resident.id == response.id);

    set('selectedResident', resident);

    print('response submited');

    toggleFlip();
  }


  @reflectable
  responseCanceled(e, [_]) {
    toggleFlip();
  }


  @reflectable
  showResident(e, [_]) {
    print('showResident');
    toggleFlip();
  }

  @reflectable
  toggleFlip([e, _]) {
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


  @reflectable
  emitPrevAddress(Event e, [_]) {
    fire('address-prev');
    e.preventDefault();
  }


  @reflectable
  emitNextAddress(Event e, [_]) {
    fire('address-next');
    e.preventDefault();
  }
}
