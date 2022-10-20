import 'dart:convert';

import 'package:course_app/screens/course_content_screen/course_content_screen.dart';
import 'package:course_app/screens/course_library/components/course_list_tile.dart';
import 'package:course_app/widgets/navbar_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool isEmpty = false;
  List<String> courseIdList = [];
  List<List<String>> coursesInfo = [];
  List<int> percentageList = [];
  int indexPercentage = -1;
  Future loadEnrolledCourseId() async {
    print("hello");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? listOfEnrolledCoursesIdFromSharedPreferences =
        preferences.getStringList("enrolledCourses");
    if (listOfEnrolledCoursesIdFromSharedPreferences == null) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        courseIdList = listOfEnrolledCoursesIdFromSharedPreferences;
      });
      for (int i = 0; i < courseIdList.length; i++) {
        coursesInfo.add(preferences.getStringList(courseIdList[i])!);
      }
      for (int i = 0; i < courseIdList.length; i++) {
        print("printed here");
        percentageList.add(int.parse(coursesInfo[i][0]));
      }
      setState(() {
        coursesInfo = coursesInfo;
        percentageList = percentageList;
      });
    }
  }

  @override
  void initState() {
    loadEnrolledCourseId();
    setState(() {
      indexPercentage = -1;
    });
    super.initState();
  }

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
              child: FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/jsons/course_mapping.json'),
                builder: (context, snapshot) {
                  var decodedJsonData = json.decode(snapshot.data.toString());
                  if (decodedJsonData == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        CircularProgressIndicator(),
                        Text(
                          "Loading",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    );
                  } else {
                    int totalCourses = decodedJsonData["totalCourses"];
                    if (courseIdList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 150.0,
                            width: 150.0,
                            child: Image.asset(
                              "assets/icons/no-results.png",
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          const Center(
                            child: Text(
                              "No Courses\nEnrolled",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: totalCourses,
                      itemBuilder: ((context, index) {
                        dynamic courseDataContent =
                            decodedJsonData["course${index + 1}"];
                        String courseId = courseDataContent["id"];
                        String courseName = courseDataContent["name"];
                        String description = courseDataContent["description"];
                        String image = courseDataContent["imageUrl"];
                        int totalTests = courseDataContent["totalTest"];
                        String fileName = courseDataContent["fileName"];

                        if (courseIdList.contains(courseId)) {
                          if (coursesInfo.isNotEmpty) {
                            print("HHELO $coursesInfo");
                          }
                          print(percentageList);
                          print("Index $indexPercentage");
                          return CourseListTile(
                            imageURL: image,
                            title: courseName,
                            description: description,
                            buttonText: "START LEARNING",
                            isAlreadyEnrolled: false,
                            isMyCourseSection: true,
                            percentage: percentageList[
                                (++indexPercentage) % percentageList.length],
                            isInfo: false,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseContentScreen(
                                    fileName: fileName,
                                    totalTests: totalTests,
                                  ),
                                ),
                              );
                            },
                            onInfo: () {
                              setState(() {
                                loadEnrolledCourseId();
                              });
                            },
                          );
                        }
                        return Container();
                      }),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Expanded(
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: <Widget>[
//                   CourseListTile(
//                     imageURL:
//                         "https://cdn-icons-png.flaticon.com/512/1183/1183621.png",
//                     title: "React Course",
//                     description: "The Ultimate Web Development with react.",
//                     buttonText: "START LEARNING",
//                     isAlreadyEnrolled: false,
//                     isMyCourseSection: true,
//                     percentage: 40,
//                     onPressed: () {
                      
//                     },
//                     onInfo: () {},
//                   ),
//                   CourseListTile(
//                     imageURL:
//                         "https://cdn-icons-png.flaticon.com/512/3098/3098090.png",
//                     title: "Python Course",
//                     description:
//                         "The Ultimate Python Course for professionals.",
//                     buttonText: "START LEARNING",
//                     isAlreadyEnrolled: false,
//                     isMyCourseSection: true,
//                     percentage: 50,
//                     onPressed: () {},
//                     onInfo: () {},
//                   ),
//                   CourseListTile(
//                     imageURL:
//                         "https://cdn-icons-png.flaticon.com/512/3344/3344400.png",
//                     title: "JavaScript Course",
//                     description: "The Ultimate Web Development with JS",
//                     buttonText: "START LEARNING",
//                     isAlreadyEnrolled: false,
//                     isMyCourseSection: true,
//                     percentage: 20,
//                     onPressed: () {},
//                     onInfo: () {},
//                   ),
//                 ],
//               ),
//             ),