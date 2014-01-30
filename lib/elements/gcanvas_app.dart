import 'package:polymer/polymer.dart';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  @observable var addresses = toObservable(["48 Bignell street, Whanganui"]);

  GCanvasApp.created() : super.created();


  @override
  void enteredView() {
    super.enteredView();
    
    $['back'].hidden = true;
  }

}