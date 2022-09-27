import 'package:course_app/screens/course_library/components/course_list_tile.dart';
import 'package:course_app/widgets/navbar_title.dart';
import 'package:flutter/material.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            const NavBar(title: "My Courses"),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/1183/1183621.png",
                    title: "React Course",
                    description: "The Ultimate Web Development with react.",
                    buttonText: "START LEARNING",
                    isAlreadyEnrolled: false,
                    isMyCourseSection: true,
                    percentage: 40,
                    onPressed: () {
                      
                    },
                    onInfo: () {},
                  ),
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/3098/3098090.png",
                    title: "Python Course",
                    description:
                        "The Ultimate Python Course for professionals.",
                    buttonText: "START LEARNING",
                    isAlreadyEnrolled: false,
                    isMyCourseSection: true,
                    percentage: 50,
                    onPressed: () {},
                    onInfo: () {},
                  ),
                  CourseListTile(
                    imageURL:
                        "https://cdn-icons-png.flaticon.com/512/3344/3344400.png",
                    title: "JavaScript Course",
                    description: "The Ultimate Web Development with JS",
                    buttonText: "START LEARNING",
                    isAlreadyEnrolled: false,
                    isMyCourseSection: true,
                    percentage: 20,
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
