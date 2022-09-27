import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

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
            const Text(
              "Hello, Om",
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                print("Button Pressed"); // TODO: Navigate to SomeWhere
              },
            )
          ],
        ),
      ),
    );
  }
}
