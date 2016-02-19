@HtmlImport('response_view.html')
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

  @property Iterable get responseMapKeys => responseMap.keys;
  @reflectable String responseMapValue(key) => responseMap[key];

  @property final Map<int, String> supportLevelMap = {
    1:'Strong support',
    2:'Weak support',
    3:'Undecided',
    4:'Weak oppose',
    5:'Strong oppose'
  };

  @property Iterable get supportLevelMapKeys => supportLevelMap.keys;
  @reflectable String supportLevelMapValue(key) => supportLevelMap[key];

  @property final Map<String, bool> involvementMap = {
    'Volunteer': false,
    'Host a Billboard': false
  };

  @property Iterable get involvementMapKeys => involvementMap.keys;
  @reflectable bool involvementMapValue(key) => involvementMap[key];

  @Property(notify: true, observer: 'residentChanged') Resident resident;// = new Resident.create();

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

  @Property(computed: 'hasSelectedResponse(selectedTab)') bool responseSelected;
  @reflectable bool hasSelectedResponse(selected) => selected == RESPONSE;

  @Property(computed: 'hasSelectedSupport(selectedTab)') bool supportSelected;
  @reflectable bool hasSelectedSupport(selected) => selected == SUPPORT;

  @Property(computed: 'hasSelectedInvolvement(selectedTab)') bool involvementSelected;
  @reflectable bool hasSelectedInvolvement(selected) => selected == INVOLVEMENT;

  @Property(computed: 'hasSelectedDetails(selectedTab)') bool detailsSelected;
  @reflectable bool hasSelectedDetails(selected) => selected == DETAILS;

  String responseSelection = "No Answer";


  ResponseViewElement.created() : super.created();

  @reflectable
  void residentChanged([_, __]) {
    print('resident changed');
    Map residentMap = resident.toMap();
    involvementMap.keys.forEach((key) {
      //keys are just the attribute in a human readable for with spaces and capatals
      //lowercase and replace spaces with underscores
      var attrName = key.toLowerCase().replaceAll(' ', '_');
      involvementMap[key] = residentMap[key];
      set('involvementMap.${key}', residentMap[key]);
    });
  }


  //@TODO Marker for checking later on.  See below
  @reflectable
  void responseSelect(Event event, [_]) {
    var selected = (event.target as PaperRadioButton).name;
    // selected seems to be a int, even though officially it should be a String
    // Using int.parse on another int causes an exception, but can't trust selected
    // to be an int.  Best I can come up with is to use toString, which is not
    // satisfactory, but at least it will work for most situations, no matter what.
    // int.parse uses the isEmpty on the string to be parsed, which explains the error
    // that is being thrown.
    resident.response = int.parse(selected.toString(), onError: (_) => -1);
    supportEntry = resident.response >= 0;
  }

  @reflectable
  void fireResponse([_, __]) {
    ResidentResponse residentResponse = new ResidentResponse.create(id: resident.id, response: response, support: support, resident: resident, involvement: involvementMap);
    fire('response-submit', detail: residentResponse);
  }

  @reflectable
  void supportSelect(Event event, [_]) {
    var selected = (event.target as PaperRadioButton).name;
    resident.support = int.parse(selected.toString(), onError: (_) => -1);
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

  @reflectable
  cancel([_, __]) {
    fireCanceled();
    reset();
  }


  @reflectable
  reset([_, __]) {
    var response = new PolymerDom(this.root).querySelector("#response");
    if(response != null) {
      response.selected = "-1";
    }
    var support = querySelector("#support");
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
  void selectPage(Event e, [_]) {
    var target = e.target as PaperTabs;
//    selectedTab = target.selected is int ? target.selected : int.parse(target.selected);
    set('selectedTab', target.selected is int ? target.selected : int.parse(target.selected));
    print('selectedTab: ${selectedTab}');
  }


  @reflectable
  residentDetailChanged(e, [_]) {
    var input = e.target;
    var attrName = input.id.toLowerCase().replaceAll(' ', '_');
    resident.setField(attrName, input.value);
  }
}
