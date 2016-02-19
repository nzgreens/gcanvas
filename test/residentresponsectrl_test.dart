part of gcanvas_test;

void residentresponsectrl_test() {
  group('[ResidentResponseCtrl]', () {
    Future<Store> store;
    ResidentResponseCtrl ctrl;
    setUp(() {
      store = Store.open('testgcanvas', 'response');
      ctrl = new ResidentResponseCtrl(store);
      return store;
    });

    tearDown(() async {
      (await store).nuke();
    });

    test('add adds a response to the store', () async {
      ResidentResponse response = new ResidentResponse.create();
      (await ctrl.add(response));
      expect((await (await store).exists('${response.id}')), isTrue);
    });

    test('add when adding should return true', () async {
      ResidentResponse response = new ResidentResponse.create();
      bool added = await ctrl.add(response);
      expect(added, isTrue);
    });

    test('getResidentResponses should return an empty list', () async {
      expect([], await ctrl.getResidentResponses());
    });

    group('[Store has residents reponses]', () {
      ResidentResponse response;
      setUp(() {
        response = new ResidentResponse.create();
        return store.then((store) {
          return store.save(JSON.encode(response.toMap()), "${response.id}");
        });
      });

      test('getResidentResponses should return all responses that are stored', () async {
        expect([response.id], (await ctrl.getResidentResponses()).map((response) => response.id));
      });

      test('remove should remove just one response that is stored', () async {
        (await ctrl.remove(response));
        expect((await (await store).exists('${response.id}')), isFalse);
      });
    });
  });
}