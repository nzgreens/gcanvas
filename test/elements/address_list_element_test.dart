part of gcanvas_test;


class AddressListItemComponent extends PageComponent {
  AddressListItemComponent(el) : super(el);

  String get currentStreetDisplay => el.$['address1'].text;
  String get currentSuburbDisplay => el.$['address2'].text;
}


class AddressListComponent extends PageComponent {

  AddressListComponent(el) : super(el);

  List<AddressListItemComponent> get addressListItemComponents => new PolymerDom(el.root).querySelectorAll('address-list-item').map((item) => new AddressListItemComponent(item)).toList();
}


class ResidentViewComponent extends PageComponent {
  ResidentViewComponent(el) : super(el);

  Future click() {
    el.click();

    return flush();
  }

  String get currentFirstnameDisplay => new PolymerDom(el.root).querySelector("#firstname").text;
  String get currentLastnameDisplay => new PolymerDom(el.root).querySelector("#lastname").text;

  String get currentStyleBorderDisplay => el.style.border;
}


class AddressViewComponent extends PageComponent {
  AddressViewComponent(el) : super(el);

  Future<String> get currentStreetDisplay async {
    var completer = new Completer();
    el.async(() => completer.complete());
    await completer.future;
    PolymerElement address1 = new PolymerDom(el.root).querySelector('#address1');
    if (address1 != null) {
      return address1.text;
    }

    return el.root.toString();
  }
  String get currentSuburbDisplay => new PolymerDom(el.root).querySelector('#address2').text;
  String get currentCityDisplay => new PolymerDom(el.root).querySelector('#city').text;
  String get currentPostcodeDisplay => new PolymerDom(el.root).querySelector('#postcode').text;

  List<ResidentViewComponent> get currentResidentComponents => new PolymerDom(el.root).querySelectorAll('resident-view').map((item) => new ResidentViewComponent(item)).toList();

  Future flush() {
    return super.flush().then((_) {
      Completer completer = new Completer();
      PolymerElement residentView = new PolymerDom(this.el.root).querySelector("resident-view");
      if(residentView != null) {
        residentView.async(() {
          completer.complete();
        });
      } else {
        completer.complete();
      }

      return completer.future;
    });
  }
}



void address_list_element_test() {
  group("[address-list-item]", () {
    AddressListItemComponent listitem;
    var address = new Address.create(id: '1', address1: '1234 Somestreet street', address2: 'somesuburb');
    setUp(() {
      PolymerElement el = createElement('<address-list-item></address-list-item>');
      el.address = address;
      document.body.append(el);
      listitem = new AddressListItemComponent(el);

      return listitem.flush();
    });


    tearDown(() => listitem.el.remove());


    test("document contains element", () {
      schedule(() async {
          expect(querySelector("address-list-item"), isNotNull);
          await listitem.flush();
        });
    });

    test("contains street", () {
      schedule(() {
        expect(listitem.currentStreetDisplay, equals(address.address1));
      });
    });


    test("contains suburb", () {
      schedule(() {
        expect(listitem.currentSuburbDisplay, equals(address.address2));
      });
    });
  });



  group("[address-list]", () {
    AddressListComponent listcomp;
    var addresses = [new Address.create(id: '1', address1: '1234 Somestreet street', address2: 'somesuburb'), new Address.create(id: '2', address1: '5678 Somestreet street', address2: 'somesuburb2')];
    setUp(() {
      PolymerElement el = createElement('<address-list></address-list>');
      el.addresses = addresses;
      document.body.append(el);
      listcomp = new AddressListComponent(el);

      return listcomp.flush();
    });


    tearDown(() => listcomp.el.remove());

    test("address item count is 2", () {
      schedule(() {expect(listcomp.addressListItemComponents.length, equals(addresses.length));});
      schedule(() {expect(listcomp.addressListItemComponents[0].currentStreetDisplay, equals(addresses[0].address1));});
    });


    test("1st address item details are correct", () {
      schedule(() {expect(listcomp.addressListItemComponents[0].currentStreetDisplay, equals(addresses[0].address1));});
      schedule(() {expect(listcomp.addressListItemComponents[0].currentSuburbDisplay, equals(addresses[0].address2));});
    });


    test("2nd address item details are correct", () {
      schedule(() {expect(listcomp.addressListItemComponents[1].currentStreetDisplay, equals(addresses[1].address1));});
      schedule(() {expect(listcomp.addressListItemComponents[1].currentSuburbDisplay, equals(addresses[1].address2));});
    });

  });


  group("[address-view]", () {
    AddressViewComponent view;
    var residents = [new Resident.create(id: 1, title: 'Mr', firstname: 'Jim', lastname: 'Jimbo'), new Resident.create(id: 1, title: 'Mrs', firstname: 'Kim', lastname: 'Jimbo')];
    var address = new Address.create(id: '1', address1: '1234 Somestreet street', address2: 'somesuburb', residents: residents);

    setUp(() {
      PolymerElement el = createElement('<address-view></address-view>');
      el.address = address;
      document.body.append(el);
//        el.shadowRoot.querySelector("resident-view").async((_) {
//          completer.complete();
//        });
      view = new AddressViewComponent(el);

      return view.flush();
    });

    tearDown(() => view.el.remove());


    test("address details correct", () {
      schedule(() {expect(view.currentStreetDisplay, equals(address.address1));});
      schedule(() {expect(view.currentSuburbDisplay, equals(address.address2));});
      schedule(() {expect(view.currentCityDisplay, equals(address.city));});
      schedule(() {expect(view.currentPostcodeDisplay, equals(address.postcode));});
    });


    test("number of residents is 2", () {
      schedule(() {expect(view.currentResidentComponents.length, equals(residents.length));});
    });


    test("1st resident details are correct", () {
      schedule(() {expect(view.currentResidentComponents[0].currentFirstnameDisplay, equals(residents[0].firstname));});
      schedule(() {expect(view.currentResidentComponents[0].currentLastnameDisplay, equals(residents[0].lastname));});
    });


    test("2nd resident details are correct", () {
      schedule(() {expect(view.currentResidentComponents[1].currentFirstnameDisplay, equals(residents[1].firstname));});
      schedule(() {expect(view.currentResidentComponents[1].currentLastnameDisplay, equals(residents[1].lastname));});
    });
  });



  group("[resident-view]", () {
    ResidentViewComponent view;
    var address = new Address.create(id: '1', address1: '1234 Somestreet street', address2: 'somesuburb');
    var resident = new Resident.create(id: 1, title: 'Mr', firstname: 'Jim', lastname: 'Jimbo');
    var selectedStyle = "5px solid green";
    var deselectedStyle = "1px solid blue";

    setUp(() {
      PolymerElement el = createElement("<resident-view></resident-view>");
      el.resident = resident;
      document.body.append(el);
      view = new ResidentViewComponent(el);

      return view.flush();
    });

    tearDown(() => view.el.remove());

    test("resident details are correct", () {
      schedule(() {expect(view.currentFirstnameDisplay, equals(resident.firstname));});
      schedule(() {expect(view.currentLastnameDisplay, equals(resident.lastname));});
    });



    test("click selects and deselects view", () {
      schedule(() {view.click();});
      schedule(() {expect(view.currentStyleBorderDisplay, equals(selectedStyle));});
      schedule(() {view.click();});
      schedule(() {expect(view.currentStyleBorderDisplay, equals(deselectedStyle));});
    });


    test("is deselected", () {
      schedule(() {expect(view.currentStyleBorderDisplay, equals(deselectedStyle));});
    });
  });
}
