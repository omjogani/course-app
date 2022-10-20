import 'dart:convert';

import 'package:course_app/screens/course_library/components/course_list_tile.dart';
import 'package:course_app/widgets/navbar_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseLibrary extends StatefulWidget {
  const CourseLibrary({Key? key}) : super(key: key);

  @override
  State<CourseLibrary> createState() => _CourseLibraryState();
}

class _CourseLibraryState extends State<CourseLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            const NavBar(title: "All Courses Library"),
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
                        return CourseListTile(
                          imageURL: image,
                          title: courseName,
                          description: description,
                          buttonText: "ENROLL",
                          isAlreadyEnrolled: false,
                          isMyCourseSection: false,
                          isInfo: false,
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            SnackBar? snackBar;
                            List<String>? enrolledCourses =
                                preferences.getStringList("enrolledCourses");
                            if (enrolledCourses == null) {
                              preferences
                                  .setStringList("enrolledCourses", [courseId]);
                              List<String> courseDataToBeStored = ["0", fileName];
                              print("TotalTest: $totalTests");
                              for (int i = 0; i < totalTests; i++) {
                                courseDataToBeStored.add("test${i + 1}");
                                courseDataToBeStored.add("false");
                              }
                              print("ListContent: $courseDataToBeStored");
                              print("Libraray: $courseId");
                              preferences.setStringList(courseId, courseDataToBeStored);
                              snackBar = const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("Successfully Enrolled"),
                                duration: Duration(seconds: 1),
                              );
                            } else {
                              for (int i = 0; i < enrolledCourses.length; i++) {
                                if (enrolledCourses[i] == courseId) {
                                  snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("Already Enrolled"),
                                    duration: Duration(seconds: 1),
                                  );
                                  break;
                                } else {
                                  Set<String> tempList = {
                                    ...enrolledCourses,
                                    courseId
                                  };
                                  List<String> convertedList =
                                      tempList.toList();
                                  preferences.setStringList(
                                      'enrolledCourses', convertedList);
                                  snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("Successfully Enrolled"),
                                    duration: Duration(seconds: 1),
                                  );
                                  List<String> courseDataToBeStored = ["0",fileName];
                                  print("TotalTest: $totalTests");
                                  for (int i = 0; i < totalTests; i++) {
                                    courseDataToBeStored.add("test${i + 1}");
                                    courseDataToBeStored.add("false");
                                  }
                                  print("ListContent: $courseDataToBeStored");
                                  print("Libraray: $courseId");
                                  preferences.setStringList(
                                      courseId, courseDataToBeStored);
                                }
                              }
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar!);
                          },
                          onInfo: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.remove("enrolledCourses");
                            preferences.remove("$courseId");
                          },
                        );
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
//                     buttonText: "ENROLLED",
//                     isAlreadyEnrolled: true,
//                     isMyCourseSection: false,
//                     onPressed: () {
//                       print("object");
//                     },
//                     onInfo: () {},
//                   ),
//                   CourseListTile(
//                     imageURL:
//                         "https://cdn-icons-png.flaticon.com/512/3098/3098090.png",
//                     title: "Python Course",
//                     description:
//                         "The Ultimate Python Course for professionals.",
//                     buttonText: "ENROLL",
//                     isAlreadyEnrolled: false,
//                     isMyCourseSection: false,
//                     onPressed: () {},
//                     onInfo: () {},
//                   ),
//                   CourseListTile(
//                     imageURL:
//                         "https://cdn-icons-png.flaticon.com/512/3344/3344400.png",
//                     title: "JavaScript Course",
//                     description: "The Ultimate Web Development with JS",
//                     buttonText: "ENROLLED",
//                     isAlreadyEnrolled: true,
//                     isMyCourseSection: false,
//                     onPressed: () {},
//                     onInfo: () {},
//                   ),
//                 ],
//               ),
//             ),
          