import 'package:polymer/polymer.dart';

import 'package:gcanvas/map/map.dart';
import 'package:gcanvas/address.dart';

import 'dart:html';

@CustomTag('area-selector')
class AreaSelectorElement extends PolymerElement {

  @published GeoCoordinates location = new GeoCoordinates.create(-39.9462347, 175.02271970000004);
  @published List<Address> availableAddresses = toObservable([]);

  @reflectable GCanvasMap map;
  @reflectable Map<int,MapMarker> mapMarkers = toObservable({});

  AreaSelectorElement.created() : super.created();

  void ready() {
    super.ready();

    //initMap();
    print("location is: $location");

  }


  void enteredView() {
    super.enteredView();
    print("enteredView: location is: $location");
    print(availableAddresses);
    availableAddresses.forEach((Address address) {
      if(!mapMarkers.containsKey(address.id)) {
        if(address.street == "50 Bignell street") {
          address.latitude = -39.9462347;
          address.longitude = 175.02271970000004;
        } else if(address.street == "48 Bignell street") {
          address.latitude = -39.946269;
          address.longitude = 175.02295019999997;
        }
        MapMarker marker = map.addMarker(new GeoCoordinates.create(address.latitude, address.longitude), label: address.street);
        mapMarkers[address.id] = marker;
        print(marker);
        fireAddMarkerEvent(address, marker);
        //map.centre(new GeoCoordinates.create(address.latitude, address.longitude));
      }

    });
    print(mapMarkers);

  }

  locationChanged() {
    print("location changed");
    initMap();
    map.centre(location);
  }


  void fireAddMarkerEvent(Address address, MapMarker marker) {
    fire("added-marker", detail: {'address': address, 'marker': marker});
  }


  void initMap() {
    if(map == null) {
      map = new GCanvasMap.create($['map'], proxy: $['overlay']);
    }
  }
}
