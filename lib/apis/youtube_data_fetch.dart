// import 'dart:convert';
// import 'package:course_app/models/youtube_data.dart';
// import 'package:http/http.dart' as http;

// class VideoInfoApi {
//   static Future<List<VideoInfo>> getVideoInfo(List<String> videoUrl) async {
//     List _temp = [];
//     print("Video Url $videoUrl");
//     for (var videoID in videoUrl) {
//       var url =
//         Uri.parse("https://noembed.com/embed?url=https://youtu.be/$videoId");

//       final response = await http.get(uri);

//       Map data = jsonDecode(response.body);

//       print("Message that needs to display $data");
//       _temp.add(data);
//     }
//     return VideoInfo.videoInfoFromSnapshot(_temp);
//   }
// }
