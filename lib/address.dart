part of gcanvas;

@NgDirective(
  selector: '[addresses]',
  publishAs: 'addreses'
)
class AddressListCtrl {
  StoreCtrl _storeCtrl;

  AddressListCtrl(this._storeCtrl);


  Future<int> add(Address addr) {
    return _storeCtrl.addAddress(addr);
  }


  Future<bool> remove(Address addr) {
    return _storeCtrl.removeAddress(addr);
  }


  Future<List<Address>> getList() {
    return _storeCtrl.getAddressList();
  }
}



class ResidentListCtrl {
  StoreCtrl _storeCtrl;

  ResidentListCtrl(this._storeCtrl);


  Future<List<Resident>> getResidentsAtAddress(Address address) {
    return _storeCtrl.getResidentsAtAddress(address);
  }


  Future<int> add(Resident resident) {
    return _storeCtrl.addResident(resident);
  }


  Future<bool> remove(Resident resident) {
    return _storeCtrl.removeResident(resident);
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
