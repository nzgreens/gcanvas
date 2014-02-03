part of gcanvas;

class StoreRouter implements RouteInitializer {
  Scope _scope;

  StoreRouter(this._scope);

  void init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          defaultRoute: true,
          name: 'start',
          enter: view('views/home.html')
        )
      ..onRoute.listen((data) {
        print(data);
      });
  }
}