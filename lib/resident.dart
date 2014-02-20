library gcanvas.address.resident;

import 'package:observe/observe.dart' show reflectable;


import 'address.dart';

@reflectable
class Resident {
  @reflectable int id;
  @reflectable String firstname;
  @reflectable String lastname;
  @reflectable DateTime dob;
  @reflectable Address address;


  Resident(this.id, this.firstname, this.lastname, this.dob, this.address);


  factory Resident.create({
        int id: -1,
        String firstname: '',
        String lastname: '',
        DateTime dob, Address address
        }) {
    if (dob == null) {
      dob = new DateTime.now();
    }

    if (address == null) {
      address = new Address.create();
    }

    return new Resident(id, firstname, lastname, dob, address);
  }


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
