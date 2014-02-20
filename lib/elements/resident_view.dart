import 'package:polymer/polymer.dart';
import 'package:gcanvas/resident.dart';

@CustomTag("resident-view")
class ResidentViewElement extends PolymerElement {
  @published Resident resident;

  @published String styleSelected = "solid 5px green";
  @published String styleDeselected = "solid 1px blue";

  bool selected = false;

  ResidentViewElement.created() : super.created() {
    onClick.listen((event) {
      click();
    });
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