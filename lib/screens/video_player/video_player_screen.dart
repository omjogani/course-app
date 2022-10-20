import 'package:course_app/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.videoId,
    required this.title,
    required this.author,
    required this.courseName,
    required this.courseId,
    required this.totalCourseItems,
  }) : super(key: key);
  final String videoId;
  final String title;
  final String author;
  final String courseName;
  final String courseId;
  final int totalCourseItems;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late YoutubeMetaData _videoMetaData;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  bool _muted = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    super.dispose();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return constraints.maxWidth >= 480
                ? const SizedBox()
                : NavBarVideoScreen(courseName: widget.courseName);
          }),
          Expanded(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                    onPressed: _isPlayerReady
                        ? () {
                            _muted ? _controller.unMute() : _controller.mute();
                            setState(() {
                              _muted = !_muted;
                            });
                          }
                        : null,
                  ),
                ],
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) async {
                  // TODO: Update Shared Preferences for Course Progress
                  
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  List<String>? courseProgress = preferences.getStringList(widget.courseId);
                  if(courseProgress == null){
                    print("Something Went Wrong!");
                  }else{
                    double currentCourseProgress = double.parse(courseProgress[0]);
                    double progress = currentCourseProgress + (100/ widget.totalCourseItems);
                    List<String> updatedListToBeStored = [
                      progress.toStringAsFixed(0).toString(),
                    ];
                    for(int i = 0; i < courseProgress.length; i++){
                      if(i == 0) continue;
                      updatedListToBeStored.add(courseProgress[i]);
                    }
                    preferences.setStringList(widget.courseId, updatedListToBeStored);
                  }
                  showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      content: const Text(
                        "Marked as Done!",
                        style: TextStyle(
                          fontSize: 23.0,
                        ),
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            color: Colors.greenAccent,
                            child: const Text(
                              "Ok",
                              style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              builder: (context, player) {
                return Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: kBackgroundColor,
                  body: ListView(
                    children: <Widget>[
                      player,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Title",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1, color: Colors.grey),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              "Author",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1, color: Colors.grey),
                            Text(
                              widget.author,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

class NavBarVideoScreen extends StatelessWidget {
  const NavBarVideoScreen({
    Key? key,
    required this.courseName,
  }) : super(key: key);
  final String courseName;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50.0,
      alignment: Alignment.center,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          Flexible(
            child: Text(
              courseName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
