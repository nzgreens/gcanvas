import 'package:polymer/polymer.dart';

@CustomTag("gcanvas-app")
class GCanvasApp extends PolymerElement {
  GCanvasApp.created() : super.created() {

  }


  @override
  void enteredView() {
    super.enteredView();
    
    $['back'].hidden = true;
  }

}