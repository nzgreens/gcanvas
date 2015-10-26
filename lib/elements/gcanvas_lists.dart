@HtmlImport('gcanvas_lists.html')
library gcanvas.gcanvas_lists;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('gcanvas-lists')
class GCanvasListsElement extends PolymerElement {
  @property List<GCanvasListsItem> listItems = [];
  GCanvasListsElement.created() : super.created();
}


class GCanvasListsItem extends JsProxy {
  @reflectable int id;
  @reflectable String name;
  @reflectable int count;
}