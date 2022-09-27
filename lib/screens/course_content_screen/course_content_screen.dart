import 'dart:convert' as convert;
import 'dart:convert';
import 'package:course_app/models/youtube_data.dart';
import 'package:course_app/screens/course_content_screen/get_data_and_pass.dart';
import 'package:http/http.dart' as http;
import 'package:course_app/constant.dart';
import 'package:flutter/material.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({Key? key}) : super(key: key);

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  navigatePlease(List<String> videoIdList, String courseName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestWidget(
            videoIdList: videoIdList,
            courseName: courseName,
          ),
        ),
      );
    });
  }

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
                  // navigatePlease(videoIdList, courseName);
                  return TestWidget(
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
