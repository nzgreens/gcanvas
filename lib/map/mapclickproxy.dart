part of gcanvas.map;

class MapClickProxy {
  var _target;
  Element _proxy;
  Overlay _overlay;

  MapClickProxy(this._target, this._proxy, this._overlay) {
    _proxy.onClick.listen((MouseEvent event) {

      print("event: ${event.client.x}, ${event.client.y}");
      GeoCoordinates coords = _overlay.getCoordsFromPoint(new Point(event.client.x, event.client.y));
      print("coords: ${coords.latitude}, ${coords.longitude}");
      //_target.dispatchEvent(event);
    });


    _proxy.onTouchStart.listen((TouchEvent event) {
      print('start');
      print(event.touches.map((touch) => [touch.client.x, touch.client.y]));
    });


    _proxy.onTouchMove.listen((event) {
      print('move');
      print(event.touches.map((touch) => [touch.client.x, touch.client.y]));
    });


    _proxy.onTouchEnd.listen((event) {
      print('end');
      print(event.touches.map((touch) => [touch.client.x, touch.client.y]));
    });
    /*_proxy.onTouchEnd.listen((TouchEvent event) {
      print("touch: ${event.touches.last}");
    });*/
  }


}