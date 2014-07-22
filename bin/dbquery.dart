part of gcanvas.server.db;

class ResidentAddress {
  var address;
  var residents;
}

Future<List> addressByMeshblock(
    DBConnection conn,
    var latitude,
    var longitude) {

  String addressQuery = "SELECT * FROM address WHERE "
    "latitude < @latitudePlus AND "
    "latitude > @latitudeMinus AND "
    "longitude < @longitudePlus AND "
    "longitude > @longitudeMinus AND "
    "visited = @visited;";
  Map queryMapData = {
                      'latitudePlus': latitude+oneKmOfLatOrLng,
                      'latitudeMinus': latitude-oneKmOfLatOrLng,
                      'longitudePlus': longitude+oneKmOfLatOrLng,
                      'longitudeMinus': longitude-oneKmOfLatOrLng,
                      'visited': false
                      };

  return conn.query(addressQuery,  queryMapData);
}



Future<List> residentsByAddress(DBConnection conn, List<Address> addresses) {
  List<int> idList = addresses.map((address) => address.id);
  String ids = idList.join(',');
  String residentQuery = "SELECT * FROM resident WHERE address_id IN ($ids);";
  //Map queryMapData = {'ids': ids};

  return conn.query(residentQuery);//, queryMapData);
}


num _earthRadius = 6371;

num radiansToDegrees(num rad) {
  return rad / (Math.PI / 180);
}

//good enough for short distances
num get oneKmOfLatOrLng => radiansToDegrees(1/_earthRadius);

num degreesToRadians(num deg) {
  return deg * (Math.PI / 180);
}



