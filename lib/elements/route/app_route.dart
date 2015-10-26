@HtmlImport('app_route.html')
library gcanvas.app_route;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:route_hierarchical/client.dart';
//import 'package:route_hierarchical/url_pattern.dart';

@PolymerRegister('app-route')
class AppRoute extends PolymerElement {
  bool _show = false;
  @Property(notify: true) bool get show => _show;
  @reflectable void set show(val) {
    _show = val;
    notifyPath('show', show);
  }

  @property String route;

  Router _router = new Router(useFragment: true);

  AppRoute.created() : super.created() {
//    var pattern = new UrlPattern(route);

  }

  void ready() {
    async(() {
      print('route is ${route}');
      _router.root
        ..addRoute(name: 'article', path: route, enter: (RouteEnterEvent e) {
        show = true;
        print("show ${e.path}");
      })
        ..addRoute(name: "default", defaultRoute: true, enter: (RouteEnterEvent e) {
        show = false;
        print('not show ${e.path}, ${route}');
      });
      _router.listen();
    });
  }
}
