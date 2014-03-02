library gcanvas.address.response;

import 'package:observe/observe.dart' show reflectable;

import 'resident.dart';
import 'address.dart';


@reflectable
class ResidentResponse {
  @reflectable int id;
  @reflectable String response = "";
  @reflectable String reason = "";
  @reflectable Address address;
  @reflectable List<Resident> presentResidents;



  ResidentResponse(this.id, this.response, this.reason, this.address, this.presentResidents);


  factory ResidentResponse.create({id: -1, response: '', reason: '', address, presentResidents}) {
    address = address != null ? address : new Address.create();
    presentResidents = presentResidents != null ? presentResidents : [];

    return new ResidentResponse(id, response, reason, address, presentResidents);
  }


  factory ResidentResponse.fromMap(Map map) {
    var id = map['id'];
    var response = map['response'];
    var reason = map['reason'];
    var address = new Address.fromMap(map['address']);
    var residents = [];
    residents.addAll(map['presentResidents'].map((residentMap) => new Resident.fromMap(residentMap)));

    return new ResidentResponse.create(id: id, response: response, reason: reason, address: address, presentResidents: residents);
  }


  Map toMap() {
    return {
      'id': id,
      'response': response,
      'reason': reason,
      'address': address.toMap(),
      'presentResidents': presentResidents.map((resident) => resident.toMap())
    };
  }
}