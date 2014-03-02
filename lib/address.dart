library gcanvas.address;

import 'package:observe/observe.dart' show reflectable, Reflectable;


class Address extends Reflectable {
  @reflectable int id;
  @reflectable String street;
  @reflectable String suburb;
  @reflectable String city;
  @reflectable String postcode;
  @reflectable int meshblock;
  @reflectable int electorate;
  @reflectable num latitude;
  @reflectable num longitude;
  @reflectable bool visited = false;


  Address(
      this.id,
      this.street,
      this.suburb,
      this.city,
      this.postcode,
      this.meshblock,
      this.electorate,
      this.latitude,
      this.longitude,
      this.visited
  );



  /*
   * Factory constructor to help future proof this, and minimise refactoring
   * problems
   *
   * Allow for flexibility in what an address type is,
   * ie it can return anything, being a factory method
   */
  factory Address.create({
      int id: -1,
      String street: "",
      String suburb: "",
      String city: "",
      String postcode: "",
      int meshblock: -1,
      int electorate: -1,
      num latitude: 0,
      num longitude: 0,
      bool visited: false}) {
    return new Address(
          id,
          street,
          suburb,
          city,
          postcode,
          meshblock,
          electorate,
          latitude,
          longitude,
          visited
        );
  }


  /* For converting to an address after fetching data from the local browser
   * Store.
   *
   * It's no good having a factory create method if the fromMap isn't also a
   * factory method.  All it does is create an address using the create method
   * after extracting the fields from the map.
   */
  factory Address.fromMap(Map map) {
    if(map != null) {
      var id = map['id'];
      var street = map['street'];
      var suburb = map['suburb'];
      var city = map['city'];
      var postcode = map['postcode'];
      var meshblock = map['meshblock'];
      var electorate = map['electorate'];
      var latitude = map['latitude'];
      var longitude = map['longitude'];
      var visited = map['visited'];

      return new Address.create(
                            id: id,
                            street: street,
                            suburb: suburb,
                            city: city,
                            postcode: postcode,
                            meshblock: meshblock,
                            electorate: electorate,
                            latitude: latitude,
                            longitude: longitude,
                            visited: visited);
    }
  }


  /*
   * For use in storing the data in the browser Store.
   */
  Map toMap() {
    return {
      "id": id,
      "street": street,
      "suburb": suburb,
      "city": city,
      "postcode": postcode,
      "meshblock": meshblock,
      "electorate": electorate,
      "latitude": latitude,
      "longitude": longitude,
      "visited": visited
    };
  }
}
