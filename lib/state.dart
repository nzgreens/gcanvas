part of gcanvas.client;


/*
 * @TODO: add GeoCoordinates and have it serialised in fromMap factory and
 * toMap method.
 */
class State extends Observable {

  @observable Address address;
  @observable bool addressListView;
  @observable bool addressView;
  @observable User user;


  State(
      this.addressListView,
      this.addressView,
      [this.address]);


  factory State.create({
    addressListView,
    addressView,
    addressSelector,
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


  void selectAddressListView() {
    addressListView = true;
    addressView = false;
  }


  void selectAddressView(Address newAddress) {
    addressListView = false;
    addressView = true;
    address = newAddress;
  }
}
