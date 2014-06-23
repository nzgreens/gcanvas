library gcanvas.address.resident;

import 'package:observe/observe.dart';

class Resident extends Observable {
  int id;
  String title;
  String firstname;
  String middlenames;
  String lastname;
  String occupation;
  String gender;
  DateTime dob;
  String email;
  String phone;
  String notes;


  Resident(
      this.id,
      this.title,
      this.firstname,
      this.middlenames,
      this.lastname,
      this.occupation,
      this.gender,
      this.dob,
      {
       this.email,
       this.phone,
       this.notes
      }
  );


  factory Resident.create({
    int id: -1,
    String title: '',
    String firstname: '',
    String middlenames: '',
    String lastname: '',
    String occupation: '',
    String gender: '',
    DateTime dob,
    String email : '',
    String phone: '',
    String notes: ''
  }) {

    return new Resident(
        id,
        title,
        firstname,
        middlenames,
        lastname,
        occupation,
        gender,
        dob,
        email: email,
        phone: phone,
        notes: notes
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
    var email = map['email'];
    var phone = map['phone'];
    var notes = map['notes'];

    return new Resident.create(
        id: id,
        title: title,
        firstname: firstname,
        middlenames: middlenames,
        lastname: lastname,
        occupation: occupation,
        gender: gender,
        dob: dob,
        email: email,
        phone: phone,
        notes: notes
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
      "email": email,
      "phone": phone,
      "notes": notes
    };
  }
}
