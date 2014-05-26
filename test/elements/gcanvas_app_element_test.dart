part of gcanvas_test;


class GCanvasComponent extends PageComponent {
  GCanvasComponent(el) : super(el);

  String get currentTextDisplay => el.shadowRoot.text;
  ButtonElement get currentRefreshButton => el.shadowRoot.querySelector('#refresh_button');
  ButtonElement get currentBackButton => el.shadowRoot.querySelector('#back_button');
  ButtonElement get currentShowMapButton => el.shadowRoot.querySelector('#show_map_button');
  PolymerElement get currentAreaSelector => el.shadowRoot.querySelector('area-selector');

  Future clickShowMapButton() {
    currentShowMapButton.click();

    return flush().then((_) {
      Completer completer = new Completer();
      this.currentAreaSelector.async((_) => completer.complete());

      return completer.future;
    });
  }
}


void gcanvas_app_element_test() {
  group("[gcanvas-app element]", () {
      GCanvasComponent gcanvas;

      setUp((){
        schedule(() {
          PolymerElement _el = createElement('<gcanvas-app></gcanvas-app>');
          document.body.append(_el);
          gcanvas = new GCanvasComponent(_el);

          return gcanvas.flush();
        });

        currentSchedule.onComplete.schedule(() => gcanvas.el.remove());
      });


      /*tearDown((){
        _el.remove();
      });*/

      test("gCanvas Title is present", () {
        schedule(() {
          expect(
                gcanvas.currentTextDisplay,
                contains("gCanvas")
              );

          return gcanvas.flush();
        });
      });


      test("Has refresh button", () {
        schedule(() {
          expect(
            gcanvas.currentRefreshButton,
            isNotNull
          );

          return gcanvas.flush();
        });
      });

      /*test("has back button", () {
        ButtonElement back = querySelector("gcanvas-app").shadowRoot.querySelector("#back");
        expect(
          back,
          isNotNull
        );
        });*/

      test("start screen back button is hidden", () {
        schedule(() {
          expect(
            gcanvas.currentBackButton,
            isNull
          );

          return gcanvas.flush();
        });
      });


      /*
       * this will have to remain untested, as this is becoming really hard.
       * This works fine under normal eyeball tests, but not under this
       * automatic test.  Forget it, I've better things to do. Not only that,
       * but external javascript files are blocked by content_shell. An external
       * JS file is needed for this to work.
       *
     test("show map is clicked", () {
        schedule(() => gcanvas.clickShowMapButton());
        schedule(() {
          expect(gcanvas.currentBackButton, isNotNull);
          expect(gcanvas.currentAreaSelector, isNotNull);

          return gcanvas.flush();
        });
      });*/

      //@TODO: make refresh, and show map, only usable when device is connected to the internet
    });
}