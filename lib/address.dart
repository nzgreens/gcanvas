part of gcanvas;

@NgDirective(
  selector: '[addresses]',
  publishAs: 'addreses'
)
class AddressCtrl {
  StoreCtrl _addressStore;
  Http _http;
  bool _isOnline = false;

  AddressCtrl(this._addressStore, this._http) {
    window.onOnline.listen((data) {
      _isOnline = true;
      sync();
    });

    window.onOffline.listen((_) {
      _isOnline = false;
    });
  }


  void add(Address addr) {

  }


  void remove(Address addr) {

  }


  List<Address> getList() {

  }


  void sync() {

  }
}



class Address {
  int id;
  String street;
  String suburb;
  String city;
  String postcode;
  num latitude;
  num longitude;

  Address(
      this.id,
      this.street,
      this.suburb,
      this.city,
      this.postcode,
      this.latitude,
      this.longitude
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
      "longitude": longitude
    };
  }
}




class Resident {
  var id;
  var firstname;
  var lastname;
  var dob;
  var address;

  Resident(this.id, this.firstname, this.lastname, this.dob, this.address);

  Resident.fromMap(var map) {
    id = map['id'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    dob = DateTime.parse(map['dob']);
    address = new Address.fromMap(map['address']);
  }

  Map toMap() {
    return {
      "id": id,
      "firstname": firstname,
      "lastname": lastname,
      "dob": "$dob",
      "address": address.toMap()
    };
  }
}
