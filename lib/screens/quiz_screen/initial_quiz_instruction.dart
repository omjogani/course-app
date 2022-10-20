import 'dart:convert';

import 'package:course_app/constant.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InitialQuizInstruction extends StatefulWidget {
  const InitialQuizInstruction({
    Key? key,
    required this.fileName,
    required this.testIndexNumber,
    required this.courseId,
    required this.totalCourseItems,
  }) : super(key: key);
  final String fileName;
  final int testIndexNumber;
  final String courseId;
  final int totalCourseItems;

  @override
  State<InitialQuizInstruction> createState() => _InitialQuizInstructionState();
}

class _InitialQuizInstructionState extends State<InitialQuizInstruction> {
  bool isInstruction = true;
  bool checkedValue = false;
  bool isLoadingQuiz = true;
  List<Quiz> quizLoadedFromDatabase = [];

  Future<bool> onBackPopUp(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Text(
              "Are you sure want to quit the quiz?",
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 23.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  "No",
                  style: TextStyle(fontSize: 23.0, color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => onBackPopUp(context),
      child: Scaffold(
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString(
              'assets/jsons/courses/${widget.fileName}.json'), // TODO: make it dynamic
          builder: (context, snapshot) {
            var decodedJsonData = json.decode(snapshot.data.toString());
            if (decodedJsonData == null || isLoadingQuiz) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: instructionWidget(context),
              );
            }
            // Json Available,
            int totalQuiz = decodedJsonData["tutorials"]["test${widget.testIndexNumber}"]["length"];
            dynamic listQuiz = decodedJsonData["tutorials"]["test${widget.testIndexNumber}"];
            for (int i = 1; i <= totalQuiz; i++) {
              Quiz quiz = Quiz(
                question: listQuiz["quiz$i"]["question"],
                option1: listQuiz["quiz$i"]["option1"],
                option2: listQuiz["quiz$i"]["option2"],
                option3: listQuiz["quiz$i"]["option3"],
                option4: listQuiz["quiz$i"]["option4"],
                correctAns: listQuiz["quiz$i"]["correctAns"],
              );
              quizLoadedFromDatabase.add(quiz);
            }
            if (!(isLoadingQuiz && quizLoadedFromDatabase.isNotEmpty)) {
              return QuizScreen(
                quiz: quizLoadedFromDatabase,
                courseId: widget.courseId,
                totalCourseItems: widget.totalCourseItems,
                testNo: widget.testIndexNumber,
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0),
                  Text(
                    "Loading Quiz..",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget instructionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 32.0),
        const Text(
          "Quiz Instructions",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: kTitleText,
        ),
        const SizedBox(height: 10.0),
        const InstructionTile(
            instructionText:
                "All Question are mandatory, You have to attempt all."),
        const SizedBox(height: 10.0),
        const InstructionTile(
            instructionText:
                "Once you leave the quiz in between then it will be counted as attempted."),
        const SizedBox(height: 10.0),
        const InstructionTile(
            instructionText:
                "Don't cheat apply your knowledge and do your best!"),
        const SizedBox(height: 10.0),
        const InstructionTile(
            instructionText:
                "Minimum Criteria to proceed further is 60% in each Test."),
        const SizedBox(height: 10.0),
        const InstructionTile(
            instructionText:
                "In case of not completing criteria you may revise your learning and proceed further."),
        const SizedBox(height: 10.0),
        CheckboxListTile(
          title:
              const Text("I have read instruction and want to proceed further"),
          value: checkedValue,
          activeColor: Colors.lightBlueAccent,
          onChanged: (newValue) {
            setState(() {
              checkedValue = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CustomStartQuizButton(
          buttonText: "Start Quiz",
          isActive: checkedValue,
          onPressed: () {
            if (checkedValue) {
              setState(() {
                isInstruction = false;
                isLoadingQuiz = false;
              });
            } else {
              const snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text('Please read Instructions and tick the box.'),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        )
      ],
    );
  }
}

class CustomStartQuizButton extends StatelessWidget {
  const CustomStartQuizButton({
    Key? key,
    required this.buttonText,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final bool isActive;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlueAccent : Colors.grey,
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
          buttonText,
          style: kNormalTitle,
        ),
      ),
    );
  }
}

class InstructionTile extends StatelessWidget {
  const InstructionTile({
    Key? key,
    required this.instructionText,
  }) : super(key: key);
  final String instructionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.9),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: Text(
              instructionText,
              style: kNormalSubTitle,
            ),
          ),
        ],
      ),
    );
  }
}
