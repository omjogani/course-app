import 'dart:math';
import 'package:course_app/constant.dart';
import 'package:course_app/screens/splash_screen/components/splash_screen_display.dart';
import 'package:course_app/screens/wrapper.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> currentSelectedGradient = kGradientColors[Random().nextInt(10)];
    return SplashScreen(
      title: const Text(
        "Course App",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      seconds: 3,
      shadowColor: currentSelectedGradient.first,
      gradientBackground: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: currentSelectedGradient,
      ),
      image: Image.asset(
        "assets/images/logo.png",
      ),
      styleTextUnderTheLoader: const TextStyle(),
      photoSize: 100,
      loaderColor: Colors.white,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      navigateAfterSeconds: const Wrapper(),
    );
  }
}