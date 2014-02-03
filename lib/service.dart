part of gcanvas;


class DatabaseCtrl {
  Http _http;
  StoreCtrl _store;

  DatabaseCtrl(this._http, this_store);

  init(AddressCtrl ctrl) {

  }

  void add(Map<String, String> data) {
    print(data);
  }


  Future sync() {
    return new Future();
  }
}