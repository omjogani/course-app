import 'package:course_app/screens/home/bottom_navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sf Pro Text",
      ),
      home: BottomNavigationWrapper(),
    );
  }
}