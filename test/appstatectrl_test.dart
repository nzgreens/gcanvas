part of gcanvas.test;

void appstatectrl_test() {
  group("[AppStateCtrl]", () {
    var address3 = new Address.create(
        id: 3,
        street: "52 Bignell street",
        suburb: "Gonville",
        city: "Wanganui",
        postcode: "4501",
        latitude: 169.201928,
        longitude: 49.21112,
        visited: false);
    var store = new StoreCtrlMock();

    var state = new State(false, true, address3);
    var appstatectrl = new AppStateCtrl(store);


    setUp(() {
      store.when(callsTo('getState'))
        ..thenReturn(new Future.value(state));
      store.when(callsTo('saveState'))
        ..thenReturn(new Future.value(true));
    });


    test("gets state", () {
      Future<State> future = appstatectrl.get();
      future.then((retstate) {
        expect(retstate.addressListView, equals(state.addressListView));
        expect(retstate.addressView, equals(state.addressView));
        expect(retstate.address.id, equals(state.address.id));
      });
      expect(future, completes);
      store.getLogs(callsTo('getState')).verify(happenedAtLeastOnce);
    });


    test("save state", () {
      Future<bool> future = appstatectrl.save(state);
      future.then((success) {
        expect(success, isTrue);
      });
      expect(future, completes);
      store.getLogs(callsTo('saveState')).verify(happenedAtLeastOnce);
    });
  });
}