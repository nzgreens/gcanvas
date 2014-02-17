part of gcanvas.client;


class AppStateCtrl {
  Store _store;

  AppStateCtrl(this._store);

  factory AppStateCtrl.create() {
    return new AppStateCtrl(
        new Store('gcanvas', 'app-state')
    );
  }

}