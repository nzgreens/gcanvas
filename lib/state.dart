part of gcanvas.client;


class State extends Observable {

  @observable Address address;
  @observable bool addressListView;
  @observable bool addressView;
  @observable bool addressSelector;



  State(this.addressListView, this.addressView, this.addressSelector, [this.address = null]);


  factory State.create({addressListView, addressView, addressSelector, address}) {
    addressSelector = addressSelector != null ? addressSelector : true;
    addressListView = addressListView != null && !addressSelector ? addressListView : false;
    addressView = addressView != null && !addressListView ? addressView : false;
    address = address != null ? address : new Address.create();

    return new State(addressListView, addressView, addressSelector, address);
  }


  factory State.fromMap(Map map) {
    Address address = map.containsKey('address') && map['address'] != null ? new Address.fromMap(map['address']) : new Address.create();
    
    bool addressSelector = map.containsKey('addressSelector') ? map['addressSelector'] : true;
    bool addressListView = map.containsKey('addressListView') && !addressSelector ? map['addressListView'] : false;
    bool addressView = map.containsKey('addressView') && !addressListView ? map['addressView'] : false;

    return new State.create(
        addressListView: addressListView,
        addressView: addressView,
        addressSelector: addressSelector,
        address: address != null ? address : new Address.create());
  }


  Map toMap() {
    return {
      'addressListView': addressListView,
      'addressView': addressView,
      'addressSelector': addressSelector,
      'address': address != null ? address.toMap() : new Address.create().toMap()
    };
  }
}
