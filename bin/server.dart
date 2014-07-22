library gcanvas.server;

import 'dart:async';
import "dart:typed_data";
import 'dart:math';
import 'dart:convert';

import 'dart:io';
import 'package:route/server.dart';
import 'package:http_server/http_server.dart';
import 'package:google_cloud_datastore/datastore.dart';
import "package:cipher/cipher.dart";
import "package:cipher/impl/base.dart";
import 'package:oauth2/oauth2.dart' as oauth2;

part 'models.dart';
part 'utility.dart';
part 'account_manager.dart';
part 'route_handler.dart';


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
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);
  runZoned(() {
    HttpServer.bind(InternetAddress.ANY_IP_V6, port).then((HttpServer server) {
      print("Listening on address ${server.address.address}:${port} which env says is ${Platform.environment['PORT']}" );
      String buildBaseDir = args.length > 0 ? args[0] : "build/web";
      String packageBaseDir = ".";
      new Directory(buildBaseDir).exists().then((exists) {
        if(exists) {
          Router router = setupRouter(server);
          serveFiles(router.defaultStream, buildBaseDir);


        } else {
          setupRouter(server);
          /*new Router(server)
          ..serve('/').listen((request) {
            request.response
              ..write("Something went wrong, the ${buildBaseDir} directory can't be found")
              ..close();
          });*/
        }
      });
    });
  },
  onError: print
  );
}


main(List<String> args) {
  initCipher();
  var digest = new Digest("MD5");
  new OAuth2Handler.create("client_id", "client_secret", "client_name", "http://redirect_url", "http://access_token_url", "https://authorise_url", "http://base_url");
  run(args);
}