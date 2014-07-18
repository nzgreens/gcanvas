import 'dart:async';

import 'package:polymer/polymer.dart';

import 'package:gcanvas/gcanvas.dart';

@CustomTag("appstate-service")
class AppStateService extends PolymerElement {
  @published AppStateCtrl appStateCtrl = new AppStateCtrl.create();

  AppStateService.created() : super.created();


  Future<State> get() {
    return appStateCtrl.get();
  }


  Future<bool> save(State state) {
    return appStateCtrl.save(state);
  }
}