import 'package:polymer/polymer.dart';
import 'package:gcanvas/resident.dart';

@CustomTag('resident-edit')
class ResidentEditElement extends PolymerElement {
  @published Resident resident;

  ResidentEditElement.created() : super.created();
}