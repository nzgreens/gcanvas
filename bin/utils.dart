part of gcanvas.server;



void serve404(HttpRequest request) {
  print(request.requestedUri.path);
  send404(request);
}


Function serveFile(String filename) {
  String mimeType = lookupMimeType(filename);

  String type = "text";
  String subType = "plain";

  if(mimeType != null) {
    type = mimeType.split("/")[0];
    subType = mimeType.split("/")[1];
  }
  return (HttpRequest request) {
    request.response.headers.contentType = new ContentType(type, subType);
    new File(filename).openRead().pipe(request.response).then((val){

    });
  };
}


Function serveAddresses(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    request.response.headers.contentType = new ContentType(type, subType);
    try {
      var path = request.requestedUri.path.split("/")
          ..removeWhere((item) => item.isEmpty);
      var lat = double.parse(path[1]);
      var lng = double.parse(path[2]);

      print("serveAddresses");
      var sql = "SELECT * FROM address WHERE latitude < ${lat+oneKmOfLatOrLng} AND latitude > ${lat-oneKmOfLatOrLng} AND longitude < ${lng+oneKmOfLatOrLng} AND longitude > ${lng-oneKmOfLatOrLng} AND visited=false;";
      pool.connect().then((Connection conn) {
        conn.query(sql).toList().then((List rows) {
          request.response
            ..write(JSON.encode(
              rows.map((row) => new Address(
                                        row.id,
                                        row.street,
                                        row.suburb,
                                        row.city,
                                        row.postcode,
                                        row.latitude,
                                        row.longitude,
                                        row.visited
                                      )).toList()
            ))
            ..close();
        });
      });
    } on FormatException catch(e) {
      print("wrong :-) $e");
      request.response.close();
    } finally {
      //can't close here, otherwise the stream will be closed before the future
      //above is finished, and we'll get no output ot the browser.
      //request.response.close();
    }
  };
}


Function uploadAddressesCsv(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    print("uploadAddressesCsv");
    request.response.headers.contentType = new ContentType(type, subType);
    HttpBodyHandler.processRequest(request).then((HttpBody body) {
      var csvData = body.body.toString();
      var massInsertData = new List<String>();
      var errors = new StringBuffer();
      //attempt to make it safe to insert so we don't waste DB processor time on incorrect data
      //why is csv the easiest for users of systems to use, I wish we could use JSON, but only viable for smaller inserts.
      CsvParser csvParser = new CsvParser(csvData, seperator:",", quotemark:'"');
      while (csvParser.moveNext()) {
        //make sure we have the correct number of columns
        List<String> line = csvParser.current.toList();
        if (line.length == 7) {
          //make sure all are surrounded by quotes
          massInsertData.add("(${line.map((item) {
            return (item.startsWith('"') || item.startsWith("'")) && (item.endsWith('"') || item.endsWith("'")) ? item : '"$item"';
          }).join(",")})");
        } else {
          errors.writeln(line.join(","));
        }
      }
      //prepare the statement
      var sqlInsert = "INSERT INTO address (street,suburb,city,postcode,latitude,longitude,visited) VALUES ${massInsertData.join(",")};";

      //wait till we have the data in the format we want before opening a connection
      pool.connect().then((Connection conn) {
        conn.execute(sqlInsert).then((int rowsAdded){
          var result = {'rows': rowsAdded, 'errors': errors.toString()};
          request.response
            ..write(JSON.encode(result))
            ..close()
            ;
        });
      });
    });
  };
}



Function uploadAddressesJson(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    print("uploadAddressesJson");
    request.response.headers.contentType = new ContentType(type, subType);
    //this should be a bit easier due to the nature of the input data
    HttpBodyHandler.processRequest(request).then((HttpBody body) {
      var jsonStrData = body.body.toString();
      try {
        List<Map> jsonData = JSON.decode(jsonStrData);
        var errors = new StringBuffer();

        var massInsertData = jsonData.map((Map addressMap) {
          return '("${addressMap['street']}","${addressMap['suburb']}","${addressMap['city']}","${addressMap['postcode']}","${addressMap['latitude']}","${addressMap['longitude']}","${addressMap['visited']}")';
        }).toList();

        //prepare the statement
        var sqlInsert = "INSERT INTO address (street,suburb,city,postcode,latitude,longitude,visited) VALUES ${massInsertData.join(",")};";

        //wait till we have the data in the format we want before opening a connection
        pool.connect().then((Connection conn) {
          conn.execute(sqlInsert).then((int rowsAdded){
            var result = {'rows': rowsAdded, 'errors': errors.toString()};
            request.response
              ..write(JSON.encode(result))
              ..close()
              ;
          });
        });
      } catch(all) {
        print(all);
        request.response
          ..write(JSON.encode({"error": "An error occurred. Please check the JSON input to see if it's correct"}))
          ..close();
      }
    });

  };
}



