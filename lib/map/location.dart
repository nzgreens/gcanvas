part of gcanvas.map;


abstract class GeoLocation {
  const GeoLocation();

  factory GeoLocation.create({type: "browser"}) {
    if(type == "browser") {
      if(!window.navigator.userAgent.contains("(Dart)")) {
        return new BrowserLocation();
      } else {
        return new DartiumLocation();
      }
    }
  }

  Future<GeoCoordinates> getCurrent();

}


/*
 * @TODO: Find a way to overcome the Goelocation API not working in Firefox,
 * maybe create a Google App for this with Geolocation API enabled
 * @TODO: create toMap method and fromMap factory for serialisation purposes.
 */
class BrowserLocation extends GeoLocation {

  Future<GeoCoordinates> getCurrent() {
    Completer<GeoCoordinates> completer = new Completer<GeoCoordinates>();

    window.navigator
      .geolocation.getCurrentPosition()
        ..then((pos) {
          completer.complete(new GeoCoordinates.create(pos.coords.latitude, pos.coords.longitude));
        })
        ..catchError((PositionError error) {
          completer.completeError(error);
        });

    return completer.future;
  }
}



/**
 * Overcome the fact that Geolocation API doesn't work in Dartium.
 * I need this for testing.
 */
class DartiumLocation extends GeoLocation {


  Future<GeoCoordinates> getCurrent() {
    return new Future.value(new GeoCoordinates.create(-39.94622585, 175.02286207));
  }
}



abstract class GeoCoordinates {
  double get latitude;
  double get longitude;
  set latitude(val);
  set longitude(val);

  const GeoCoordinates();

  factory GeoCoordinates.create([double latitude, double longitude]) {
    latitude = latitude != null ? latitude : -1.0;
    longitude = longitude != null ? longitude : -1.0;

    return new CoordinatesImpl(latitude, longitude);
  }


  factory GeoCoordinates.fromMap(Map map) {
    var latitude =
        map.containsKey('latitude') && map['latitude'] != null ?
            double.parse(map['latitude'].toString()) : -1.0;
    var longitude = map.containsKey('longitude') && map['longitude'] != null ?
        double.parse(map['longitude'].toString()) : -1.0;

    return new GeoCoordinates.create(latitude, longitude);
  }


  Map toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude
    };
  }
}


class CoordinatesImpl extends GeoCoordinates {
  double _latitude;
  double _longitude;

  double get latitude => _latitude;
  double get longitude => _longitude;
  set latitude(val) => _latitude = val;
  set longitude(val) => _longitude = val;


  CoordinatesImpl(this._latitude, this._longitude);
}
