import 'package:course_app/constant.dart';
import 'package:flutter/material.dart';

class CustomCourseContentListTile extends StatelessWidget {
  const CustomCourseContentListTile({
    Key? key,
    required this.title,
    required this.author,
    required this.onPressed,
    required this.isQuiz,
  }) : super(key: key);
  final String title;
  final String author;
  final Function onPressed;
  final bool isQuiz;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: size.width * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: kShadowColor,
                offset: Offset(0, 12),
                blurRadius: 16.0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 12.0, left: 12.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: Image.asset(
                    isQuiz ? "assets/icons/quiz.png" : "assets/icons/play.png",
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
