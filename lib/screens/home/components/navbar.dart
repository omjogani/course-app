import 'package:course_app/screens/authentication/initial_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hello, ${widget.name}",
              style: const TextStyle(
                fontSize: 22.0,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove("name");
                preferences.remove("enrolledCourses");

                navigateToRegister();
              },
            )
          ],
        ),
      ),
    );
  }

  navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InitialAuthentication(),
      ),
    );
  }
}
