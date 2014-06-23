part of gcanvas.client;

abstract class User {
  String firstname;
  String lastname;
  String email;


  factory User(firstname, lastname, email) {
    return new _UserImpl(firstname, lastname, email);
  }

  //the null user
  factory User.blank() {
    return new User("","", "");
  }
}

class _UserImpl extends Observable implements User {
  @observable String firstname;
  @observable String lastname;
  @observable String email;

  _UserImpl(this.firstname, this.lastname, this.email);
}
