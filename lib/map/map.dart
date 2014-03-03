library gcanvas.map;

import 'package:google_maps/google_maps.dart'
        show LatLng, GMap, MapOptions, MapTypeId, ImageMapTypeOptions, Size,
             ImageMapType, Marker, MarkerOptions, Geocoder, GeocoderRequest,
             GeocoderStatus, OverlayView, MapCanvasProjection, Point;

import 'dart:js';

import 'dart:html';
import 'dart:async' show Completer, Future, Stream;

import 'dart:math' as Math;

import 'package:observe/observe.dart';

part 'location.dart';
part 'marker.dart';
part 'mapclickproxy.dart';

abstract class GCanvasMap {
  const GCanvasMap();


  Stream get onDblClick;


  factory GCanvasMap.create(Element container, {Element proxy}) {
    //return new GoogleMaps(container);
    var map = new GoogleOpenStreetMaps(container);
    //LeafletOpenStreetMaps map = new LeafletOpenStreetMaps(container);
    if(proxy != null) {
      map.addProxy(proxy);
    }

    return map;
  }

  void centre(GeoCoordinates coords);


  MapMarker addMarker(GeoCoordinates coords, {label: ""});

}



class GoogleMaps extends GCanvasMap {
  GMap _map;
  Stream get onDblClick => _map.onDblClick;

  GoogleMaps(Element container) {
    final mapOptions = new MapOptions()
    ..zoom = 12
    //..center = new LatLng(coords.latitude, coords.longitude)
    //..mapTypeId = MapTypeId.ROADMAP
    ..mapTypeId = "OSM"
    ..mapTypeControl = false
    ..streetViewControl = false
    ;

    _map = new GMap(container, mapOptions);

  }


  void centre(GeoCoordinates coords) {
    _map.center = new LatLng(coords.latitude, coords.longitude);
  }


  MapMarker addMarker(GeoCoordinates coords, {label: ""}) {
    GMapMarker marker = new GMapMarker(coords, label: label);
    marker.applyToMap(_map);

    return marker;
  }
}


class Overlay extends OverlayView {
  DivElement _div;
  var _map;
  bool projectionSet = false;

  Overlay(this._map) : super() {
    map = _map;
    set_draw(() {
      var p = projection.fromLatLngToDivPixel(new LatLng(-39.946269, 175.02295019999997));
      print("DivPixel: ${p.x}, ${p.y}");
      p = projection.fromLatLngToContainerPixel(new LatLng(-39.946269, 175.02295019999997));
      print("ContainerPixel: ${p.x}, ${p.y}");
      projectionSet = true;
    });
    set_onAdd(() {
      _div = new DivElement();
      (panes.overlayImage as Element).children.add(_div);
    });
  }

  Point getPixelPointFromLatLng(GeoCoordinates coords) {
    if(projectionSet) {
      return projection.fromLatLngToDivPixel(new LatLng(coords.latitude, coords.longitude));
    }

    return new Point(-1, -1);
  }


  GeoCoordinates getCoordsFromPoint(Point point) {
    if(projectionSet) {
      var latlng = projection.fromDivPixelToLatLng(point);

      return new GeoCoordinates.create(latlng.lat, latlng.lng);
    }

    return new GeoCoordinates.create(-1.0, -1.0);
  }
}


class GoogleOpenStreetMaps extends GCanvasMap {
  GMap _map;
  Stream get onDblClick => _map.onDblClick;
  MapClickProxy _proxy;
  Element _container;
  @reflectable OverlayView _overlay;

  GoogleOpenStreetMaps(this._container) {
    /*var address = "48 Bignell street, Gonville, Wanganui, New Zealand";
    GeocoderRequest request = new GeocoderRequest();
    request.address = address;
    Geocoder geocode = new Geocoder();
    geocode.geocode(request, (results, status) {
      if(status == GeocoderStatus.OK) {
        print(results[0].geometry.location);
      }
    });*/

    final mapOptions = new MapOptions()
    ..zoom = 18
    ..disableDoubleClickZoom = true
    //..center = new LatLng(coords.latitude, coords.longitude)
    //..mapTypeId = MapTypeId.ROADMAP
    ..mapTypeId = "OSM"
    ..mapTypeControl = false
    ..streetViewControl = false
    ..disableDefaultUI = true;
    ;

    _map = new GMap(_container, mapOptions);


    ImageMapTypeOptions mapTypeOptions = new ImageMapTypeOptions()
    ..getTileUrl = (coord, zoom) {
      return "http://tile.openstreetmap.org/${zoom}/${coord.x}/${coord.y}.png";
    }
    ..tileSize =  new Size(256, 256)
    ..name = "OpenStreetMap"
    ..maxZoom = 18;

    try {
      _map.mapTypes.set("OSM", new ImageMapType(mapTypeOptions));
    } catch(any) {
      print("any error: ${any}");
    }



  }



  void centre(GeoCoordinates coords) {
    _map.center = new LatLng(coords.latitude, coords.longitude);
  }



  MapMarker addMarker(GeoCoordinates coords, {label: ""}) {
    GMapMarker marker = new GMapMarker(coords, label: label);
    marker.applyToMap(_map);



    return marker;
  }


  void addProxy(DivElement proxy) {
    _overlay = new Overlay(_map);
    _proxy = new MapClickProxy(_map, proxy, _overlay);
  }
}



class LeafletOpenStreetMaps extends GCanvasMap {
  Stream get onDblClick => null;
  JsObject _leaflet = context['L'];
  JsObject _map;
  JsObject _tileLayer;
  MapClickProxy _proxy;
  Element element;

  LeafletOpenStreetMaps(this.element) {
    element.onClick.listen((event) {
      print("clicked: ${event}");
      event.bubbles = false;
    });
    var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    var osmAttrib='Map data &copy; OpenStreetMap contributors';
    var tileOptions = new JsObject.jsify({'minZoom' : 8, 'maxZoom': 18, 'attribution': osmAttrib});

    _map = new JsObject(_leaflet['map'], [element]);
    _map.callMethod("setZoom", [18]); //must do this before tileLayer is set otherwise an error occurs
    _tileLayer = new JsObject(_leaflet['tileLayer'], [osmUrl, tileOptions]);
    _tileLayer.callMethod('addTo', [_map]);
    _map.callMethod('on', ['click', (e) => print("click")]);
  }


  void centre(GeoCoordinates coords) {
    var latlng = new JsObject(_leaflet['latLng'], [coords.latitude, coords.longitude]);
    _map.callMethod('setView', [latlng]);
  }

  MapMarker addMarker(GeoCoordinates coords, {label: ""}) {
    LeafletMapMarker marker = new LeafletMapMarker(coords, label: label);
    marker.applyToMap(_map);

    return marker;
  }


  void addProxy(Element proxy) {
    _proxy = new MapClickProxy(element, proxy);
  }
}
