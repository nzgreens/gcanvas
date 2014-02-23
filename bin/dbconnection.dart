library gcanvas.db.connection;

import 'dart:io' show Platform;
import 'dart:async' show Future, Completer;
import 'package:postgresql/postgresql_pool.dart';


class DBConnection {
  Pool _pool;
  String dbName;

  DBConnection() {
    var postgres_uri = Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'] == null ? 'postgres://postgres:gcanvasbkd7ffvf@localhost:5432/gcanvas' : Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'];
    dbName = postgres_uri.split('/').last;
    _pool = new Pool(postgres_uri, min: 2, max: 10);
  }


  factory DBConnection.create() {
    return new DBConnection();
  }


  Future<int> execute(String sql) {
    Completer<int> completer = new Completer<int>();

    _pool.connect().then((conn){
      conn
        ..execute(sql).then((affected) {
          completer.complete(affected);
        })
        ..close();
    });

    return completer.future;
  }



  Future<List> query(String sql) {
    Completer<List> completer = new Completer<List>();

    _pool.connect().then((conn) {
      conn
        ..query(sql).toList().then((results) {
          completer.complete(results);
        })
        ..close();
    });

    return completer.future;
  }

}
