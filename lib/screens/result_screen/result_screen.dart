import 'package:confetti/confetti.dart';
import 'package:course_app/constant.dart';
import 'package:course_app/models/question_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    Key? key,
    required this.score,
    required this.courseId,
    required this.totalCourseItems,
    required this.testNo,
  }) : super(key: key);
  final int score;
  final String courseId;
  final int totalCourseItems;
  final int testNo;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController controllerTopCenter;
  bool isFail = false;
  double percentage = -1;
  bool isCourseCompleted = false;

  void onSuccessQuizComplete() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? courseProgress = preferences.getStringList(widget.courseId);
    if (courseProgress == null) {
      print("Something Went Wrong!");
    } else {
      double currentCourseProgress = double.parse(courseProgress[0]);
      double progress = currentCourseProgress + (100 / widget.totalCourseItems);
      List<String> updatedListToBeStored = [
        progress.toStringAsFixed(0).toString(),
      ];
      for (int i = 0; i < courseProgress.length; i++) {
        if (i == 0) continue;
        updatedListToBeStored.add(courseProgress[i]);
      }
      int calculatedIndex = (widget.testNo * 2) + 1;
      updatedListToBeStored[calculatedIndex] = "true";
      print("HHHHH $calculatedIndex ==  ${updatedListToBeStored.length - 1}");
      print("HHHHH $calculatedIndex ==  ${updatedListToBeStored.length - 1}");
      if (calculatedIndex == updatedListToBeStored.length - 1 &&
          int.parse(updatedListToBeStored[0]) >= 98) {
        setState(() {
          isCourseCompleted = true;
        });
      }
      preferences.setStringList(widget.courseId, updatedListToBeStored);
    }
  }

  @override
  void initState() {
    super.initState();
    percentage = (widget.score * 100) / questions.length;

    setState(() {
      controllerTopCenter =
          ConfettiController(duration: const Duration(seconds: 1));
      percentage = percentage;

      if (percentage > 60) {
        onSuccessQuizComplete();
        controllerTopCenter.play();
      } else {
        isFail = true;
      }
    });
  }

  @override
  void dispose() {
    controllerTopCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
        createParticlePath: drawStar,
        maxBlastForce: 10,
        minBlastForce: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isFail
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You got ${percentage.toStringAsFixed(2)}%",
                      style: const TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Sorry, Better luck next time. You haven't completed 60% criteria. Please revise the topics and come back stronger.",
                      textAlign: TextAlign.center,
                      style: kNormalSubTitle,
                    ),
                    const SizedBox(height: 20.0),
                    quizResultButton(true),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Stack(
                children: <Widget>[
                  buildConfettiWidget(controllerTopCenter, pi / 1),
                  buildConfettiWidget(controllerTopCenter, pi / 4),
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Congratulations",
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          Text(
                            "You Got ${widget.score} / ${questions.length} - ${percentage.toStringAsFixed(2)}%",
                            style: const TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            isCourseCompleted
                                ? "You have completed full course, Hope you like the course. Now, build more stuff and learn more!\n Have a great Journey!!"
                                : "You have successfully passed the quiz and now you are good to proceed further. Keep Going on and gain more knowledge.",
                            textAlign: TextAlign.center,
                            style: kNormalSubTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: quizResultButton(false),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget quizResultButton(bool isFail) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isFail ? Colors.redAccent : Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: kShadowColor,
              offset: Offset(0, 12),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: Text(
          isFail ? "Try Again" : "Done!",
          style: kTitleText.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
