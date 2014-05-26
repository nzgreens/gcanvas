part of gcanvas_test;

class AddressEditComponent extends PageComponent {
  AddressListItemComponent(el) : super(el);

  Address get address => el.address;
  String get latitude => el.latitude;
  String get longitude => el.longitude;

  bool get formIsValid => el.validate();

  bool get validLatitude => el.validLatitude;
  bool get validLongitude => el.validLongitude;
}


void address_edit_element_test() {
  group("[address-edit", () {
    setUp(() {
      schedule(() {
        PolymerElement el = createElement('<address-edit></address-edit>');
        el.address = address;
        document.body.append(el);
        listitem = new AddressListItemComponent(el);

        return listitem.flush();
      });
      currentSchedule.onComplete.schedule(() => listitem.el.remove());


    });
  });
}