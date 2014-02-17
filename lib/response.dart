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
  @reflectable List<Resident> presentResidents = new List<Resident>();

  ResidentResponse(this.address);


  ResidentResponse.fromMap(var map) {
    id = map['id'];
    response = map['response'];
    reason = map['reason'];
    address = new Address.fromMap(map['address']);
    presentResidents.addAll(map['presentResidents'].map((residentMap) => new Resident.fromMap(residentMap)));
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