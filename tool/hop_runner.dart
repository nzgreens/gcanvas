library hop_runner;

import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:hop/src/tasks_shared.dart';

import '../bin/dbconnection.dart';

void main(List<String> args) {
  addTask('build', createBuildTask());
  addTask('reset-db', createResetDBTask());
  runHop(args);
}

Task createHelloHopTask() {
  return new Task((TaskContext ctx) {
    ctx.info(ctx.arguments.rest.toString());
  });
}

Task createAnotherHopTask() {
  return new Task((TaskContext ctx) {
    String path = ctx.arguments.rest.first;
    File f = new File(path);
    f.openWrite();
    f.writeAsStringSync("main() => print('Hello Hop!');");
    ctx.info("created $path");
    return true;
  });
}


Task createBuildTask() {
  var pub = getPlatformBin('pub');

  return createProcessTask('$pub', args: ['build']);
}


Task createResetDBTask() {
  return new Task((TaskContext ctx) {
    DBConnection conn = new DBConnection();
    
    resetDB(conn);
  });
}
