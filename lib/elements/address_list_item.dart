import 'package:polymer/polymer.dart';
import 'package:gcanvas/address.dart';

@CustomTag('address-list-item')
class AddressListItemElement extends PolymerElement {
  @published Address address;
  AddressListItemElement.created() : super.created() {
    onClick.listen((_) {
      print ("address clicked");
      fire("address-item-clicked", detail: address);
    });
  }
}