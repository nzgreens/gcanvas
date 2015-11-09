part of gcanvas.client;

class User extends JsProxy {
  @reflectable String username;
  @reflectable String firstname;
  @reflectable String lastname;
  @reflectable String email;


  User(this.username, this.firstname, this.lastname, this.email);


  factory User.create({username, firstname, lastname, email}) {
    return new User(username, firstname, lastname, email);
  }

  factory User.fromMap(Map userData) {
    return new User(userData['username'], userData['firstname'], userData['lastname'], userData['email']);
  }

  //the null user
  factory User.blank() {
    return new User.create(username: "", firstname: "", lastname: "", email: "");
  }

  Map toMap() {
    return { 'username': username, 'firstname': firstname, 'lastname': lastname, 'email': email };
  }
}
