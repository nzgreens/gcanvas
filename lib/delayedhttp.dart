part of gcanvas.client;

class _Request extends Observable {
  String id;
  String url;
  String method;
  bool withCredentials;
  String responseType;
  String mimeType;
  Map<String, String> requestHeaders;
  var sendData;
  HttpRequest request;
  bool sent = false;

  _Request(this.id, this.url, {this.method, this.withCredentials,
    this.responseType, this.mimeType, this.requestHeaders,
    this.sendData});


  Map toMap() => {
    'id': id,
    'url': url,
    'method': method,
    'withCredentials': withCredentials,
    'responseType': responseType,
    'mimeType': mimeType,
    'requestHeaders': requestHeaders,
    'sendData': sendData
  };


  _Request.fromMap(Map map)
      : id = map['id'],
        url = map['url'],
        method = map['method'],
        withCredentials = map['withCredentials'],
        responseType = map['responseType'],
        mimeType = map['mimeType'],
        requestHeaders = map['requestHeaders'],
        sendData = map['sendData'];


  Future<HttpRequest> send() {

    Future<HttpRequest> future = HttpRequest.request(
                                                url,
                                                method: method,
                                                withCredentials: withCredentials,
                                                responseType: responseType,
                                                mimeType: mimeType,
                                                requestHeaders: requestHeaders,
                                                sendData: sendData
                                            );
    return future.then((req) {
      sent = true;
      request = req;
      return req;
    });
  }
}


final Store _store = new Store("http", "request_queue");
final StreamController<_Request> _controller = new StreamController<_Request>.broadcast();

/**
 * A way to handle the possibility of being offline, and still treating a
 * request in the same way. You can send a request, and if your online, it
 * will go through as normal.  However if you're offline, then the request will
 * still, as far as the caller is concerned, do the same thing.  Except, what is
 * actually happenning is it's being delayed, and the future will not be
 * completed till you're online again.  The request will still go through, even
 * if you close the app, as long as you create an instance of this class again.
 * The request is stored in the local browser database using lawndart.  The
 * instance will read all the stored requests, one by one, and try and send
 * them, next time it detects you're online.  the downside is that the futures
 * created for these orphan requests will not exist anymore.  No fear as there
 * is a stream that can be listened to, which will inform your app of every
 * request sent, by pushing the resulting request onto the stream.
 *
 * This was inspired by paradox (http://pub.dartlang.org/packages/paradox),
 * which did most of what I wanted, except there is no current way, yet, of
 * being informed of when the request is finally sent, and it couldn't be
 * treated like a regular HttpRequest.  This does the notification via a future
 * HttpRequests and a broadcast stream.
 */
class DelayedHttp extends Observable {
  final Store _httpRequestStore;
  final StreamController<_Request> _pollRequestController;
  //braodcast stream
  Stream get pollRequestStream => _pollRequestController.stream;
  bool forceOffline = false; //even if we're online, force it to treat it as if offline
  bool get isOnline => forceOffline ? false : window.navigator.onLine;
  final Uuid _uuid;

  DelayedHttp(this._httpRequestStore, this._pollRequestController, this._uuid);

  void _init() {
    new Timer.periodic(new Duration(seconds: 10), (_) {
      if(isOnline) {
        _openStore().then((opened) {
          if(opened) {
            _httpRequestStore.keys().listen((key) {
              _httpRequestStore.getByKey(key).then((map) {
                var request = new _Request.fromMap(map);
                request.send().then((_) {
                  _openStore().then((opened) {
                    if(opened) {
                      _httpRequestStore.removeByKey(request.id).then((_) {
                        _pollRequestController.add(request);
                      }).catchError((error) {
                        //@TODO: do something about this as this could cause some real problems
                        //though the likelyhood of this happenning is low
                      });
                    }
                  });
                });
              });
            });
          }
        });
      }
    });
  }


  /*I try and avoid globals, but this is an exception. I'll look at this again
   *later
   */
  factory DelayedHttp.create() {
    var paradox = new DelayedHttp(
        _store, //this helps make sure only on store is used throughout
        _controller, //same here
        new Uuid() //we don't care if this is a new instance.
    );

    paradox._init();

    return paradox;
  }


  Future<bool> _openStore() {
    Completer<bool> completer = new Completer<bool>();

    if(_httpRequestStore.isOpen) {
      completer.complete(true);
    } else {
      _httpRequestStore.open().then((_) {
        completer.complete(true);
      }).catchError((error) {
        print(error);
        completer.complete(false);
      });
    }

    return completer.future;
  }


  Future<HttpRequest> get(
      String url,
      { bool withCredentials,
        String responseType,
        String mimeType,
        Map<String, String> requestHeaders,
        sendData
      }) {

    String method = "GET";

    return _request(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData);
  }



  Future<HttpRequest> post(
      String url,
      { bool withCredentials,
        String responseType,
        String mimeType,
        Map<String, String> requestHeaders,
        sendData
      }) {

    String method = "POST";

    return _request(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData);
  }


  Future<HttpRequest> put(
      String url,
      { bool withCredentials,
        String responseType,
        String mimeType,
        Map<String, String> requestHeaders,
        sendData
      }) {

    String method = "PUT";

    return _request(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData);
  }



  Future<HttpRequest> delete(
      String url,
      { bool withCredentials,
        String responseType,
        String mimeType,
        Map<String, String> requestHeaders,
        sendData
      }) {

    String method = "DELETE";

    return _request(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData);
  }


  Future<HttpRequest> _request(
      String url,
      String method,
      bool withCredentials,
      String responseType,
      String mimeType,
      Map<String, String> requestHeaders,
      var sendData) {

    Completer<HttpRequest> completer = new Completer<HttpRequest>();

    if(isOnline) {
      HttpRequest.request(
          url,
          method: method,
          withCredentials: withCredentials,
          responseType: responseType,
          mimeType: mimeType,
          requestHeaders: requestHeaders,
          sendData: sendData).then((httpreq) {
            completer.complete(httpreq);
          }).catchError((_) {

          });
    } else {
      _delay(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData).then((httpreq) {
        completer.complete(httpreq);
      });
    }
    return completer.future;
  }


  Future<HttpRequest> _delay(
                    String url,
                    String method,
                    bool withCredentials,
                    String responseType,
                    String mimeType,
                    Map<String, String> requestHeaders,
                    var sendData) {
    Completer<HttpRequest> completer = new Completer<HttpRequest>();

    var id = _uuid.v1();

    StreamSubscription<_Request> subscription = pollRequestStream.listen((request) {
      if(request.id == id) {
        completer.complete(request.request);
      }
    });

    var request = new _Request(id, url, method: method, withCredentials: withCredentials,
      responseType: responseType, mimeType: mimeType, requestHeaders: requestHeaders,
      sendData: sendData);
    _openStore().then((opened) {
      if(opened) {
        _httpRequestStore.save(request.toMap(), id).catchError((error) {
          //if the local store can't be saved to, we're not going to succeed
          //@TODO: give a better error message relative to HttpRequest
          completer.completeError(error);
        });
      }
    });

    return completer.future.then((httpreq) {
      var future = subscription.cancel(); //this seems to work, we can't leave this running
      return httpreq;
    });
  }
}
