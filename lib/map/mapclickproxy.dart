part of gcanvas.map;

class MapClickProxy {
  GMap _target;
  Element _proxy;
  GCanvasOverlay _overlay;
  List<GMapMarker> _markers = new List<GMapMarker>();


  MapClickProxy(this._target, this._proxy, this._overlay) {
    _proxy.onClick.listen((MouseEvent event) {

      print("event: ${event.client.x}, ${event.client.y}");
      //GeoCoordinates coords = _overlay.getCoordsFromPoint(new GoogleMaps.Point(event.client.x, event.client.y));
      //print("coords: ${coords.latitude}, ${coords.longitude}");

      num zindex = _markers.fold(0, (m1, m2) => Math.max(m1, m2._marker.zIndex));
      print('coords');
      print(_markers.map((marker) => marker._marker.shape.coords));
      print("contains location");
      GoogleMaps.Point point = new GoogleMaps.Point(event.client.x - 20, event.client.y - 75);
      LatLng centre = _overlay.projection.fromDivPixelToLatLng(point);
      print("circle");
      GoogleMaps.Circle circle = new GoogleMaps.Circle(
                                        new GoogleMaps.CircleOptions()
                                          ..center = centre
                                          ..radius = 10
                                    );
      var filtered = _markers.toList()
          ..removeWhere((marker) {
            return !circle.bounds.contains(marker._marker.position);//poly.containsLocation(marker._marker.position, polygon);
          });
      print("Filtered: $filtered");

      GMapMarker target = filtered.firstWhere((marker) {
        return marker._marker.zIndex == zindex;
      }, orElse: () => new GMapMarker(new GeoCoordinates.create(-1.0, -1.0)));


      var customEvent = new CustomEvent('marker-clicked', detail: target);
      _proxy.dispatchEvent(customEvent);

      event.preventDefault();
    });



    _proxy.onTouchStart.listen((TouchEvent event) {
      if(event.touches.length == 2) {
        _scale = true;
        _pinchStart(event);
      }
      //event.preventDefault();
    });


    _proxy.onTouchMove.listen((event) {
      if(_scale && event.touches.length == 2) {
        _pinchMove(event);
      } else {
        _scale = false;
      }
      event.preventDefault();
    });


    _proxy.onTouchEnd.listen((event) {
      if(_scale) {
        _pinchEnd();
        _scale = false;
      }
      //event.preventDefault();
    });

  }


  void addMarker(MapMarker marker) {
    _markers.add(marker);
  }


  bool _scale = false;
  Math.Point _touchStart1, _touchStart2;

  void _pinchStart(TouchEvent event) {
    var client1 = event.touches[0].client;
    var client2 = event.touches[1].client;
    _touchStart1 = new Math.Point(client1.x, client1.y);
    _touchStart2 = new Math.Point(client2.x, client2.y);
  }


  Math.Point _touchEnd1, _touchEnd2;

  void _pinchMove(TouchEvent event) {
    var client1 = event.touches[0].client;
    var client2 = event.touches[1].client;
    _touchEnd1 = new Math.Point(client1.x, client1.y);
    _touchEnd2 = new Math.Point(client2.x, client2.y);
  }


  void _pinchEnd() {
    if(_touchEnd1 == null || _touchEnd2 == null) return;

    double startDistance = Math.sqrt(((_touchStart1.x - _touchStart2.x)*(_touchStart1.x - _touchStart2.x))+((_touchStart1.y - _touchStart2.y)*_touchStart1.y - _touchStart2.y));
    double endDistance = Math.sqrt(((_touchEnd1.x - _touchEnd2.x)*(_touchEnd1.x - _touchEnd2.x))+((_touchEnd1.y - _touchEnd2.y)*(_touchEnd1.y - _touchEnd2.y)));

    if(startDistance > endDistance) {
      //zoom out
      _target.zoom--;
      resizeOverlay();
    } else if(startDistance < endDistance) {
      //zoom in
      _target.zoom++;
      resizeOverlay();
    }

    _touchStart1 = _touchEnd1;
    _touchStart2 = _touchEnd2;
    _touchEnd1 = _touchEnd2 = null;
  }



  void resizeOverlay() {
    //_overlay.onRemove();
    _overlay.onAdd();
  }
}
