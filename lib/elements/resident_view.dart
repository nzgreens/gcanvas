@HtmlImport('resident_view.html')
library gcanvas.resident_view;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/paper_item.dart';

import 'package:gcanvas/resident.dart';

@PolymerRegister("resident-view")
class ResidentViewElement extends PolymerElement {
  @property Resident resident;

  @property String styleSelected = "5px solid green";
  @property String styleDeselected = "1px solid blue";

  bool selected = false;

  ResidentViewElement.created() : super.created();

  void attached() {
    super.attached();
    async(() {
      onClick.listen((event) {
        click();
      });

      style.border = styleDeselected;
    });
  }

  void click() {
    fire("resident-selected", detail: resident);
  }
}