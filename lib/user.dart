part of gcanvas.client;

class User extends JsProxy {
  @reflectable String firstname;
  @reflectable String lastname;
  @reflectable String email;


  User(this.firstname, this.lastname, this.email);


  factory User.create({firstname, lastname, email}) {
    return new User(firstname, lastname, email);
  }

  factory User.fromMap(Map userData) {
    return new User(userData['firstname'], userData['lastname'], userData['email']);
  }

  //the null user
  factory User.blank() {
    return new User.create(firstname: "", lastname: "", email: "");
  }

  Map toMap() {
    return { 'firstname': firstname, 'lastname': lastname, 'email': email };
  }
}
