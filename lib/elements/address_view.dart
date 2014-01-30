import 'package:polymer/polymer.dart';

@CustomTag('address-view')
class AddressView extends PolymerElement {
  @published var address;
  AddressView.created() : super.created();
}