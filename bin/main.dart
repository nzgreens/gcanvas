library gcanvas.server;

import 'dart:async';
import 'dart:io';
import 'package:route_hierarchical/server.dart';
//import 'package:route_hierarchical/url_pattern.dart';
import 'package:postgresql/postgresql.dart';
import 'package:postgresql/postgresql_pool.dart';
import 'package:mime/mime.dart';
import 'dart:math' as Math;
import 'dart:convert' show JSON;
import 'package:csvparser/csvparser.dart';
import 'package:http_server/http_server.dart';

import 'package:gcanvas/address.dart';

part 'dbsetup.dart';
part 'utils.dart';

//need these for the pattern matching like \d+ to work.
UrlPattern serveAddrMatch = new UrlPattern(r'/address/(\d+\.\d+)/(\d+\.\d)');
UrlPattern indivAddrMatch = new UrlPattern(r'/address/(\d+)');
UrlPattern serveAddrJsonMatch = new UrlPattern(r'/address');


main(args) {
  var password = Platform.environment['POSTGRESQL_PASSWORD'] == null ? 'gcanvasbkd7ffvf' : Platform.environment['POSTGRESQL_PASSWORD'];
  var postgres_uri = 'postgres://postgres:$password@localhost:5432/gcanvas';
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  //seems the max number here will stop some connections altogether rather than just delay, while waiting for a connection, as I expected.
  var pool = new Pool(postgres_uri, min: 2, max: 10);
  addressTableExists(pool).then((exists) {
    print("address: $exists");
    if (!exists) {
      createAddressTable(pool).then((success) {
        print("created address: $success");
      });
    }
  });

  questionScriptResponseTableExists(pool).then((exists) {
    print("question_script_response: $exists");
    if (!exists) {
      createQuestionScriptResponseTable(pool).then((success) {
        print("created question_script response: $success");
      });
    }
  });


  questionScriptTableExists(pool).then((exists) {
    print("question_script: $exists");
    if (!exists) {
      createQuestionScriptTable(pool).then((success) {
        print("created question_script: $success");
      });
    }
  });


  residentResponseProxyTableExists(pool).then((exists) {
    print("resident_response_proxy: $exists");
    if (!exists) {
      createResidentResponseProxyTable(pool).then((success) {
        print("created resident_response_proxy: $success");
      });
    }
  });


  residentResponseTableExists(pool).then((exists) {
    print("resident_response: $exists");
    if (!exists) {
      createResidentResponseTable(pool).then((success) {
        print("created resident_response: $success");
      });
    }
  });


  residentTableExists(pool).then((exists) {
    print("resident: $exists");
    if (!exists) {
      createResidentTable(pool).then((success) {
        print("created resident: $success");
      });
    }
  });

  HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((HttpServer server) {
    print("Listening on address ${server.address.address}:${port}" );
    String buildBaseDir = "build/web";
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
          ..serve(r'/address/csv', method: 'post'.toUpperCase()).listen(uploadAddressesCsv(pool))
          ..serve(serveAddrMatch).listen(serveAddresses(pool))
          ..serve(serveAddrJsonMatch, method: 'get'.toUpperCase()).listen((getAddressesJson(pool)))
          ..serve(serveAddrJsonMatch, method: 'post'.toUpperCase()).listen((uploadAddressesJson(pool)))
          ..serve(indivAddrMatch, method: 'get'.toUpperCase()).listen((getAddressJson(pool)))
          ..serve(indivAddrMatch, method: 'put'.toUpperCase()).listen((modifyAddressJson(pool)))
          ..serve(indivAddrMatch, method: 'delete'.toUpperCase()).listen((deleteAddressJson(pool)))
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