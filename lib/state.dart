part of gcanvas.client;


/*
 * @TODO: add GeoCoordinates and have it serialised in fromMap factory and
 * toMap method.
 */
class State extends JsProxy {

  Address _address;
  bool _addressListView = true;
  bool _addressView = false;
  User _user;

  @reflectable Address get address => _address;
  @reflectable void set address(val) {
    _address = val;
  }
  @reflectable bool get addressListView => _addressListView;
  @reflectable void set addressListView(val) {
    _addressListView = val;
  }
  @reflectable bool get addressView => _addressView;
  @reflectable void set addressView(val) {
    _addressView = val;
  }
  @reflectable User user;


  State(
      this._addressListView,
      this._addressView,
      [this._address]) {
    _address = _address != null ? _address : new Address.create();
    _addressListView = _addressListView != null ? _addressListView : true;
    _addressView = _addressView != null && !_addressListView ? _addressView : false;
  }


  factory State.create({
    addressListView,
    addressView,
    address,
    location}) {
    address = address != null ? address : new Address.create();
    addressListView = addressListView != null ? addressListView : true;
    addressView = addressView != null && !addressListView ? addressView : false;

    return new State(
        addressListView,
        addressView,
        address);
  }


  factory State.fromMap(Map map) {
    Address address = map.containsKey('address') && map['address'] != null ?
        new Address.fromMap(map['address']) : new Address.create();

    bool addressListView =
        map.containsKey('addressListView') ? map['addressListView'] : true;
    bool addressView =
        map.containsKey('addressView') &&
          !addressListView ? map['addressView'] : false;

    return new State.create(
        addressListView: addressListView,
        addressView: addressView,
        address: address
    );
  }


  Map toMap() {
    return {
      'addressListView': addressListView,
      'addressView': addressView,
      'address': address != null ? address.toMap() : new Address.create().toMap(),
    };
  }

  bool _changed = false;

  void selectAddressListView() {
    addressListView = true;
  }


  void selectAddressView(Address newAddress) {
    addressView = true;
    address = newAddress;
  }
}
