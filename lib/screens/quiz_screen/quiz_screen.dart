import 'package:course_app/constant.dart';
import 'package:course_app/models/question_model.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/screens/result_screen/result_screen.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    Key? key,
    required this.quiz,
    required this.courseId,
    required this.totalCourseItems,
    required this.testNo,
  }) : super(key: key);
  final List<Quiz> quiz;
  final String courseId;
  final int totalCourseItems;
  final int testNo;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;
  late PageController _controller;
  List<Question> questions = [];
  void processQuizToQuestion() {
    for (var singleQuiz in widget.quiz) {
      questions.add(Question(
        question: singleQuiz.question,
        options: <Option>[
          Option(
              text: singleQuiz.option1, isCorrect: singleQuiz.correctAns == 1),
          Option(
              text: singleQuiz.option2, isCorrect: singleQuiz.correctAns == 2),
          Option(
              text: singleQuiz.option3, isCorrect: singleQuiz.correctAns == 3),
          Option(
              text: singleQuiz.option4, isCorrect: singleQuiz.correctAns == 4),
        ],
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    processQuizToQuestion();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(height: 32.0),
            Text("Question $_questionNumber /${questions.length}"),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: PageView.builder(
                itemCount: questions.length,
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return buildQuestion(question);
                },
              ),
            ),
            _isLocked ? buildQuizSubmitButton() : const SizedBox.shrink(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget buildQuizSubmitButton() {
    return GestureDetector(
      onTap: () {
        if (_questionNumber < questions.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
            _isLocked = false;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                score: _score,
                courseId: widget.courseId,
                totalCourseItems: widget.totalCourseItems,
                testNo: widget.testNo,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: kShadowColor,
              offset: Offset(0, 12),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: Text(
          _questionNumber < questions.length ? "Next Page" : "See the Result",
        ),
      ),
    );
  }

  Widget buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 32.0),
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 25.0,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: OptionWidget(
            question: question,
            onClickedOption: (option) {
              if (question.isLocked) {
                return;
              } else {
                setState(() {
                  question.isLocked = true;
                  question.selectedOption = option;
                });
                _isLocked = question.isLocked;
                if (question.selectedOption!.isCorrect) {
                  _score++;
                }
              }
            },
          ),
        )
      ],
    );
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    Key? key,
    required this.question,
    required this.onClickedOption,
  }) : super(key: key);
  final Question question;
  final ValueChanged<Option> onClickedOption;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: question.options
            .map((option) => buildOption(context, option))
            .toList(),
      ),
    );
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        // height: 50.0,
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(width: 1, color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                option.text,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            getIconForOption(option, question),
          ],
        ),
      ),
    );
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }

  Widget getIconForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect
            ? const Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
              )
            : const Icon(
                Icons.cancel,
                color: Colors.redAccent,
              );
      } else if (option.isCorrect) {
        return const Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
        );
      }
    }
    return const SizedBox.shrink();
  }
}
