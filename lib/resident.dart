library gcanvas.address.resident;

import 'package:observe/observe.dart';

class Resident extends Observable {
  final int id;
  @observable String title;
  @observable String firstname;
  @observable String middlenames;
  @observable String lastname;
  @observable String occupation;
  @observable String gender;
  @observable DateTime dob;
  @observable String email;
  @observable String phone;
  @observable String notes;
  @observable int response;
  @observable int support;
  @observable bool volunteer;
  @observable bool host_a_billboard;
  @observable int inferred_support_level;

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
       this.notes,
       this.response,
       this.support,
       this.volunteer,
       this.host_a_billboard,
       this.inferred_support_level

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
    String notes: '',
    int response: -1,
    int support: -1,
    bool volunteer: false,
    bool host_a_billboard: false,
    int inferred_support_level: -1
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
        notes: notes,
        response: response,
        support: support,
        volunteer: volunteer,
        host_a_billboard: host_a_billboard,
        inferred_support_level: inferred_support_level
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
    var response = map['response'];
    var support = map['support'];
    var volunteer = map['volunteer'];
    var host_a_billboard = map['host_a_billboard'];
    var inferred_support_level = map['inferred_support_level'];

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
        notes: notes,
        response: response,
        support: support,
        volunteer: volunteer,
        host_a_billboard: host_a_billboard,
        inferred_support_level: inferred_support_level
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
      "notes": notes,
      "response": response,
      "support": support,
      "volunteer": volunteer,
      "host_a_billboard": host_a_billboard,
      "inferred_support_level": inferred_support_level
    };
  }


  String toString() => toMap().toString();
}
