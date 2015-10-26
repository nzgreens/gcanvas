@HtmlImport('resident_view.html')
library gcanvas.response_view;
//import 'dart:mirrors';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:gcanvas/response.dart';
import 'package:gcanvas/resident.dart';

import 'package:polymer_elements/iron_selector.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_toggle_button.dart';
import 'package:polymer_elements/paper_radio_group.dart';
import 'package:polymer_elements/paper_radio_button.dart';

import 'package:gcanvas/elements/fields/email_input.dart';
import 'package:gcanvas/elements/fields/telephone_input.dart';

import 'dart:html' show Event, SelectElement, CheckboxInputElement;

@PolymerRegister('response-view')
class ResponseViewElement extends PolymerElement {
  @property final Map<int, String> responseMap = {
    1:'Answered',
    2:'Bad Information',
    9:'Inaccessible',
    6:'Not Interested',
    7:'No Answer',
    0:'Other'
  };

  @property final Map<int, String> supportLevelMap = {
    1:'Strong support',
    2:'Weak support',
    3:'Undecided',
    4:'Weak oppose',
    5:'Strong oppose'
  };


  @property final Map<String, bool> involvementMap = {
    'Volunteer': false,
    'Host a Billboard': false
  };

  @Property(notify: true) Resident resident = new Resident.create();

  bool _supportEntry = false;
  @property bool get supportEntry => _supportEntry;
  @reflectable void set supportEntry(val) {
    _supportEntry = val;
    notifyPath('supportEntry', supportEntry);
  }

  bool _involvementEntry = false;
  @property bool get involvementEntry => _involvementEntry;
  @reflectable void set involvementEntry(val) {
    _involvementEntry = val;
    notifyPath('involvementEntry', involvementEntry);
  }

  int _selectedTab = 0;
  @property int get selectedTab => _selectedTab;
  @reflectable void set selectedTab(val) {
    _selectedTab = val;
    notifyPath('selectedTab', selectedTab);
  }

  int response = -1;
  int support = -1;

  final int RESPONSE = 0;
  final int SUPPORT = 1;
  final int INVOLVEMENT = 2;
  final int DETAILS = 3;

  @Property(computed: 'hasSelectedResponse()') bool resposeSelected;
  @reflectable bool hasSelectedResponse() => selectedTab == RESPONSE;

  @Property(computed: 'hasSelectedSupport()') bool supportSelected;
  @reflectable bool hasSelectedSupport() => selectedTab == SUPPORT;

  @Property(computed: 'hasSelectedInvolvement()') bool involvementSelected;
  @reflectable bool hasSelectedInvolvement() => selectedTab == INVOLVEMENT;

  @Property(computed: 'hasSelectedDetails()') bool detailsSelected;
  @reflectable bool hasSelectedDetails() => selectedTab == DETAILS;

  String responseSelection = "No Answer";


  ResponseViewElement.created() : super.created();


  void attached() {
    super.attached();
    Map residentMap = resident.toMap();
    involvementMap.keys.forEach((key) {
      //keys are just the attribute in a human readable for with spaces and capatals
      //lowercase and replace spaces with underscores
      var attrName = key.toLowerCase().replaceAll(' ', '_');
      involvementMap[key] = residentMap[key];
    });
  }


  @reflectable
  void responseSelect(Event event, [_]) {
    resident.response = int.parse(shadowRoot.querySelector('#response').selected);
    supportEntry = resident.response >= 0;
  }

  @reflectable
  void fireResponse([_, __]) {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident, involvement: involvementMap);
    fire('response-submit', detail: residentResponse);
  }

  @reflectable
  void supportSelect(Event event, [_]) {
    resident.support = int.parse(shadowRoot.querySelector('#support').selected);
    involvementEntry = resident.support >= 0;
  }



  @reflectable
  fireCanceled([_, __]) {
    fire('response-canceled');
  }


  @reflectable
  submit([_, __]) {
    fireResponse();
    reset();
  }


  cancel([_, __]) {
    fireCanceled();
    reset();
  }


  @reflectable
  reset(_, __) {
    var response = new PolymerDom(this.root).querySelector("#response");
    if(response != null) {
      response.selected = "-1";
    }
    var support = shadowRoot.querySelector("#support");
    if(support != null) {
      support.selected = "-1";
    }
    supportEntry = false;
    new PolymerDom(this.root).querySelectorAll("input").forEach((input) {
      if(input is CheckboxInputElement && involvementMap.containsKey(input.name)) {
        input.checked = false;
      }
    });
    involvementEntry = false;
    $['tab-selector'].selected = 0;
  }


  @reflectable
  involvementChecked(Event e, [_]) {
    //CheckboxInputElement
    var input = e.target;

    involvementMap[input.id] = input.checked;
    var attrName = input.id.toLowerCase().replaceAll(' ', '_');

    resident.setField(attrName, involvementMap[input.id]);
  }


  @reflectable
  selectPage(Event e, [_]) {
    var target = e.target as IronSelector;
    selectedTab = target.selected is int ? target.selected : int.parse(target.selected);
  }


  @reflectable
  residentDetailChanged(e, [_]) {
    var input = e.target;
    var attrName = input.id.toLowerCase().replaceAll(' ', '_');
    resident.setField(attrName, input.value);
  }
}
