import 'package:course_app/constant.dart';
import 'package:flutter/material.dart';

class CourseListTile extends StatelessWidget {
  const CourseListTile({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.isAlreadyEnrolled,
    required this.buttonText,
    required this.onInfo,
    required this.isMyCourseSection,
    this.percentage = 0,
  }) : super(key: key);
  final String imageURL;
  final String title;
  final String description;
  final Function onPressed;
  final bool isAlreadyEnrolled;
  final String buttonText;
  final Function onInfo;
  final bool isMyCourseSection;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: size.width * 0.90,
        height: size.height * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: kShadowColor,
              offset: Offset(0, 12),
              blurRadius: 16.0,
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.network(
                    imageURL,
                    // fit: BoxFit.,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, right: 10.0, top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: kNormalTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isMyCourseSection
                          ? Column(
                              children: <Widget>[
                                const SizedBox(height: 4.0),
                                Text(
                                  "$percentage%",
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.lightBlueAccent,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                    value: percentage / 100,
                                    minHeight: 10.0,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => isAlreadyEnrolled ? null : onPressed(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: isAlreadyEnrolled
                                    ? Colors.lightBlueAccent
                                    : Colors.greenAccent,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: kShadowColor,
                                    offset: Offset(0, 12),
                                    blurRadius: 16.0,
                                  ),
                                ],
                              ),
                              child: Text(
                                buttonText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => onInfo(),
                            icon: const Icon(
                              Icons.info_outline_rounded,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
