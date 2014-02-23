part of gcanvas_test;

void gcanvas_app_element_test() {
  group("[gcanvas-app element]", () {
      Element _el;

      setUp((){
        _el = createElement('<gcanvas-app></gcanvas-app>');
        document.body.append(_el);
      });


      tearDown((){
        _el.remove();
      });

      test("gCanvas Title is present", () {
        var content = querySelector("gcanvas-app").shadowRoot.text;
        expect(
            content,
            contains("gCanvas"));
      });


      test("Has refresh button", () {
        ButtonElement refresh = querySelector("gcanvas-app").shadowRoot.querySelector("#refresh");
        expect(
          refresh,
          isNotNull
        );
      });

      /*test("has back button", () {
        ButtonElement back = querySelector("gcanvas-app").shadowRoot.querySelector("#back");
        expect(
          back,
          isNotNull
        );
        });*/

      /*test("start screen back button is hidden", () {
        ButtonElement back = querySelector("gcanvas-app").shadowRoot.querySelector("#back");
        expect(
          back.hidden,
          isTrue
        );
      });*/
    });
}