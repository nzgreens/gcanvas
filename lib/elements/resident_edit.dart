@HtmlImport('resident_edit.html')
library gcanvas.resident_edit;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:gcanvas/resident.dart';

@PolymerRegister('resident-edit')
class ResidentEditElement extends PolymerElement {
  @property Resident resident;

  ResidentEditElement.created() : super.created();
}