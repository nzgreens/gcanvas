library gcanvas.server;

import 'dart:async';
import 'dart:io';
import 'package:route/server.dart';
import 'package:mime/mime.dart';
import 'dart:math' as Math;
import 'dart:convert' show JSON;
import 'package:csvparser/csvparser.dart';
import 'package:http_server/http_server.dart';

import 'package:gcanvas/address.dart';

import 'dbconnection.dart';

part 'utils.dart';


//need these for the pattern matching like \d+ to work.
UrlPattern serveAddrMatch = new UrlPattern(r'/address/(-?\d+\.\d+)/(\d+\.\d+)');
UrlPattern indivAddrMatch = new UrlPattern(r'/address/(\d+)');
UrlPattern serveAddrJsonMatch = new UrlPattern(r'/address');

Router setupRouter(HttpServer server, DBConnection conn) {
  Router router = new Router(server)
    ..serve(serveAddrMatch).listen(serveAddresses(conn))
    ..serve(serveAddrJsonMatch, method: 'get'.toUpperCase()).listen((getAddressesJson(conn)))
    ..serve(indivAddrMatch, method: 'get'.toUpperCase()).listen((getAddressJson(conn)))
    ;

  return router;
}


void serveFiles(Stream<HttpRequest> defaultStream, String buildBaseDir) {
  var virDir = new VirtualDirectory(buildBaseDir);

  virDir
    ..jailRoot = false
    ..allowDirectoryListing = true
    ..directoryHandler = serveDirectory(virDir)
    ..errorPageHandler = errorPageHandler
    // Serve everything not routed elsewhere through the virtual directory.
    ..serve(defaultStream);
}


errorPageHandler(HttpRequest request) {
  //log.warning("Resource not found ${request.uri.path}");
  request.response.statusCode = HttpStatus.NOT_FOUND;
  request.response.close();
}


serveDirectory(var virDir) {
  return(dir, request) {
    // Redirect directory-requests to index.html files.
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    virDir.serveFile(new File(indexUri.toFilePath()), request);
  };
}

run(args) {
  var postgres_uri = Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'] == null ? 'postgres://postgres:gcanvasbkd7ffvf@localhost:5432/gcanvas' : Platform.environment['HEROKU_POSTGRESQL_CHARCOAL_URL'];

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


  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((HttpServer server) {
    print("Listening on address ${server.address.address}:${port}" );
    String buildBaseDir = args.length > 0 ? args[0] : "build/web";
    String packageBaseDir = ".";
    new Directory(buildBaseDir).exists().then((exists) {
      if(exists) {
        Router router = setupRouter(server, conn);

        serveFiles(router.defaultStream, buildBaseDir);


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

main(List<String> args) {
  new Timer(new Duration(seconds: 10), () => run(args));
}