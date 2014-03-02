library gcanvas.questionscript;


class QuestionScript {
  String script;
  DateTime date;

  QuestionScript(this.script, this.date);

  
  factory QuestionScript.create({String script: '', DateTime date}) {
    if(date == null) {
      date = new DateTime.now();
    }

    return new QuestionScript(script, date);
  }


  factory QuestionScript.fromMap(Map map) {
    var script = map['script'];
    var date = DateTime.parse(map['date']);

    return new QuestionScript.create(script: script, date: date);
  }


  Map toMap() {
    return {
      'script': script,
      'date': date.toString()
    };
  }
}