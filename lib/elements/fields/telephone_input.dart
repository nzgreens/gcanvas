@HtmlImport('telephone_input.html')
library gcanvas.telephone_input;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:browser_detect/browser_detect.dart' as detect;

import 'package:polymer_elements/paper_input.dart';

import 'dart:html';// show ShadowElement, InputElement;

@PolymerRegister('telephone-input')
class TelephoneInput extends PolymerElement {
  @property String label;
  @property String name;
  @property String valueStore;
  @property String get value => valueStore;
  @reflectable void set value(val) {
      valueStore = val;
  }

  bool valid = false;

  bool get isSafari => detect.browser.isSafari;

  TelephoneInput.created() : super.created();

  void attached() {
    super.attached();
    async(() {
      valueStore = querySelector('#shadow') != null ? (querySelector('#shadow') as PaperInput).value : '';
      InputElement result = (querySelector('#shadow') as PaperInput).inputElement;
//      .shadowRoot.querySelector('shadow').getDistributedNodes().firstWhere((el) => el is InputElement);
      result.type = 'tel';
      result.autocomplete = 'on';
    });
  }


  validate(val) {
    return valid;
  }


  fireValidEmail() {
    fire('valid-email', detail: value);
  }


  fireInvalidEmail() {
    fire('invalid-email', detail: value);
  }
}
