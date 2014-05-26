import 'package:polymer/polymer.dart';
import 'package:gcanvas/response.dart';
import 'package:gcanvas/resident.dart';

import 'dart:html' show Event, SelectElement;

@CustomTag('response-view')
class ResponseViewElement extends PolymerElement {
  @published final Map<int, String> responseMap = toObservable({
    1:'Answered',
    2:'Bad Information',
    9:'Inaccessible',
    6:'Not Interested',
    7:'No Answer',
    0:'Other'
  });
//    3:'Left Message',
//    4:'Meaningful Interaction',
//    8:'Refused',
//    5:'Send Information',

  @published final Map<int, String> supportLevelMap = toObservable({
    1:'Strong support',
    2:'Weak support',
    3:'Undecided',
    4:'Weak oppose',
    5:'Strong oppose'
  });


  @published final Map<int, String> involvementMap = toObservable({
    0: 'Volunteer',
    1: 'Host a Billboard'
  });

  @published Resident resident = new Resident.create();

  @observable bool supportEntry = false;

  int response = -1;
  int support = -1;

  String responseSelection = "No Answer";


  ResponseViewElement.created() : super.created() {
    //fireResponse(responseMap[0]);
    /*var reason = ($[responseList[0].toLowerCase().replaceAll(" ", "")] as SelectElement).value;
    fireReason(reason);*/
  }


  void enteredView() {
    super.enteredView();

    //fireResponse(responseMap[0]);
  }


  void responseSelected(Event event) {
    var selection = int.parse((event.target as SelectElement).value);
    if(selection >= 0) {
      supportEntry = true;
    } else {
      supportEntry = false;
    }
    response = selection;
  }

  void fireResponse() {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident);
    fire('response-submit', detail: residentResponse);
  }

  void supportSelected(Event event) {
    var selection = int.parse((event.target as SelectElement).value);

    support = selection;
  }



  fireCanceled() {
    fire('response-canceled');
  }


  submit([e]) {
    fireResponse();
    reset();
  }


  cancel([e]) {
    fireCanceled();
    reset();
  }


  reset() {
    SelectElement response = shadowRoot.querySelector("#response");
    response.value = "-1";
    SelectElement support = shadowRoot.querySelector("#support");
    if(support != null) {
      support.value = "-1";
    }
    supportEntry = false;
  }
}
