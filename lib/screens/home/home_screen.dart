import 'package:course_app/constant.dart';
import 'package:course_app/screens/authentication/initial_auth.dart';
import 'package:course_app/screens/course_library/components/course_list_tile.dart';
import 'package:course_app/screens/home/components/navbar.dart';
import 'package:course_app/screens/home/components/trending_course.dart';
import 'package:course_app/screens/my_courses/my_courses.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";

  loadNameFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? nameLocal = preferences.getString("name");
    if (nameLocal == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InitialAuthentication(),
        ),
      );
    } else {
      setState(() {
        name = nameLocal;
      });
    }
  }

  @override
  void initState() {
    loadNameFromSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 25.0),
            NavBar(name: name),
            const TitleText(titleText: "Recent Course"),
            CourseTrending(
              onPressed: () {
                print("Course Button is Pressed");
              },
              isNew: true,
              imagePath: "assets/images/react.jpg",
              title: "Zero to Hero React Js Course",
              isPremium: true,
            ),
            const TitleText(titleText: "Start Learning"),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  CourseListTile(
                    imageURL: "assets/images/logo.png",
                    title: "My Courses",
                    description:
                        "Work Hard, Develop Skills and Solve Problems.",
                    buttonText: "My COURSES",
                    isAlreadyEnrolled: false,
                    isMyCourseSection: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            backgroundColor: kBackgroundColor,
                            body: MyCourses(),
                          ),
                        ),
                      );
                    },
                    isInfo: false,
                    onInfo: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    Key? key,
    required this.titleText,
  }) : super(key: key);
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        titleText,
        style: const TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}
