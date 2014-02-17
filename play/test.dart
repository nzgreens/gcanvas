import 'dart:html';
import 'package:gcanvas/gcanvas.dart';

main() {
  var sendBut = querySelector("#send");
  var outputEl = querySelector("#text");

  var paraHttp = new DelayedHttp.create();

  sendBut.onClick.listen((_) {
    var url = 'http://localhost:8888/test';
    var requestHeaders = {'Content-Type': 'application/x-www-form-urlencoded'};
    String data = 'msg=hi';
    paraHttp.post(url, requestHeaders: requestHeaders, sendData: data).then((httpreq) {
      outputEl.text += "${httpreq.statusText}";
    });
  });
}