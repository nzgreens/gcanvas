part of gcanvas_test;

void address_list_element_test() {
  group("[address-list]", () {
    Element _el;


    setUp((){
      _el = createElement('<address-list></address-list>');
      document.body.append(_el);
    });


    tearDown((){
      _el.remove();
    });
  });
}