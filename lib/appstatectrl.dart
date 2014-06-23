part of gcanvas.client;

class AppStateCtrl extends Observable {
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
            State state;
            if(!detect.browser.isSafari) {
              state = map != null ? new State.fromMap(map) : new State.create();
            } else {
              state = map != null ? new State.fromMap(JSON.decode(map)) : new State.create();
            }

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
      var data;
      if(!detect.browser.isSafari) {
        data = state.toMap();
      } else {
        data = JSON.encode(state.toMap());
      }
      _store.save(data, 'state').then((key) {
        completer.complete(true);
      });
    });

    return completer.future;
  }
}
