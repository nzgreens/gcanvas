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
