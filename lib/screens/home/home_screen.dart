import 'package:course_app/screens/course_library/components/course_list_tile.dart';
import 'package:course_app/screens/home/components/navbar.dart';
import 'package:course_app/screens/home/components/trending_course.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            const NavBar(),
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
            const TitleText(titleText: "Course Library"),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/1183/1183621.png",
                    title: "React Course",
                    description: "The Ultimate Web Development with react.",
                    buttonText: "ENROLLED",
                    isAlreadyEnrolled: true,
                    isMyCourseSection: false,
                    onPressed: () {
                      print("object");
                    },
                    onInfo: () {},
                  ),
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/3098/3098090.png",
                    title: "Python Course",
                    description:
                        "The Ultimate Python Course for professionals.",
                    buttonText: "ENROLL",
                    isAlreadyEnrolled: false,
                    isMyCourseSection: false,
                    onPressed: () {},
                    onInfo: () {},
                  ),
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/3344/3344400.png",
                    title: "JavaScript Course",
                    description: "The Ultimate Web Development with JS",
                    buttonText: "ENROLLED",
                    isAlreadyEnrolled: true,
                    isMyCourseSection: false,
                    onPressed: () {},
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
