import 'package:course_app/constant.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.90,
      child: Row(
        children: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_rounded)),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTitleText,
          ),
        ],
      ),
    );
  }
}
