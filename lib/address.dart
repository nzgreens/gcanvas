library gcanvas.address;

import 'package:observe/observe.dart' show reflectable;

@reflectable
class Address {
  @reflectable int id;
  @reflectable String street;
  @reflectable String suburb;
  @reflectable String city;
  @reflectable String postcode;
  @reflectable num latitude;
  @reflectable num longitude;
  @reflectable bool visited = false;


  Address(
      [this.id,
      this.street,
      this.suburb,
      this.city,
      this.postcode,
      this.latitude,
      this.longitude,
      this.visited]
  );


  Address.fromMap(Map map) {
    if(map != null) {
      id = map['id'];
      street = map['street'];
      suburb = map['suburb'];
      city = map['city'];
      postcode = map['postcode'];
      latitude = map['latitude'];
      longitude = map['longitude'];
      visited = map['visited'];
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