Function getAddressesJson(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    request.response.headers.contentType = new ContentType(type, subType);
    var sqlSelect = "SELECT * from address";
    print ("getAddressesJson");
    pool.connect().then((Connection conn) {
      conn.query(sqlSelect)..toList().then((List rows) {
        request.response
          ..write(JSON.encode(
            rows.map((row) => new Address(
                                      row.id,
                                      row.street,
                                      row.suburb,
                                      row.city,
                                      row.postcode,
                                      row.latitude,
                                      row.longitude,
                                      row.visited
                                    )).toList()
          ))
          ..close();
      });
    });
  };
}



Function getAddressJson(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    print("getAddressJson");
    request.response.headers.contentType = new ContentType(type, subType);
    var path = request.requestedUri.path.split("/")
        ..removeWhere((item) => item.isEmpty);
    var id = int.parse(path[1]);
    var sqlSelect = "SELECT * from address WHERE id=$id";
    //
    pool.connect().then((Connection conn) {
      conn.query(sqlSelect)..toList().then((List rows) {
        if(rows.length > 0) {
        request.response
          ..write(JSON.encode(
            rows.map((row) => new Address(
                                      row.id,
                                      row.street,
                                      row.suburb,
                                      row.city,
                                      row.postcode,
                                      row.latitude,
                                      row.longitude,
                                      row.visited
                                    )).toList()
          ))
          ..close();
        } else {
          send404(request);
        }
      });
    });
  };
}



Function modifyAddressJson(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    print("modifyAddressJson");
    request.response.headers.contentType = new ContentType(type, subType);
    HttpBodyHandler.processRequest(request).then((HttpBody body) {
      var path = request.requestedUri.path.split("/")
        ..removeWhere((item) => item.isEmpty);
      var id = int.parse(path[1]);
      var jsonStrData = body.body.toString();
      try {
        Map jsonData = JSON.decode(jsonStrData);
        List<String> keyVals = jsonData.map((key, val) => '$key="$val"');
        String updates = keyVals.join(",");
        var sqlUpdate = 'UPDATE address SET $updates WHERE id="$id";';
        pool.connect().then((Connection conn) {
          conn.execute(sqlUpdate).then((int rowsUpdated){
            var result = {'success': true, 'rowsUpdated': rowsUpdated};
            request.response
              ..write(JSON.encode(result))
              ..close()
              ;
          });
        });
      } catch(all) {

      }
    });
  };
}



Function deleteAddressJson(Pool pool) {
  var type = "application";
  var subType = "json";
  return (HttpRequest request) {
    print("deleteAddressJson");
    request.response.headers.contentType = new ContentType(type, subType);
    var path = request.requestedUri.path.split("/")
      ..removeWhere((item) => item.isEmpty);
    var id = int.parse(path[1]);

    var sqlDelete = "DELETE FROM address where id=$id;";
    pool.connect().then((Connection conn) {
      conn.execute(sqlDelete).then((int rowsDeleted){
        var result = {'success': true, 'rowsDeleted': rowsDeleted};
        request.response
          ..write(JSON.encode(result))
          ..close()
          ;
      });
    });
  };
}


num _earthRadius = 6371;

num get oneKmOfLatOrLng => radiansToDegrees(1/_earthRadius);

num degreesToRadians(num deg) {
  return deg * (Math.PI / 180);
}


num radiansToDegrees(num rad) {
  return rad / (Math.PI / 180);
}


//I think this is wrong somehow, but I'm keeping it for reference
//since, I was able to figure out the number of degrees 1 km is by reversing it
//using a math technique I learnt at school and Uni
num distance(double lat1, double lon1, double lat2, double lon2) {
  lat1 = degreesToRadians(lat1);
  lat2 = degreesToRadians(lat2);
  lon1 = degreesToRadians(lon1);
  lon2 = degreesToRadians(lon2);

  var R = 6371; // km
  var x = (lon2-lon1) * Math.cos((lat1+lat2)/2);
  var y = (lat2-lat1);
  var d = Math.sqrt(x*x + y*y) * R;

  return d;
}


