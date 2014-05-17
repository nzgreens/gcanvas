library gcanvas.address.resident;

import 'package:observe/observe.dart' show reflectable;


//import 'address.dart';

@reflectable
class Resident {
  @reflectable int id;
  @reflectable String title;
  @reflectable String firstname;
  @reflectable String middlenames;
  @reflectable String lastname;
  @reflectable String occupation;
  @reflectable String gender;
  @reflectable DateTime dob;
  //@reflectable Address address;


  Resident(
      this.id,
      this.title,
      this.firstname,
      this.middlenames,
      this.lastname,
      this.occupation,
      this.gender,
      this.dob
      //this.address
      );


  factory Resident.create({
    int id: -1,
    String title: '',
    String firstname: '',
    String middlenames: '',
    String lastname: '',
    String occupation: '',
    String gender: '',
    DateTime dob
    //Address address
  }) {
    //if (address == null) {
      //so deserialising a resident record will work
    //  address = new Address.create();
    //}

    return new Resident(
        id,
        title,
        firstname,
        middlenames,
        lastname,
        occupation,
        gender,
        dob
        //address
        );
  }


  factory Resident.fromMap(var map) {
    var id = map['id'];
    var title = map['title'];
    var firstname = map['firstname'];
    var middlenames = map['middlenames'];
    var lastname = map['lastname'];
    var occupation = map['occupation'];
    var gender = map['gender'];
    var dob = DateTime.parse(map['dob']);
    //var address = new Address.fromMap(map['address']);

    return new Resident.create(
        id: id,
        title: title,
        firstname: firstname,
        middlenames: middlenames,
        lastname: lastname,
        occupation: occupation,
        gender: gender,
        dob: dob
        //address: address
        );
  }


  Map toMap() {
    return {
      "id": id,
      "title": title,
      "firstname": firstname,
      "middlenames": middlenames,
      "lastname": lastname,
      "occupation": occupation,
      "gender": gender,
      "dob": "$dob",
      //"address": address.toMap()
    };
  }
}
