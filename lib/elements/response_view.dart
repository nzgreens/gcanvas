import 'package:polymer/polymer.dart';
import 'package:gcanvas/response.dart';
import 'package:gcanvas/resident.dart';

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
  int response = -1;
  int support = -1;

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
    var selection = int.parse((event.target as SelectElement).value);
    if(selection >= 0) {
      supportEntry = true;
    } else {
      supportEntry = false;
    }
    response = selection;
  }

  void fireResponse() {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident, involvement: involvementMap);
    fire('response-submit', detail: residentResponse);
  }

  void supportSelected(Event event) {
    var selection = int.parse((event.target as SelectElement).value);

    if(selection >= 0) {
      involvementEntry = true;
    } else {
      involvementEntry = false;
    }

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
    shadowRoot.querySelectorAll("input").forEach((input) {
      if(input is CheckboxInputElement && involvementMap.containsKey(input.name)) {
        input.checked = false;
      }
    });
    involvementEntry = false;
    var tab_selector = new js.JsObject.fromBrowserObject($['tab-selector']);
    tab_selector['selected'] = 0;
  }


  involvementChecked(Event e) {
    CheckboxInputElement input = e.target;

    involvementMap[input.name] = input.checked;
  }


  selectPage(Event e) {
    var target = new js.JsObject.fromBrowserObject(e.target);
    int selected = target['selected'] is int ? target['selected'] : int.parse(target['selected']);
    print(selected);
    switch(selected) {
      case 0:
        $['status-tab'].style.display = 'block';
        $['details-tab'].style.display = 'none';
        break;
      case 1:
        $['status-tab'].style.display = 'none';
        $['details-tab'].style.display = 'block';
        break;
      default:
        break;
    }
  }
}
