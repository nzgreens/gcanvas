library gcanvas.address.resident;

import 'package:polymer/polymer.dart' show JsProxy, reflectable;

class Resident extends JsProxy {
  @reflectable final int id;
  @reflectable  String title;
  @reflectable  String firstname;
  @reflectable  String middlenames;
  @reflectable  String lastname;
  @reflectable  String occupation;
  @reflectable  String gender;
  @reflectable  DateTime dob;
  @reflectable  String email;
  @reflectable  String phone;
  @reflectable  String notes;
  @reflectable  int response;
  @reflectable  int support;
  @reflectable bool volunteer;
  @reflectable  bool host_a_billboard;
  @reflectable  int inferred_support_level;

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
       this.email: '',
       this.phone: '',
       this.notes: '',
       this.response: -1,
       this.support: -1,
       this.volunteer: false,
       this.host_a_billboard: false,
       this.inferred_support_level: -1
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


  factory Resident.fromMap(Map map) {
    var id = map['id'];
    var title = map['title'];
    var firstname = map['firstname'];
    var middlenames = map['middlenames'];
    var lastname = map['lastname'];
    var occupation = map['occupation'];
    var gender = map['gender'];
    var dob = map.containsKey('dob') && map['dob'] != null ? DateTime.parse(map['dob']) : new DateTime.now();
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
      "dob": dob != null ? "$dob" : new DateTime.now().toString(),
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

  void setField(String name, value) {
    switch(name) {
      case 'id':
        throw new Exception("id is final and can't be changed");
        break;
      case 'title':
        title = value;
        break;
      case 'firstname':
        firstname = value;
        break;
      case 'middlenames':
        middlenames = value;
        break;
      case 'lastname':
        lastname = value;
        break;
      case 'occupation':
        occupation = value;
        break;
      case 'gender':
        gender = value;
        break;
      case 'dob':
        dob = value;
        break;
      case 'email':
        email = value;
        break;
      case 'phone':
        phone = value;
        break;
      case 'notes':
        notes = value;
        break;
      case 'response':
        response = value;
        break;
      case 'support':
        support = value;
        break;
      case 'volunteer':
        volunteer = value;
        break;
      case 'host_a_billboard':
        host_a_billboard = value;
        break;
      case 'inferred_support_level':
        inferred_support_level = value;
        break;
      default:
        throw new Exception('field of name $name does not exist in Resident');
    }
  }

  String toString() => toMap().toString();
}
