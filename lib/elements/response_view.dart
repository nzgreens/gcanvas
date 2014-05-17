import 'package:polymer/polymer.dart';

import 'dart:html' show Event, SelectElement;

@CustomTag('response-view')
class ResponseViewElement extends PolymerElement {
  @published final List<String> responseList = toObservable(['No Answer',
                                                              'Bad Information',
                                                              'Inaccessible',
                                                              'Left Message',
                                                              'Meaningful Interaction',
                                                              'Not Interested',
                                                              'Refused',
                                                              'Answered',
                                                              'Send Information'
                                                              ]);
  @observable final List<String> answeredReason = toObservable(['Not Home',
                                                                 'Busy',
                                                                 'Interested',
                                                                 'Call Again']);
  @observable final List<String> refusedReason = toObservable(['Abusive',
                                                                'Shuts Door',
                                                                'Polite']);
  //bad info
  @observable final List<String> badInfoReason = toObservable(['No Voters',
                                                                 'Wrong House',
                                                                 'Deceased',
                                                                 'Moved']);

  @observable final List<String> noAnswerReason = toObservable(['No Answer']);

  @observable final List<String> notInterestedReason = toObservable(['Note Reason',
                                                                       'LOTE']);

  @observable final Map<String, bool> selectionMap = toObservable({'No Answer': false,
                                                              'Bad Information': false,
                                                              'Not Interested': false,
                                                              'Refused': false,
                                                              'Answered': false});

  String responseSelection = "No Answer";

  ResponseViewElement.created() : super.created() {
    fireResponse(responseList[0]);
    /*var reason = ($[responseList[0].toLowerCase().replaceAll(" ", "")] as SelectElement).value;
    fireReason(reason);*/
    changes.listen((data) {
      print(data);
    });
  }


  void enteredView() {
    super.enteredView();

    fireResponse(responseList[0]);
    fireReason(noAnswerReason[0]);
  }


  void responseSelected(Event event) {
    var selection = (event.target as SelectElement).value;
    selectionMap[responseSelection] = false;
    responseSelection = selection;
    selectionMap[responseSelection] = true;
    fireResponse(selection);
  }

  void fireResponse(var selection) {
    fire('response-selected', detail: selection);
  }

  void reasonSelected(Event event) {
    var selection = (event.target as SelectElement).value;

    fireReason(selection);
  }


  void fireReason(var selection) {
    fire('reason-selected', detail: selection);
  }
}
