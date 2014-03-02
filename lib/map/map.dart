library gcanvas.map;

import 'package:google_maps/google_maps.dart'
        show LatLng, GMap, MapOptions, MapTypeId, ImageMapTypeOptions, Size,
             ImageMapType, Marker, MarkerOptions, Geocoder, GeocoderRequest,
             GeocoderStatus;

import 'dart:js';

import 'dart:html' show Element;

import 'dart:html';
import 'dart:async' show Completer, Future, Stream;

//import 'package:observe/observe.dart';

part 'location.dart';
part 'marker.dart';
part 'mapclickproxy.dart';

abstract class GCanvasMap {
  const GCanvasMap();


  Stream get onDblClick;


  factory GCanvasMap.create(Element container) {
    //return new GoogleMaps(container);
    //return new GoogleOpenStreetMaps(container);
    return new LeafletOpenStreetMaps(container);
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



class GoogleOpenStreetMaps extends GCanvasMap {
  GMap _map;
  Stream get onDblClick => _map.onDblClick;

  GoogleOpenStreetMaps(Element container) {
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
    ..disableDoubleClickZoom
    //..center = new LatLng(coords.latitude, coords.longitude)
    //..mapTypeId = MapTypeId.ROADMAP
    ..mapTypeId = "OSM"
    ..mapTypeControl = false
    ..streetViewControl = false
    ;

    _map = new GMap(container, mapOptions);


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

    _map.onClick.listen((data) {
      print('clicked');
    });
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



class LeafletOpenStreetMaps extends GCanvasMap {
  Stream get onDblClick => null;
  JsObject _leaflet = context['L'];
  JsObject _map;
  JsObject _tileLayer;

  LeafletOpenStreetMaps(Element element) {
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
}
