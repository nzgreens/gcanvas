part of gcanvas.client;

class AppStateCtrl extends JsProxy {
  @reflectable Future<Store> _store;

  AppStateCtrl([this._store]);

  factory AppStateCtrl.create() {
    return new AppStateCtrl(
        Store.open("gcanvas", "app-state")
    );
  }


  Future<bool> _open() async {
    var store = _store.then((store) => store);

    return store != null;
  }


  Future<State> get() async {
    bool opened = await _open();
    if(opened) {
      Store store = await _store.then((store) {
        return store;
      });
      if(await store.exists('state')) {
        String map = await store.getByKey("state");
        State state = map != null ? new State.fromMap(JSON.decode(map)) : new State.create();

        return state;
      }
    }

    return new State.create();
  }


  Future<bool> save(State state) async {
    bool opened = await _open();
    if(opened) {
      var data;
      if(!detect.browser.isSafari) {
        data = state.toMap();
      } else {
        data = JSON.encode(state.toMap());
      }
      Store store = await _store.then((store) => store);
      String key = await store.save(data, 'state');

      return key != null;
    }

    return false;
  }
}
