@HtmlImport('question_script.html')
library gcanvas.question_script;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'dart:html' show Event, FormElement, FormData;

import 'package:polymer_elements/paper_button.dart';

@PolymerRegister('question-script')
class QuestionScriptElement extends PolymerElement {
  @Property(notify: true, observer: 'scriptChanged') String script;
  Map<String, String> keyVals = new Map<String, String>();


  QuestionScriptElement.created() : super.created();

  @reflectable
  void scriptChanged([_, __]) {
    //key should be form item name and the val is the element(s)
      $['script'].appendHtml(script);
  }


  @reflectable
  void submit(Event event, var detail) {
    event.preventDefault();
    FormElement form = event.target;

    Map<String, String> results = new Map<String, String>();

    form.querySelectorAll("*").forEach((el) {
      try {
        String val = (el.type == "checkbox" || el.type == "radio" ? (el.checked ? el.value : '') : el.value);
        if(val.length > 0) {
          results[el.name] = el.value;
        }
      } catch(all) {
        //
      }
    });

    fire("save", detail: results);
  }

  @reflectable
  void cancel(Event event) {
    fire("cancel");
  }
}