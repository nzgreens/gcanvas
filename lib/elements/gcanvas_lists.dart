import 'package:polymer/polymer.dart';


@CustomTag('gcanvas-lists')
class GCanvasListsElement extends PolymerElement {
  @published List<GCanvasListsItem> listItems = toObservable([]);
  GCanvasListsElement.created() : super.created();
}


class GCanvasListsItem {
  int id;
  String name;
  int count;
}