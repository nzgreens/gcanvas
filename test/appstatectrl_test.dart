part of gcanvas_test;

void appstatectrl_test() {
  group("[AppStateCtrl]", () {
    var address3 = new Address.create(
        id: 3.toString(),
        address1: "52 Bignell street",
        address2: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);
    var store = new Store("test", "app-state");

    var state = new State.create();
    var appstatectrl = new AppStateCtrl(store);


    setUp(() {
      schedule(() {
        return store.open().then((_) => store.nuke());
      });
      currentSchedule.onComplete.schedule(() => store.nuke());
    });


    test("gets initial state", () {
      schedule(() {
        Future<State> future = appstatectrl.get();
        future.then((retstate) {
          expect(retstate.addressListView, equals(state.addressListView));
          expect(retstate.addressView, equals(state.addressView));
          expect(retstate.address.id, equals(state.address.id));
        });
        expect(future, completes);

        return future;
      });
    });


    test("save state", () {
      schedule(() {
        Future<bool> future = appstatectrl.save(state);
        future.then((success) {
          expect(success, isTrue);
          Future future = store.getByKey("state").then((map) {
            expect(state.toMap(), equals(map));
          });
          expect(future, completes);
        });
        expect(future, completes);

        return future;
      });
    });
  });
}