import 'package:course_app/models/youtube_data.dart';
import 'package:course_app/screens/course_content_screen/components/custom_course_content_list_tile.dart';
import 'package:course_app/screens/quiz_screen/initial_quiz_instruction.dart';
import 'package:course_app/screens/video_player/video_data_interface.dart';
import 'package:course_app/widgets/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class CourseContentList extends StatefulWidget {
  const CourseContentList({
    Key? key,
    required this.videoIdList,
    required this.courseName,
    required this.fileName,
    required this.courseId,
    required this.totalTests,
  }) : super(key: key);
  final List<String> videoIdList;
  final String courseName;
  final String fileName;
  final String courseId;
  final int totalTests;

  @override
  State<CourseContentList> createState() => _CourseContentListState();
}

class _CourseContentListState extends State<CourseContentList> {
  List<String> titleList = [];
  List<String> authorList = [];
  bool isLoading = true;
  int quizListIndex = 0;
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
          CustomNavBar(title: widget.courseName),
          Expanded(
            child: FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/jsons/courses/${widget.fileName}.json'),
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
                                  videoId:
                                      widget.videoIdList[videoIndex].trim(),
                                  videoTitle: titleList[videoIndex],
                                  videoAuthor: authorList[videoIndex],
                                  courseName: widget.courseName,
                                  courseId: widget.courseId,
                                  totalCourseItems: courseLength,
                                ),
                              ),
                            );
                          },
                          isQuiz: false,
                        );
                      } else if (mapping == "quiz") {
                        // int totalQuizIndex =
                        //     decodedJsonData["tutorials"]["test$quizListIndex"]["length"];
                        // dynamic decodedJsonDataQuiz = decodedJsonData["tutorials"]["test$quizListIndex"];
                        // List<Quiz> quizListToBePassed = [];
                        // for (int i = 1; i <= totalQuizIndex; i++) {
                        //   Quiz quiz = Quiz(
                        //     question: decodedJsonDataQuiz["quiz$i"]["question"],
                        //     option1: decodedJsonDataQuiz["quiz$i"]["option1"],
                        //     option2: decodedJsonDataQuiz["quiz$i"]["option2"],
                        //     option3: decodedJsonDataQuiz["quiz$i"]["option3"],
                        //     option4: decodedJsonDataQuiz["quiz$i"]["option4"],
                        //     correctAns: decodedJsonDataQuiz["quiz$i"]["correctAns"],
                        //   );
                        //   quizListToBePassed.add(quiz);
                        // }

                        return CustomCourseContentListTile(
                          title: "Assignment",
                          author: "Quiz",
                          onPressed: () {
                            if (widget.totalTests > quizListIndex) {
                              ++quizListIndex;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InitialQuizInstruction(
                                  fileName: widget.fileName,
                                  testIndexNumber: quizListIndex,
                                  courseId: widget.courseId,
                                  totalCourseItems: courseLength,
                                ),
                              ),
                            );
                          },
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
