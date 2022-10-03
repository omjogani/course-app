import 'dart:convert';
import 'package:course_app/screens/course_content_screen/course_content_list_screen.dart.dart';
import 'package:course_app/constant.dart';
import 'package:flutter/material.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({Key? key}) : super(key: key);

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: DefaultAssetBundle.of(context).loadString(
                  'assets/jsons/courses/reactjs.json'), // TODO: make it dynamic
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
                  String courseName = decodedJsonData["name"];
                  String videoList = decodedJsonData["tutorials"]["videos"];
                  List<String> videoIdList = videoList.split(',');
                  return CourseContentList(
                    videoIdList: videoIdList,
                    courseName: courseName,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
