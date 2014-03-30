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
    if(!selected) {
      fire("resident-selected", detail: resident);
      //$['icon'].style.border = "solid 5px green";
      style.border = styleSelected;
      selected = true;
    } else {
      fire("resident-deselected", detail: resident);
      //$['icon'].style.border = "solid 1px blue";
      style.border = styleDeselected;
      selected = false;
    }
  }
}