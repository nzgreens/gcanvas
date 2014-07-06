import 'package:polymer/polymer.dart';

import 'package:browser_detect/browser_detect.dart' as detect;

import 'package:paper_elements/paper_input.dart';

import 'dart:html';// show ShadowElement, InputElement;

@CustomTag('telephone-input')
class TelephoneInput extends PolymerElement {
  @published String label;
  @published String name;
  @observable String valueStore;
  @published String get value => $.keys.contains('shadow') ? $['shadow'].value : '';
  @published set value(val) {
      valueStore = val;
  }

  bool valid = false;

  bool get isSafari => detect.browser.isSafari;

  TelephoneInput.created() : super.created();

  void attached() {
    super.attached();

    InputElement result = ($['shadow'] as PaperInput).shadowRoot.querySelector('shadow').getDistributedNodes().firstWhere((el) => el is InputElement);
    result.type = 'tel';
    result.autocomplete = 'on';
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
