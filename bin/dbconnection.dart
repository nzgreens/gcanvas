library gcanvas.server.db;

import 'dart:io' show Directory, FileSystemEntity, File, Platform, HttpClient, HttpClientDigestCredentials, HttpClientRequest, HttpClientResponse;
import 'dart:convert' show JSON;
import 'dart:async' show Future, Completer;
import 'dart:math' as Math;
import 'package:postgresql/postgresql_pool.dart';
import 'package:gcanvas/address.dart' show Address;


part 'dbquery.dart';
part 'dbsetup.dart';

var externalAddressSrc = '/assets/gcanvas/addresses.json';
var username = "";
var password = "";



class DBConnection {
  Pool _pool;
  String dbName;

  DBConnection() {
    var postgres_uri = Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'] == null ? 'postgres://postgres:gcanvasbkd7ffvf@localhost:5432/gcanvas' : Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'];
    dbName = postgres_uri.split('/').last;

    _pool = new Pool(postgres_uri, min: 2, max: 5);
  }


  factory DBConnection.create() {
    return new DBConnection();
  }


  Future<int> execute(String sql, [values]) {
    Completer<int> completer = new Completer<int>();

    _pool.connect().then((conn){
      conn
        ..execute(sql, values).then((affected) {
          completer.complete(affected);
        }).then((_) => conn.close());
        //..close();
    }, onError: (error) {
      completer.complete(-1);
      print ("Error executing SQL: $error");
    });

    return completer.future;
  }



  Future<List> query(String sql, [values]) {
    Completer<List> completer = new Completer<List>();

    _pool.connect().then((conn) {
      conn
        ..query(sql, values).toList().then((results) {
          completer.complete(results);
        }).then((_) => conn.close());
    }, onError: (error) {
      completer.complete([]);
      print("Error making query: $error");
    });

    return completer.future;
  }
}
