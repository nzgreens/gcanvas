part of gcanvas.client;

@reflectable
class SyncCtrl {
  final Http _http;
  final AddressListCtrl _addrListCtrl;

  SyncCtrl(this._http, this._addrListCtrl);


  factory SyncCtrl.create({Http http, AddressListCtrl ctrl}) {
    http = http != null ? http : new Http();
    ctrl = ctrl != null ? ctrl : new AddressListCtrl.create();

    return new SyncCtrl(http, ctrl);
  }


  /**
   * This is about uploading updated voters details, if any exist, and
   * download a new list of people.  Each persons details downloaded has their
   * address. Using this address as a key to a dictionary, adds each person to
   * the dictionary, using the address as the dictionary key.  This way we can
   * create a list of addresses, which contain a list of it's residents.
   */
  Future<bool> sync() {
    return _upload().then((result) {
      if(result == true) {
        return _download();
      }

      return new Future.value(false);
    });
  }

  Future<bool> _download() {
    Completer<bool> completer = new Completer<bool>();

    var addresses = {};

    _http.get('/json/people.json').then((HttpRequest request) {
      var people = JSON.decode(request.response);
      people['results'].forEach((Map item) {
        var id = item['id'];
        var firstname = item['first_name'];
        var lastname = item['last_name'];
        var occupation = item['occupation'];
        var gender = item['sex'];
        var dob = DateTime.parse(item['birthdate']);
        var notes = item['note'];
        var email = item['email'];
        var phone = item['phone'];

        var resident = new Resident.create(id: id, firstname: firstname, lastname: lastname, occupation: occupation, gender: gender, dob: dob, notes: notes, email: email, phone: phone);

        var addr = item['primary_address'];
        var latitude = addr['lat'];
        var longitude = addr['lng'];
        var address1 = addr['address1'];
        var address2 = addr['address2'];
        var address3 = addr['address3'];
        var city = addr['city'];
        var postcode = addr['zip'];
        if(!addresses.containsKey("$latitude,$longitude,$address1,$address2,$address3,$city")) {

          Address address = new Address.create(id: "$latitude,$longitude,$address1,$address2,$address3,$city", address1: address1, address2: address2, address3: address3, city: city, postcode: postcode, latitude: latitude, longitude: longitude, residents: [resident]);
          addresses["$latitude,$longitude,$address1,$address2,$address3,$city"] = address;
        } else {
          Address address = addresses["$latitude,$longitude,$address1,$address2,$address3,$city"];
          address.residents.add(resident);
        }
      });

      int count = 0;
      addresses.values.forEach((address) => _addrListCtrl.add(address).then((_) => count++));

      Timer timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
        if(count == addresses.length) {
          completer.complete(request.readyState == 200);
          timer.cancel();
        }
      });
    });

    return completer.future;
  }


  Future<bool> _upload() {
    Completer<bool> completer = new Completer<bool>();

    _addrListCtrl.getList().then((addresses) {
      if(addresses.length > 0) {
        var residents = addresses.map((address) => address.residents.map((resident) => resident.toMap())).expand((resident) => resident).toList();
        var data = JSON.encode(residents);
        _http.post('/json/residents', sendData: data).then((request) {
          completer.complete(request.readyState == 200);
        });
      } else {
        completer.complete(true);
      }
    });

    return completer.future;
  }
}