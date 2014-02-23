library gcanvas.server;

import 'dart:async';
import 'dart:io';
import 'package:route/server.dart';
//import 'package:route_hierarchical/url_pattern.dart';
import 'package:postgresql/postgresql.dart';
import 'package:postgresql/postgresql_pool.dart';
import 'package:mime/mime.dart';
import 'dart:math' as Math;
import 'dart:convert' show JSON;
import 'package:csvparser/csvparser.dart';
import 'package:http_server/http_server.dart';

import 'package:gcanvas/address.dart';

import 'dbconnection.dart';

part 'dbsetup.dart';
part 'utils.dart';

var externalAddressSrc = "";
var username = "";
var password = "";

//need these for the pattern matching like \d+ to work.
UrlPattern serveAddrMatch = new UrlPattern(r'/address/(-?\d+\.\d+)/(\d+\.\d+)');
UrlPattern indivAddrMatch = new UrlPattern(r'/address/(\d+)');
UrlPattern serveAddrJsonMatch = new UrlPattern(r'/address');


main(List<String> args) {
  var postgres_uri = Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'] == null ? 'postgres://postgres:gcanvasbkd7ffvf@localhost:5432/gcanvas' : Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'];
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  //seems the max number here will stop some connections altogether rather than just delay, while waiting for a connection, as I expected.
  var conn = new DBConnection();
  String dbName = postgres_uri.split('/').last;
  addressTableExists(conn, dbName).then((exists) {
    print("address: $exists");
    if (!exists) {
      createAddressTable(conn, dbName).then((success) {
        print("created address: $success");
      });
    }
  });

  questionScriptResponseTableExists(conn, dbName).then((exists) {
    print("question_script_response: $exists");
    if (!exists) {
      createQuestionScriptResponseTable(conn, dbName).then((success) {
        print("created question_script response: $success");
      });
    }
  });


  questionScriptTableExists(conn, dbName).then((exists) {
    print("question_script: $exists");
    if (!exists) {
      createQuestionScriptTable(conn, dbName).then((success) {
        print("created question_script: $success");
      });
    }
  });


  residentResponseProxyTableExists(conn, dbName).then((exists) {
    print("resident_response_proxy: $exists");
    if (!exists) {
      createResidentResponseProxyTable(conn, dbName).then((success) {
        print("created resident_response_proxy: $success");
      });
    }
  });


  residentResponseTableExists(conn, dbName).then((exists) {
    print("resident_response: $exists");
    if (!exists) {
      createResidentResponseTable(conn, dbName).then((success) {
        print("created resident_response: $success");
      });
    }
  });


  residentTableExists(conn, dbName).then((exists) {
    print("resident: $exists");
    if (!exists) {
      createResidentTable(conn, dbName).then((success) {
        print("created resident: $success");
      });
    }
  });


  HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((HttpServer server) {
    print("Listening on address ${server.address.address}:${port}" );
    String buildBaseDir = args.length > 0 ? args[0] : "build/web";
    String packageBaseDir = ".";
    new Directory(buildBaseDir).exists().then((exists) {
      if(exists) {
        //method is in ALL CAPS and is not forgiving of lowercase
        new Router(server)
          ..serve(r'/').listen(serveFile('${buildBaseDir}/index.html'))
          ..serve(r'/packages/shadow_dom/shadow_dom.debug.js').listen(serveFile('${packageBaseDir}/packages/shadow_dom/shadow_dom.debug.js'))
          ..serve(r'/packages/custom_element/custom-elements.debug.js').listen(serveFile('${packageBaseDir}/packages/custom_element/custom-elements.debug.js'))
          ..serve(r'/packages/browser/interop.js').listen(serveFile('${buildBaseDir}/packages/browser/interop.js'))
          ..serve(r'/index.html_bootstrap.dart.js').listen(serveFile('${buildBaseDir}/index.html_bootstrap.dart.js'))
          ..serve(r'/assets/gcanvas/images/rotate2.png').listen(serveFile('${buildBaseDir}/assets/gcanvas/images/rotate2.png'))
          ..serve(r'/assets/gcanvas/images/controls1.png').listen(serveFile('${buildBaseDir}/assets/gcanvas/images/controls1.png'))
          ..serve(r'/address/csv', method: 'post'.toUpperCase()).listen(uploadAddressesCsv(conn))
          ..serve(serveAddrMatch).listen(serveAddresses(conn))
          ..serve(serveAddrJsonMatch, method: 'get'.toUpperCase()).listen((getAddressesJson(conn)))
          //..serve(serveAddrJsonMatch, method: 'post'.toUpperCase()).listen((uploadAddressesJson(conn)))
          ..serve(indivAddrMatch, method: 'get'.toUpperCase()).listen((getAddressJson(conn)))
          //..serve(indivAddrMatch, method: 'put'.toUpperCase()).listen((modifyAddressJson(conn)))
          //..serve(indivAddrMatch, method: 'delete'.toUpperCase()).listen((deleteAddressJson(conn)))
          ..defaultStream.listen(serve404);
          ;
      } else {
        new Router(server)
        ..serve('/').listen((request) {
          request.response
            ..write("Something went wrong, the ${buildBaseDir} directory can't be found")
            ..close();
        });
      }
    });
  });
}