part of gcanvas.server;

// library gcanvas.server.db;

// import 'dart:async';
// import 'package:postgresql/postgresql.dart';
// import 'package:postgresql/postgresql_pool.dart';

Map<String, Function> _tables => {
  "address": createAddressTable,
  "resident": createResidentTable,
  "resident_response": createResidentResponseTable,
  "resident_response_proxy": createResidentResponseProxyTable,
  "question_script": createQuestionScriptTable,
  "question_script_response": createQuestionScriptResponseTable

};

String get
  _createAddressSQL =>
  "CREATE TABLE address (id SERIAL, street text,"
  "suburb text, city text, postcode text, meshblock int,"
  "electorate int, latitude float, longitude float, visited boolean);";

String get _createResidentSQL =>
    "CREATE TABLE resident (id int, title text, firstname text,"
    "middlenames text, lastname text, occupation text, gender text,"
    "address_id int);";


String get _createResidentResponseSQL =>
    "CREATE TABLE resident_response (id SERIAL, response text, reason text,"
    "addressId int);";

String get _createResidentResponseProxySQL =>
    "CREATE TABLE resident_response_proxy (residentId int,"
    "resident_response int);";


String get _createQuestionScriptSQL =>
    "CREATE TABLE question_script (id SERIAL, issued timestamp,"
    "current boolean, json_script text);"; //script is meant to be json


String get _createQuestionScriptResponseSQL =>
    "CREATE TABLE question_script_response (id SERIAL, answered timestamp,"
    "resident_response_id int, json_ressult text);";



Future<bool> _tableExists(DBConnection conn, String dbName, String tablename) {
  Completer<bool> completer = new Completer<bool>();
  var sql = "SELECT EXISTS(SELECT 1 FROM information_schema.tables "
      " WHERE table_catalog='$dbName' AND"
      " table_schema='public' AND "
      " table_name='$tablename');";

  conn.query(sql).then((rows) {
    completer.complete(rows.length == 1 && rows[0][0] == true);
  });

  return completer.future;
}


Future<bool> addressTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'address');
}


Future<bool> createAddressTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createAddressSQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table address exists"));

  return completer.future;
}


Future<bool> residentTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'resident');
}


Future<bool> createResidentTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createResidentSQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table resident exists"));

  return completer.future;
}


Future<bool> residentResponseTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'resident_response');
}


Future<bool> createResidentResponseTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createResidentResponseSQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table resident_response exists"));

  return completer.future;
}


Future<bool> residentResponseProxyTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'resident_response_proxy');
}


Future<bool> createResidentResponseProxyTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createResidentResponseProxySQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table resident_response_proxy exists"));

  return completer.future;
}


Future<bool> questionScriptTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'question_script');
}


Future<bool> createQuestionScriptTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createQuestionScriptSQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table question_script exists"));

  return completer.future;
}


Future<bool> questionScriptResponseTableExists(DBConnection conn, String dbName) {
  return _tableExists(conn, dbName, 'question_script_response');
}


Future<bool> createQuestionScriptResponseTable(DBConnection conn, String dbName) {
  Completer<bool> completer = new Completer<bool>();
  conn.execute(_createQuestionScriptResponseSQL).then((result) {
    addressTableExists(conn, dbName).then((exists) {
      completer.complete(exists);
    });
  }, onError: () => print("table question_script_response exists"));

  return completer.future;
}





Future<int> massInsertOfAddresses(DBConnection conn, List<Map> addresses) {
  Completer<int> completer = new Completer<int>();

  var massInsertData = addresses.map((Map addressMap) {
    return '("${addressMap['street']}","${addressMap['suburb']}","${addressMap['city']}","${addressMap['postcode']}","${addressMap['latitude']}","${addressMap['longitude']}","${addressMap['visited']}")';
  }).toList();

  //prepare the statement
  var sqlInsert = "INSERT INTO address (street,suburb,city,postcode,latitude,longitude,visited) VALUES ${massInsertData.join(",")};";

  //wait till we have the data in the format we want before opening a connection
    conn
      ..execute(sqlInsert).then((int rowsAdded){
        completer.complete(rowsAdded);
      });

  return completer.future;
}


Future<Map> fetchAddresses() {
  Completer<Map> completer = new Completer<Map>();

  HttpClient client = new HttpClient();
  client
    ..addCredentials(Uri.parse(externalAddressSrc), "", new HttpClientDigestCredentials(username, password))
    ..getUrl(Uri.parse(externalAddressSrc))
      .then((HttpClientRequest request) {
        // Prepare the request then call close on it to send it.
        return request.close();
      })
      .then((HttpClientResponse response) {
        // Process the response.
        if(response.statusCode == 200) {
          response.listen((data) {
            completer.complete(JSON.decode(data));
          });
        }
      });

  return completer.future;
}


Future<int> populateTables(
    DBConnection conn,
    {
      Future<Map> fetchCallback(): fetchAddresses,
      Future<int> insertCallback(DBConnection conn, List<Map> addresses): massInsertOfAddresses
    }
    ) {
  Completer<int> completer = new Completer<int>();

  fetchCallback().then((addresses) {
    insertCallback(conn, addresses).then((rowsAdded) {
      completer.complete(rowsAdded);
    });
  });

  return completer.future;
}


void resetDB(DBConnection conn) {
  _tables.forEach((table, createTable) {
    String sql = "DROP TABLE $table;";
    conn.execute(sql).then((_) {
      createTable(conn, conn.dbName);
    });
  });
}