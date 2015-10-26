@HtmlImport('address_edit.html')
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
  @property Address address;

  String _response = "";
  @property String get response => _response;
  @reflectable void set response(val) {
    _response = val;
    notifyPath('response', response);
  }

  String _reason = "";
  @property String get reason => _reason;
  @reflectable void set reason(val) {
    _reason = val;
    notifyPath('reason', reason);
  }

  @property Resident selectedResident = new Resident.create();


  bool _showAddress = true;
  @Property(notify: true) bool get showAddress => _showAddress;
  @reflectable void set showAddress(val) {
    _showAddress = val;
    print('showAddress: $showAddress');
    notifyPath('showAddress', showAddress);
  }

  AddressViewElement.created() : super.created();

  @reflectable
  void residentSelected(Event event, var detail) {
    selectedResident = detail;
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

    toggleFlip();
  }


  @reflectable
  responseCanceled(e, [_]) {
    toggleFlip();
  }


  @reflectable
  showResident(e, [_]) {
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
