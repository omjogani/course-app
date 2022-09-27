import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:course_app/constant.dart';
import 'package:course_app/screens/course_content_screen/course_content_screen.dart';
import 'package:course_app/screens/course_content_screen/get_data_and_pass.dart';
import 'package:course_app/screens/course_library/course_library.dart';
import 'package:course_app/screens/home/home_screen.dart';
import 'package:course_app/screens/my_courses/my_courses.dart';
import 'package:course_app/screens/quiz_screen/quiz_screen.dart';
import 'package:course_app/screens/video_player/video_data_interface.dart';
import 'package:course_app/widgets/custom_showdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationWrapper extends StatefulWidget {
  const BottomNavigationWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigationWrapper> createState() =>
      _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int index = 0;
  late PageController _pageController;
  late SharedPreferences preferences;
  late int currentTheme = -1;

  @override
  void initState() {
    // sharedPreferencesInitialization();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    int? getCurrentIndex = preferences.getInt("themeIndex");
    if (getCurrentIndex == null) {
      preferences.setInt("themeIndex", 0);
    }
    setState(() {
      currentTheme = getCurrentIndex!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentConnectionStatus =
    //     Provider.of<InternetConnectivityStatus?>(context);
    // if (currentConnectionStatus == null) {
    //   return const FullScreenLoading(
    //     message: "Checking Internet Connection...",
    //     simpleLoadingAnimation: false,
    //   );
    // }
    // if (currentConnectionStatus == InternetConnectivityStatus.offline) {
    //   return const NoInternetScreen();
    // }
    // if (currentTheme == -1) {
    //   return const FullScreenLoading(
    //       message: "Loading...", simpleLoadingAnimation: true);
    // }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: WillPopScope(
        onWillPop: () => CustomShowDialog().onWillPopExit(context),
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => this.index = index);
                },
                children: <Widget>[
                  // QuizScreen(),
                  
                  HomeScreen(),
                  // CourseContentScreen(),
                  CourseLibrary(),
                  MyCourses(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(false),
    );
  }

  Widget buildBottomNavigation(bool isDarkTheme) {
    final Color activeColor = isDarkTheme ? Colors.white : Colors.black;
    const Color inactiveColor = CupertinoColors.systemGrey;
    return BottomNavyBar(
      backgroundColor:
          isDarkTheme ? const Color(0xFF262626) : const Color(0xFFF2F2F2),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onItemSelected: (index) {
        setState(() {
          this.index = index;
        });
        _pageController.jumpToPage(index);
      },
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: const Text("Home"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.settings),
          title: const Text("Settings"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.info_circle),
          title: const Text("Info"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ],
    );
  }
}