import 'package:polymer/polymer.dart';
import 'package:gcanvas/resident.dart';

@CustomTag("resident-view")
class ResidentViewElement extends PolymerElement {
  @published Resident resident;

  @published String styleSelected = "5px solid green";
  @published String styleDeselected = "1px solid blue";

  bool selected = false;

  ResidentViewElement.created() : super.created();

  void enteredView() {
    super.enteredView();

    onClick.listen((event) {
      click();
    });

    style.border = styleDeselected;
  }

  void click() {
    fire("resident-selected", detail: resident);
  }
}