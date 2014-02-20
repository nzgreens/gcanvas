part of gcanvas.server;

// library gcanvas.server.db;

// import 'dart:async';
// import 'package:postgresql/postgresql.dart';
// import 'package:postgresql/postgresql_pool.dart';

String get 
  _createAddressSQL =>
  "CREATE TABLE address (id SERIAL, street text,"
  " suburb text, city text, postcode text,"
  " latitude float, longitude float, visited boolean);";


String get _createResidentSQL =>
    "CREATE TABLE resident (id SERIAL,firstname text, lastname text, dob date,"
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



Future<bool> _tableExists(Pool pool, String tablename) {
  Completer<bool> completer = new Completer<bool>();
  var sql = "SELECT EXISTS(SELECT 1 FROM information_schema.tables "
      " WHERE table_catalog='gcanvas' AND"
      " table_schema='public' AND "
      " table_name='$tablename');";

  pool.connect().then((Connection conn) {
    conn.query(sql).toList().then((rows) {
      completer.complete(rows.length == 1 && rows[0][0] == true);
    });
  }).catchError((error) {
    print(error);
  });

  return completer.future;
}


Future<bool> addressTableExists(Pool pool) {
  return _tableExists(pool, 'address');
}


Future<bool> createAddressTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createAddressSQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}


Future<bool> residentTableExists(Pool pool) {
  return _tableExists(pool, 'resident');
}


Future<bool> createResidentTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createResidentSQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}


Future<bool> residentResponseTableExists(Pool pool) {
  return _tableExists(pool, 'resident_response');
}


Future<bool> createResidentResponseTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createResidentResponseSQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}


Future<bool> residentResponseProxyTableExists(Pool pool) {
  return _tableExists(pool, 'resident_response_proxy');
}


Future<bool> createResidentResponseProxyTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createResidentResponseProxySQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}


Future<bool> questionScriptTableExists(Pool pool) {
  return _tableExists(pool, 'question_script');
}


Future<bool> createQuestionScriptTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createQuestionScriptSQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}


Future<bool> questionScriptResponseTableExists(Pool pool) {
  return _tableExists(pool, 'question_script_response');
}


Future<bool> createQuestionScriptResponseTable(Pool pool) {
  Completer<bool> completer = new Completer<bool>();
  pool.connect().then((Connection conn) {
    conn.execute(_createQuestionScriptResponseSQL).then((result) {
      addressTableExists(pool).then((exists) {
        completer.complete(exists);
      });
    });
  });

  return completer.future;
}
