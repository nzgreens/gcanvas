part of gcanvas_test;


class UserDBComponent extends PageComponent {
  UserDBComponent(el) : super(el);

  Future<Map> status() => el.status();
  Future<bool> login(email, password) => el.login(email, password);
  Future<bool> registration(user, password) => el.registration(user, password);
}


userdb_test() {
  solo_group('[UserDB]', () {
    UserDBComponent component;
    setUp(() {
      run([]);
      PolymerElement _el = createElement('<user-db></user-db>');
      _el.baseURL = 'http://localhost:9999';
      document.body.append(_el);
      component = new UserDBComponent(_el);

      return component.flush();
    });

    tearDown(() {
      return stop();
    });

    test('status is unauthenticated', () {
      Future<Map> future = component.status();
      future.then((status) {
        expect(status.containsKey('status'), isTrue);
        expect(status['status'], equals('unauthenticated'));
      });
      expect(future, completes);
    });
  });

}