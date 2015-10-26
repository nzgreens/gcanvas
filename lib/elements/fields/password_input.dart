@HtmlImport('password_input.html')
library gcanvas.password_input;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_input.dart';

import 'dart:html';// show ShadowElement, InputElement;

//@PublishedProperty(reflect: true)
@PolymerRegister('password-input')
class PasswordInput extends PolymerElement {
  @property String label;
  @property String name;
  @property String valueStore;
  @property String get value => $.keys.contains('shadow') ? $['shadow'].value : '';
  @reflectable void set value(val) {
      valueStore = val;
  }


  PasswordInput.created() : super.created();

  void attached() {
    super.attached();

    async(() {
      InputElement result = ($['shadow'] as PaperInput).inputElement;
//      .shadowRoot.querySelector('shadow').getDistributedNodes().firstWhere((el) => el is InputElement);
      result.type = 'password';
    });
  }
}