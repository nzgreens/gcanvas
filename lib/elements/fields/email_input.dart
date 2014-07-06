import 'package:polymer/polymer.dart';

import 'package:browser_detect/browser_detect.dart' as detect;

import 'package:paper_elements/paper_input.dart';

import 'dart:html';// show ShadowElement, InputElement;

@CustomTag('email-input')
class EmailInput extends PolymerElement {
  @published String label;
  @published String name;
  @observable String valueStore;
  @published String get value => $.keys.contains('shadow') ? $['shadow'].value : '';
  @published set value(val) {
      valueStore = val;
  }

  bool valid = false;

  bool get isSafari => detect.browser.isSafari;

  EmailInput.created() : super.created();

  void attached() {
    super.attached();

    InputElement result = ($['shadow'] as PaperInput).shadowRoot.querySelector('shadow').getDistributedNodes().firstWhere((el) => el is InputElement);
    result.type = 'email';
    result.autocomplete = 'on';

    result.onBlur.listen((e) {
      var validator = new EmailValidation(value);
      if(validator.valid()) {
        print('valid');
        ($['shadow'] as PaperInput).invalid = false;
        fireValidEmail();
      } else {
        print('invalid');
        ($['shadow'] as PaperInput).invalid = true;
        fireInvalidEmail();
      }
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


class EmailValidation {
  String email;
  String domain = "";
  String local = "";

  EmailValidation(this.email) {
    if(_hasLocalAndDomainParts()) {
      _splitLocalAndDomain();
    }
  }


  bool valid() =>
      _hasLocalAndDomainParts() &&
      _localLengthCheck() &&
      _domainLengthCheck() &&
      _validLocalPartContent() &&
      _validLocalDotPlacement() &&
      _validDomainPartContent();


  _splitLocalAndDomain() {
    int pos = email.indexOf('@');
    domain = email.substring(pos+1);
    local = email.substring(0, pos);
  }


  bool _hasLocalAndDomainParts() {
    return email.contains('@');
  }


  bool _localLengthCheck() {
    int localLen = local.length;

    return localLen > 0 && localLen <= 64;
  }


  bool _domainLengthCheck() {
    int domainLen = domain.length;

    return domainLen > 0 && domainLen <= 255;
  }


  bool _validLocalPartContent() {
    var reg1 = new RegExp("/^(\\\\.|[A-Za-z0-9!#%&`_=\\/\$\'*+?^{}|~.-])+\$/");
    var reg2 = new RegExp('/^"(\\\\"|[^"])+"\$/');

    return !(local.replaceAll("\\\\","").contains(reg1) && local.replaceAll("\\\\","").contains(reg2));
  }


  bool _validLocalDotPlacement() {
    return local[0] != '.' && local[local.length-1] != '.' && !local.contains('..');
  }


  bool _validDomainPartContent() {
    var reg1 = new RegExp('/^[A-Za-z0-9\\-\\.]+\$/');
    var reg2 = new RegExp('/\\.\\./');

    return !(domain.contains(reg1) && domain.contains(reg2));
  }
}