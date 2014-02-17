part of gcanvas.client;


class State {
  final Address address;
  final bool addressListView;
  final bool addressView;

  const State(this.addressListView, this.addressView, [this.address = null]);


  factory State.fromMap(Map map) {
    Address address = map['address'] != null ? new Address.fromMap(map['address']) : null;

    return new State(map['addressListView'], map['addressView'], address);
  }


  Map toMap() {
    return {
      'addressListView': addressListView,
      'addressView': addressView,
      'address': address.toMap()
    };
  }
}