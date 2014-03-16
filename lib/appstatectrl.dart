part of gcanvas.client;


class AppStateCtrl {
  StoreCtrl _store;

  AppStateCtrl(this._store);

  factory AppStateCtrl.create() {
    return new AppStateCtrl(
        new StoreCtrl.create()
    );
  }


  Future<State> get() {
    return _store.getState().then((state) {
      State appState = state != null ? state : new State.create();

      appState.address = appState.address != null ? appState.address : new Address.create();

      return new Future<State>.value(appState);
    });
  }


  Future<bool> save(State state) {

    return _store.saveState(state);
  }
}
