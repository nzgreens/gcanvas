part of gcanvas_test;

group("[address-list]", () {
  Element _el;

  setUp((){
    _el = createElement('<gcanvas-app></gcanvas-app>');
    document.body.append(_el);
  });


  tearDown((){
    _el.remove();
  });




});