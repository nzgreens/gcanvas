part of gcanvas.map;

abstract class MapMarker {
  const MapMarker();

  Stream get onClick;

  bool get selected => false;
  set selected(bool val);
  void setIcon(String url);
  void resetIcon();
}


class GMapMarker implements MapMarker {
  Marker _marker;
  bool _selected = false;

  bool get selected => _selected;
  set selected(bool val) => _selected = val;

  String _defaultIconURL;

  GMapMarker(GeoCoordinates coords, {label: ""}) {
    var shape = new GoogleMaps.MarkerShape()
      ..type = GoogleMaps.MarkerShapeType.RECT
      //..coords = [80, 80, 80, 80]
      ;

    _marker = new Marker(new MarkerOptions()
        ..position = new LatLng(coords.latitude, coords.longitude)
        ..title = label
        ..flat = true
        ..clickable = true
        ..zIndex = 11
        ..shape = shape
        //..shadow = "/assets/gcanvas/images/rotate2.png"
    );

    /*_marker.onClick.listen((data) {
      _marker.map = null;
    });*/
  }


  void applyToMap(GMap map) {
    _marker.map = map;
  }


  Stream get onClick => _marker.onClick;

  void setIcon(String url) {
    _marker.icon = url;
  }


  void resetIcon() {
    _marker.icon = null;
  }
}



class LeafletMapMarker implements MapMarker {
  JsObject _leaflet = context['L'];
  var _marker;
  bool _selected = false;

  bool get selected => _selected;
  set selected(bool val) => _selected = val;

  String _defaultIconURL;

  LeafletMapMarker(GeoCoordinates coords, {label: ""}) {
    var latlng = new JsObject(_leaflet['latLng'], [coords.latitude, coords.longitude]);
    var options = new JsObject.jsify({'title': label, 'clickable': true});
    _marker = new JsObject(_leaflet['marker'], [latlng, options]);


    /*_marker.onClick.listen((data) {
      _marker.map = null;
    });*/
  }


  void applyToMap(var map) {
    _marker.callMethod('addTo', [map]);
  }


  Stream get onClick => null;//_marker.onClick;


  void setIcon(String url) {
    _marker.icon = url;
  }


  void resetIcon() {
    _marker.icon = null;
  }
}