import 'package:course_app/screens/video_player/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:course_app/models/youtube_data.dart';

class YouTubeDataInterface extends StatefulWidget {
  const YouTubeDataInterface({
    Key? key,
    required this.videoId,
    required this.videoTitle,
    required this.videoAuthor,
    required this.courseName,
    required this.courseId,
    required this.totalCourseItems,
  }) : super(key: key);
  final String videoId;
  final String videoTitle;
  final String videoAuthor;
  final String courseName;
  final String courseId;
  final int totalCourseItems;

  @override
  State<YouTubeDataInterface> createState() => _YouTubeDataInterfaceState();
}

class _YouTubeDataInterfaceState extends State<YouTubeDataInterface> {
  bool isLoading = true;
  String title = "";
  String author = "";
  String videoThumbnail = "";
  Future<void> getData(String videoId) async {
    var url =
        Uri.parse("https://noembed.com/embed?url=https://youtu.be/$videoId");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      final parsedJson = convert.jsonDecode(data);
      final videoInformation = VideoInfo.fromJson(parsedJson);

      setState(() {
        title = videoInformation.title;
        author = videoInformation.authorName;
        videoThumbnail = videoInformation.thumbnailUrl;
        isLoading = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      videoId: widget.videoId,
      title: widget.videoTitle,
      author: widget.videoAuthor,
      courseName: widget.courseName,
      courseId: widget.courseId,
      totalCourseItems: widget.totalCourseItems,
    );
  }
}
