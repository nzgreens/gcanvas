part of gcanvas.client;


/*
 * @TODO: add GeoCoordinates and have it serialised in fromMap factory and
 * toMap method.
 */
class State extends Observable {

  @observable Address address;
  @observable bool addressListView;
  @observable bool addressView;
  @observable bool addressSelector;
  @observable GeoCoordinates location;


  State(
      this.addressListView,
      this.addressView,
      this.addressSelector,
      [this.address, this.location]);


  factory State.create({
    addressListView,
    addressView,
    addressSelector,
    address,
    location}) {
    address = address != null ? address : new Address.create();
    location =
        location != null ? location : new GeoCoordinates.create(-1.0, -1.0);

    addressListView = addressListView != null ? addressListView : true;
    addressView = addressView != null && !addressListView ? addressView : false;
    addressSelector =
        addressSelector != null &&
          !addressListView && !addressView ? addressSelector : false;

    return new State(
        addressListView,
        addressView,
        addressSelector,
        address,
        location);
  }


  factory State.fromMap(Map map) {
    Address address = map.containsKey('address') && map['address'] != null ?
        new Address.fromMap(map['address']) : new Address.create();

    GeoCoordinates location = map.containsKey('location') &&
        map['location'] != null ?
            new GeoCoordinates.fromMap(map['location']) :
              new GeoCoordinates.create(-1.0, -1.0);


    bool addressListView =
        map.containsKey('addressListView') ? map['addressListView'] : true;
    bool addressView =
        map.containsKey('addressView') &&
          !addressListView ? map['addressView'] : false;
    bool addressSelector =
        map.containsKey('addressSelector') &&
          !addressListView && !addressView ? map['addressSelector'] : false;

    return new State.create(
        addressListView: addressListView,
        addressView: addressView,
        addressSelector: addressSelector,
        address: address,
        location: location);
  }


  Map toMap() {
    return {
      'addressListView': addressListView,
      'addressView': addressView,
      'addressSelector': addressSelector,
      'address': address != null ? address.toMap() : new Address.create().toMap(),
      'location': location != null ? location.toMap() : new GeoCoordinates.create(-1.0, -1.0)
    };
  }


  void selectAddressSelector([GeoCoordinates coords]) {
    addressListView = false;
    addressView = false;
    addressSelector = true;
    location = coords != null ? coords : location;
  }


  void selectAddressListView() {
    addressListView = true;
    addressView = false;
    addressSelector = false;
  }


  void selectAddressView(Address newAddress) {
    addressListView = false;
    addressView = true;
    addressSelector = false;
    address = newAddress;
  }
}
