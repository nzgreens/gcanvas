import 'package:polymer/polymer.dart';
import 'package:gcanvas/response.dart';
import 'package:gcanvas/resident.dart';

import 'package:core_elements/core_selector.dart';

import 'dart:html' show Event, SelectElement, CheckboxInputElement;
import 'dart:js' as js;

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


  @published final Map<String, bool> involvementMap = toObservable({
    'Volunteer': false,
    'Host a Billboard': false
  });

  @published Resident resident = new Resident.create();

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
    //$['details-tab'].style.display = "none";
    //$['tab-selector'].selected = 0;
    //$['status-tab'].style.display = 'block';
    //$['details-tab'].style.display = 'none';
  }


  void responseSelected(Event event) {
    response = int.parse($['response'].selected);
    supportEntry = response >= 0;
  }

  void fireResponse() {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident, involvement: involvementMap);
    fire('response-submit', detail: residentResponse);
  }

  void supportSelected(Event event) {
    support = int.parse(shadowRoot.querySelector('#support').selected);
    involvementEntry = support >= 0;
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
    print("${input.id}: ${input.checked}");
  }


  selectPage(Event e) {
    var target = e.target as CoreSelector;
    selectedTab = target.selected is int ? target.selected : int.parse(target.selected);
  }
}
