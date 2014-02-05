part of gcanvas;

class ResidentResponse {
  var response = "";
  var reason = "";
  Address address;
  var presentResidents = new List<Resident>();

  ResidentResponse(this.address);
  ResidentResponse.fromMap(var map) {
    response = map['response'];
    reason = map['reason'];
    address = new Address.fromMap(map['address']);
    presentResidents.addAll(map['presentResidents'].map((residentMap) => new Resident.fromMap(residentMap)));
  }


  Map toMap() {
    return {
      'response': response,
      'reason': reason,
      'address': address.toMap(),
      'presentResidents': presentResidents.map((resident) => resident.toMap())
    };
  }
}