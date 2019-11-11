import 'package:flutter/material.dart';
import 'package:quizzler_flutter/QuizBrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: QuizPage())),
    ));
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // creating an empty list (array) of DataType Icon (if List is not defined, it becomes dynamic).
  List<Icon> scoreKeeper = [];

  void checkAnswer(bool chosenAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (chosenAnswer == correctAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      }

      quizBrain.nextQuestion();

      if (quizBrain.isFinished()) {
        Alert(
            context: context,
            title: 'Finished!',
            desc: 'You\'ve reached the end of the quiz.',
            buttons: [
              DialogButton(
                  width: 120,
                  child: Text('RESTART',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () {
                    // added setState here to update question text when Alert is closed
                    setState(() {
// (same as below)    scoreKeeper.removeRange(0, scoreKeeper.length);
                      scoreKeeper = [];
                      quizBrain.reset();
                      Navigator.pop(context);
                    });
                  })
            ]).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                      child: Text(quizBrain.getQuestionText(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.white))))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('True', style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        checkAnswer(true);
                      }))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('False', style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        checkAnswer(false);
                      }))),
          Row(
              // accepted, because scoreKeeper has a DataType of List.
              children: scoreKeeper)
        ]);
  }
}
