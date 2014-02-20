library gcanvas.address;

import 'package:observe/observe.dart' show reflectable, Reflectable;

class Address extends Reflectable {
  @reflectable int id;
  @reflectable String street;
  @reflectable String suburb;
  @reflectable String city;
  @reflectable String postcode;
  @reflectable num latitude;
  @reflectable num longitude;
  @reflectable bool visited = false;


  Address(
      this.id,
      this.street,
      this.suburb,
      this.city,
      this.postcode,
      this.latitude,
      this.longitude,
      this.visited
  );


  /* allow for flexibility in what an address type is,
   * ie it can return anything, being a factory method
   */
  factory Address.create({
      int id: -1,
      String street: "",
      String suburb: "",
      String city: "",
      String postcode: "",
      num latitude: 0,
      num longitude: 0,
      bool visited: false}) {
    return new Address(
          id,
          street,
          suburb,
          city,
          postcode,
          latitude,
          longitude,
          visited
        );
  }


  factory Address.fromMap(Map map) {
    if(map != null) {
      var id = map['id'];
      var street = map['street'];
      var suburb = map['suburb'];
      var city = map['city'];
      var postcode = map['postcode'];
      var latitude = map['latitude'];
      var longitude = map['longitude'];
      var visited = map['visited'];

      return new Address.create(
                            id: id,
                            street: street,
                            suburb: suburb,
                            city: city,
                            postcode: postcode,
                            latitude: latitude,
                            longitude: longitude,
                            visited: visited);
    }
  }


  Map toMap() {
    return {
      "id": id,
      "street": street,
      "suburb": suburb,
      "city": city,
      "postcode": postcode,
      "latitude": latitude,
      "longitude": longitude,
      "visited": visited
    };
  }
}
