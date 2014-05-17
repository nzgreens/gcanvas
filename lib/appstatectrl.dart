part of gcanvas.client;

@reflectable
class AppStateCtrl {
  Store _store;

  AppStateCtrl([this._store]);

  factory AppStateCtrl.create() {
    return new AppStateCtrl(
        new Store("gcanvas", "app-state")
    );
  }


  Future<bool> _open() {
    return _store.open();
  }


  Future<State> get() {
    Completer<State> completer = new Completer<State>();

    _open().then((_) {
      _store.exists('state').then((exists) {
        if(exists) {
          _store.getByKey("state").then((map) {
            State state = map != null ? new State.fromMap(map) : new State.create();
            completer.complete(state);
          });
        } else {
          completer.complete(new State.create());
        }
      });
    });

    return completer.future;
  }


  Future<bool> save(State state) {
    Completer<bool> completer = new Completer<bool>();

    _open().then((_) {
      _store.save(state.toMap(), 'state').then((key) {
        completer.complete(true);
      });
    });

    return completer.future;
  }
}
