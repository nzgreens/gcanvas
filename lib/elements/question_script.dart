import 'package:polymer/polymer.dart';
import 'dart:html' show Event, FormElement, FormData;

@CustomTag('question-script')
class QuestionScriptElement extends PolymerElement {
  @published String script;
  Map<String, String> keyVals = new Map<String, String>();


  QuestionScriptElement.created() : super.created();

  void scriptChanged() {
    //key should be form item name and the val is the element(s)
      $['script'].appendHtml(script);
  }


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

  void cancel(Event event) {
    fire("cancel");
  }
}