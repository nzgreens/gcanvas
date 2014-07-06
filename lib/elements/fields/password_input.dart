import 'package:polymer/polymer.dart';

import 'package:paper_elements/paper_input.dart';

import 'dart:html';// show ShadowElement, InputElement;

//@PublishedProperty(reflect: true)
@CustomTag('password-input')
class PasswordInput extends PolymerElement {
  @published String label;
  @published String name;
  @observable String valueStore;
  @published String get value => $.keys.contains('shadow') ? $['shadow'].value : '';
  @published set value(val) {
      valueStore = val;
  }


  PasswordInput.created() : super.created();

  void attached() {
    super.attached();

    InputElement result = ($['shadow'] as PaperInput).shadowRoot.querySelector('shadow').getDistributedNodes().firstWhere((el) => el is InputElement);
    result.type = 'password';
  }
}