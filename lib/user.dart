part of gcanvas.client;

abstract class User {
  String firstname;
  String lastname;
  String email;


  factory User(firstname, lastname, email) {
    return new _UserImpl(firstname, lastname, email);
  }


  factory User.create({firstname, lastname, email}) {
    return new User(firstname, lastname, email);
  }

  factory User.fromMap(Map userData) {
    return new User(userData['firstname'], userData['lastname'], userData['email']);
  }

  //the null user
  factory User.blank() {
    return new User("","", "");
  }

  Map toMap();
}

class _UserImpl extends Observable implements User {
  @observable String firstname;
  @observable String lastname;
  @observable String email;

  _UserImpl(this.firstname, this.lastname, this.email);

  Map toMap() {
    return { 'firstname': firstname, 'lastname': lastname, 'email': email };
  }
}
