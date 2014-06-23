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


  Future<bool> sync() {
    Completer<bool> completer = new Completer<bool>();

    var addresses = {};

    var responseType = 'application/json';
    if(detect.browser.isSafari) {
      responseType = "";  //Only needed for Safari, other browsers are sain
    }
    _http.get('json/people.json').then((HttpRequest request) {
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
        } });
    });

    return completer.future;
  }
}