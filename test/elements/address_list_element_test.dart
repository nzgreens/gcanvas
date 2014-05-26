part of gcanvas_test;


class AddressListItemComponent extends PageComponent {
  AddressListItemComponent(el) : super(el);

  String get currentStreetDisplay => el.$['street'].text;
  String get currentSuburbDisplay => el.$['suburb'].text;
}


class AddressListComponent extends PageComponent {

  AddressListComponent(el) : super(el);

  List<AddressListItemComponent> get addressListItemComponents => el.shadowRoot.querySelectorAll('address-list-item').map((item) => new AddressListItemComponent(item)).toList();
}


class ResidentViewComponent extends PageComponent {
  ResidentViewComponent(el) : super(el);

  Future click() {
    el.click();

    return flush();
  }

  String get currentFirstnameDisplay => el.shadowRoot.querySelector("#firstname").text;
  String get currentLastnameDisplay => el.shadowRoot.querySelector("#lastname").text;

  String get currentStyleBorderDisplay => el.style.border;
}


class AddressViewComponent extends PageComponent {
  AddressViewComponent(el) : super(el);

  String get currentStreetDisplay => el.shadowRoot.querySelector('#street').text;
  String get currentSuburbDisplay => el.shadowRoot.querySelector('#suburb').text;
  String get currentCityDisplay => el.shadowRoot.querySelector('#city').text;
  String get currentPostcodeDisplay => el.shadowRoot.querySelector('#postcode').text;

  List<ResidentViewComponent> get currentResidentComponents => el.shadowRoot.querySelectorAll('resident-view').map((item) => new ResidentViewComponent(item)).toList();

  Future flush() {
    return super.flush().then((_) {
      Completer completer = new Completer();
      el.shadowRoot.querySelector("resident-view").async((_) {
        completer.complete();
      });

      return completer.future;
    });
  }
}



void address_list_element_test() {
  group("[address-list-item]", () {
    AddressListItemComponent listitem;
    var address = new Address.create(id: 1, street: '1234 Somestreet street', suburb: 'somesuburb');
    setUp(() {
      schedule(() {
        PolymerElement el = createElement('<address-list-item></address-list-item>');
        el.address = address;
        document.body.append(el);
        listitem = new AddressListItemComponent(el);

        return listitem.flush();
      });
      currentSchedule.onComplete.schedule(() => listitem.el.remove());


    });




    test("document contains element", () {
      schedule(() {
          expect(querySelector("address-list-item"), isNotNull);
          return listitem.flush();
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
    var addresses = [new Address.create(id: 1, street: '1234 Somestreet street', suburb: 'somesuburb'), new Address.create(id: 2, street: '5678 Somestreet street', suburb: 'somesuburb2')];
    setUp(() {
      schedule(() {
        PolymerElement el = createElement('<address-list></address-list>');
        el.addresses = addresses;
        document.body.append(el);
        listcomp = new AddressListComponent(el);

        return listcomp.flush();
      });

      currentSchedule.onComplete.schedule(() => listcomp.el.remove());
    });



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
    var address = new Address.create(id: 1, street: '1234 Somestreet street', suburb: 'somesuburb');
    var residents = [new Resident.create(id: 1, title: 'Mr', firstname: 'Jim', lastname: 'Jimbo'), new Resident.create(id: 1, title: 'Mrs', firstname: 'Kim', lastname: 'Jimbo')];
    setUp(() {
      schedule(() {
        PolymerElement el = createElement('<address-view></address-view>');
        el.address = address;
        el.residents = residents;
        document.body.append(el);
  //        el.shadowRoot.querySelector("resident-view").async((_) {
  //          completer.complete();
  //        });
        view = new AddressViewComponent(el);

        return view.flush();
      });

      currentSchedule.onComplete.schedule(() => view.el.remove());
    });


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
    var address = new Address.create(id: 1, street: '1234 Somestreet street', suburb: 'somesuburb');
    var resident = new Resident.create(id: 1, title: 'Mr', firstname: 'Jim', lastname: 'Jimbo');
    var selectedStyle = "5px solid green";
    var deselectedStyle = "1px solid blue";

    setUp(() {
      schedule(() {
        PolymerElement el = createElement("<resident-view></resident-view>");
        el.resident = resident;
        document.body.append(el);
        view = new ResidentViewComponent(el);

        return view.flush();
      });

      currentSchedule.onComplete.schedule(() => view.el.remove());
    });


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
