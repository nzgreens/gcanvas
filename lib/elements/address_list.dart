import 'package:polymer/polymer.dart';

@CustomTag("address-list")
class AddressList extends PolymerElement {
  @published var addresses;

  AddressList.created() : super.created();
}