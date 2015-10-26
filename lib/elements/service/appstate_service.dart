@HtmlImport('appstate_service.html')
library gcanvas.appstate_service;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/gcanvas.dart';

//import 'package:polymer_elements/paper_toast.dart';

@PolymerRegister("appstate-service")
class AppStateService extends PolymerElement {
  @Property(notify: true, reflectToAttribute: true) AppStateCtrl appStateCtrl = new AppStateCtrl.create();

  AppStateService.created() : super.created();


  Future<State> get([_, __]) {
    return appStateCtrl.get();
  }


  Future<bool> save(State state) {
    return appStateCtrl.save(state);
  }
}