library gcanvas.address.response;

import 'package:polymer/polymer.dart' show JsProxy, reflectable;

import 'resident.dart';

class ResidentResponse extends JsProxy {
  @reflectable int id;
  @reflectable int response = -1;
  @reflectable int support = -1;
  @reflectable Resident resident;
  @reflectable Map<String, bool> involvement;


  ResidentResponse(this.id, this.response, this.support, this.resident, this.involvement);


  factory ResidentResponse.create({id: -1, response: -1, support: -1, resident, involvement}) {
    resident = resident != null ? resident : new Resident.create();
    involvement = involvement != null ? involvement : new Map<String, bool>();

    return new ResidentResponse(id, response, support, resident, involvement);
  }


  factory ResidentResponse.fromMap(Map map) {
    var id = map['id'];
    var response = map['response'];
    var support = map['support'];
    var resident = new Resident.fromMap(map['resident']);
    var involvement = map['involvement'];

    return new ResidentResponse.create(id: id, response: response, support: support, resident: resident, involvement: involvement);
  }


  Map toMap() {
    return {
      'id': id,
      'response': response,
      'support': support,
      'resident': resident.toMap(),
      'involvement': involvement
    };
  }
}
