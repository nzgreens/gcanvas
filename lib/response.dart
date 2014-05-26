library gcanvas.address.response;

import 'package:observe/observe.dart' show reflectable;

import 'resident.dart';
import 'address.dart';


@reflectable
class ResidentResponse {
  @reflectable int id;
  @reflectable int response = -1;
  @reflectable int support = -1;
  @reflectable Resident resident;



  ResidentResponse(this.id, this.response, this.support, this.resident);


  factory ResidentResponse.create({id: -1, response: -1, support: -1, resident}) {
    resident = resident != null ? resident : new Resident.create();

    return new ResidentResponse(id, response, support, resident);
  }


  factory ResidentResponse.fromMap(Map map) {
    var id = map['id'];
    var response = map['response'];
    var support = map['support'];
    var resident = new Resident.fromMap(map['resident']);

    return new ResidentResponse.create(id: id, response: response, support: support, resident: resident);
  }


  Map toMap() {
    return {
      'id': id,
      'response': response,
      'support': support,
      'resident': resident.toMap()
    };
  }
}
