import 'package:flutter/material.dart';

class CourseTrending extends StatelessWidget {
  const CourseTrending({
    Key? key,
    required this.onPressed,
    required this.isNew,
    required this.isPremium,
    required this.imagePath,
    required this.title,
  }) : super(key: key);
  final Function onPressed;
  final bool isNew;
  final bool isPremium;
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onPressed(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: size.width * 0.90,
              height: size.height * 0.25,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 10.0,
              top: 10.0,
              child: Row(
                children: <Widget>[
                  isNew
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "NEW",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox(),
                      SizedBox(width:isPremium ? 10.0: 0.0),
                  isPremium ? Tooltip(
                    message: "Premium Quality",
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.asset(
                        'assets/icons/star.png',
                      ),
                    ),
                  ): const SizedBox(),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 60.0,
                width: size.width * 0.90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.black87.withOpacity(0.5),
                      Colors.black87.withOpacity(0.3),
                      Colors.black45.withOpacity(0.2),
                      Colors.black45.withOpacity(0.1),
                      Colors.black45.withOpacity(0.01),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 20.0,
              child: SizedBox(
                width: size.width * 0.80,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
