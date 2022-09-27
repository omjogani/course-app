import 'package:course_app/models/question_model.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    Key? key,
    required this.score,
  }) : super(key: key);
  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("You Got $score / ${questions.length}"),
      ),
    );
  }
}
