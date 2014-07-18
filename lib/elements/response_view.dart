import 'dart:mirrors';

import 'package:polymer/polymer.dart';
import 'package:gcanvas/response.dart';
import 'package:gcanvas/resident.dart';

import 'package:core_elements/core_selector.dart';

import 'dart:html' show Event, SelectElement, CheckboxInputElement;

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

  @published final Map<int, String> supportLevelMap = toObservable({
    1:'Strong support',
    2:'Weak support',
    3:'Undecided',
    4:'Weak oppose',
    5:'Strong oppose'
  });


  @published final Map<String, bool> involvementMap = toObservable({
    'Volunteer': false,
    'Host a Billboard': false
  });

  @PublishedProperty(reflect: true) Resident resident = new Resident.create();

  @observable bool supportEntry = false;
  @observable bool involvementEntry = false;
  @observable int selectedTab = 0;
  int response = -1;
  int support = -1;

  final int RESPONSE = 0;
  final int SUPPORT = 1;
  final int INVOLVEMENT = 2;
  final int DETAILS = 3;

  String responseSelection = "No Answer";


  ResponseViewElement.created() : super.created();


  void attached() {
    super.attached();
    var instanceMirror = reflect(resident);
    involvementMap.keys.forEach((key) {
      //keys are just the attribute in a human readable for with spaces and capatals
      //lowercase and replace spaces with underscores
      var attrName = key.toLowerCase().replaceAll(' ', '_');
      var objMirror = instanceMirror.getField(new Symbol(attrName));
      var attrVal = objMirror.reflectee == null ? false : objMirror.reflectee;
      print("Name ($attrName): $attrVal");
      involvementMap[key] = attrVal;
    });
  }


  void responseSelected(Event event) {
    resident.response = int.parse(shadowRoot.querySelector('#response').selected);
    supportEntry = resident.response >= 0;
  }

  void fireResponse() {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident, involvement: involvementMap);
    fire('response-submit', detail: residentResponse);
  }

  void supportSelected(Event event) {
    resident.support = int.parse(shadowRoot.querySelector('#support').selected);
    involvementEntry = resident.support >= 0;
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
    var response = shadowRoot.querySelector("#response");
    if(response != null) {
      response.selected = "-1";
    }
    var support = shadowRoot.querySelector("#support");
    if(support != null) {
      support.selected = "-1";
    }
    supportEntry = false;
    shadowRoot.querySelectorAll("input").forEach((input) {
      if(input is CheckboxInputElement && involvementMap.containsKey(input.name)) {
        input.checked = false;
      }
    });
    involvementEntry = false;
    $['tab-selector'].selected = 0;
  }


  involvementChecked(Event e) {
    //CheckboxInputElement
    var input = e.target;

    involvementMap[input.id] = input.checked;
    var instanceMirror = reflect(resident);
    var attrName = input.id.toLowerCase().replaceAll(' ', '_');
    instanceMirror.setField(new Symbol(attrName), involvementMap[input.id]);
  }


  selectPage(Event e) {
    var target = e.target as CoreSelector;
    selectedTab = target.selected is int ? target.selected : int.parse(target.selected);
  }


  residentDetailChanged(e) {
    var input = e.target;
    var instanceMirror = reflect(resident);
    var attrName = input.id.toLowerCase().replaceAll(' ', '_');
    instanceMirror.setField(new Symbol(attrName), input.value);
  }
}
