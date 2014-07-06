import 'package:polymer/polymer.dart';

import 'package:route_hierarchical/client.dart';
import 'package:route_hierarchical/url_pattern.dart';

@CustomTag('app-route')
class AppRoute extends PolymerElement {
  @observable bool show = false;
  @published String route;

  Router _router = new Router(useFragment: true);

  AppRoute.created() : super.created() {
    var pattern = new UrlPattern(route);
    _router.root
        ..addRoute(name: 'article', path: pattern, enter: (RouteEnterEvent e) {
          show = true;
          print("show ${e.path}");
        })
        ..addRoute(name: "default", defaultRoute: true, enter: (RouteEnterEvent e) {
          show = false;
          print('not show ${e.path}');
        });
    _router.listen();
  }
}
