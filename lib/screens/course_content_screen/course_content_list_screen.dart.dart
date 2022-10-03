import 'package:course_app/constant.dart';
import 'package:course_app/models/youtube_data.dart';
import 'package:course_app/screens/course_content_screen/components/custom_course_content_list_tile.dart';
import 'package:course_app/screens/video_player/video_data_interface.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class CourseContentList extends StatefulWidget {
  const CourseContentList({
    Key? key,
    required this.videoIdList,
    required this.courseName,
  }) : super(key: key);
  final List<String> videoIdList;
  final String courseName;

  @override
  State<CourseContentList> createState() => _CourseContentListState();
}

class _CourseContentListState extends State<CourseContentList> {
  List<String> titleList = [];
  List<String> authorList = [];
  bool isLoading = true;

  Future<List<String>> getData(String videoId) async {
    var url =
        Uri.parse("https://noembed.com/embed?url=https://youtu.be/$videoId");
    http.Response response = await http.get(url);
    List<String> dataToBeReturned = [];
    if (response.statusCode == 200) {
      String data = response.body;
      final parsedJson = convert.jsonDecode(data);
      final videoInformation = VideoInfo.fromJson(parsedJson);
      dataToBeReturned.add(videoInformation.title);
      dataToBeReturned.add(videoInformation.authorName);
    } else {
      print(response.statusCode);
    }
    return dataToBeReturned;
  }

  void processVideoId() async {
    List<String> retrievedList = [];
    for (var item in widget.videoIdList) {
      item = item.trim();
      retrievedList = await getData(item);
      titleList.add(retrievedList.first);
      authorList.add(retrievedList.last);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    processVideoId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 32.0),
          ContentScreenNavBar(title: widget.courseName),
          Expanded(
            child: FutureBuilder(
              future: DefaultAssetBundle.of(context).loadString(
                  'assets/jsons/courses/reactjs.json'), // TODO: make it dynamic
              builder: (context, snapshot) {
                var decodedJsonData = json.decode(snapshot.data.toString());
                if (decodedJsonData == null || isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 20.0),
                        Text(
                          "Loading..",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  int courseLength = decodedJsonData["length"];
                  int videoIndex = -1;
                  return ListView.builder(
                    itemCount: courseLength,
                    itemBuilder: (context, index) {
                      int indexLocal = index + 1;
                      String mapping =
                          decodedJsonData["mapping"]["type$indexLocal"];
                      if (mapping == "video") {
                        videoIndex++;
                        return CustomCourseContentListTile(
                          title: titleList[videoIndex],
                          author: authorList[videoIndex],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YouTubeDataInterface(
                                  videoId: widget.videoIdList[videoIndex].trim(),
                                  videoTitle: titleList[videoIndex],
                                  videoAuthor: authorList[videoIndex],
                                  courseName: widget.courseName,
                                ),
                              ),
                            );
                          },
                          isQuiz: false,
                        );
                      } else if (mapping == "quiz") {
                        return CustomCourseContentListTile(
                          title: "Assignment",
                          author: "Pending",
                          onPressed: () {},
                          isQuiz: true,
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
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

class ContentScreenNavBar extends StatelessWidget {
  const ContentScreenNavBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.90,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: kTitleText,
      ),
    );
  }
}
