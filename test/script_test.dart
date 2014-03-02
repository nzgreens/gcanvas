part of gcanvas_test;


void question_script_test() {
  group("[Script Test]", () {
    //Address address = new Address.create(id: 10);
    //Resident resident = new Resident.create(id: 10, address: address);
    String script = '<input type="checkbox" name="opinion">Do you agree<br>';
    QuestionScript questionScript = new QuestionScript.create(script: script);
    DateTime date = new DateTime.now();
    QuestionScript questionScript2 = new QuestionScript.create(script: script, date: date);

    setUp(() {

    });

    tearDown(() {

    });


    test("script contains script text", () {
      expect(questionScript.script, equals(script));
    });


    test("script date is now", () {
      expect(questionScript.date.day, equals(new DateTime.now().day));
    });


    test("script toMap works", () {
      var expected = {
        "script": script,
        "date": date.toString()
      };

      expect(questionScript.toMap(), equals(expected));
    });


    test("script fromMap works", () {
      var map = {
        "script": script,
        "date": date.toString()
      };

      var quesScript = new QuestionScript.fromMap(map);

      expect(quesScript.script, equals(script));
      expect(quesScript.date, equals(date));
    });
  });
}