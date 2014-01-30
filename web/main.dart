import 'package:angular/angular.dart';
import 'package:polymer/polymer.dart';
//import 'package:angular/routing/module.dart';
import 'package:angular_node_bind/angular_node_bind.dart';
import 'package:gcanvas/store.dart';


class StoreModule extends Module {
  StoreModule() {
    type(NodeBindDirective);
    type(RouteInitializer, implementedBy: StoreRouter);
  }
}

main() {
  initPolymer().run((){
    ngBootstrap(module: new StoreModule());
  });
}'