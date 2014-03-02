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



class BrowserLocation extends GeoLocation {
  BrowserLocation() {

  }

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

  DartiumLocation() {

  }

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

  factory GeoCoordinates.create(double latitude, double longitude) {
    return new CoordinatesImpl(latitude, longitude);
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
