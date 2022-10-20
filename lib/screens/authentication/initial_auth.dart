import 'package:course_app/constant.dart';
import 'package:course_app/screens/authentication/components/button_widget.dart';
import 'package:course_app/screens/authentication/components/custom_text_field.dart';
import 'package:course_app/screens/home/bottom_navigation_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialAuthentication extends StatefulWidget {
  const InitialAuthentication({Key? key}) : super(key: key);

  @override
  State<InitialAuthentication> createState() => _InitialAuthenticationState();
}

class _InitialAuthenticationState extends State<InitialAuthentication> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  bool _isValid = false;
  late SharedPreferences preferences;

  String? commonValidator(String str, String errorMessage) {
    if (str.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  Future sharedPreferencesInitialization() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("name", _nameController.text.trim());
  }

  Future<bool> onWillPopExit(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Text(
              "Do you really want to Exit the App?",
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 23.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  "No",
                  style: TextStyle(fontSize: 23.0, color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopExit(context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Welcome to\nCourse App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 300.0,
                  width: 350.0,
                  child: Lottie.asset(
                    "assets/lottie/initial_registration.json",
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Now, Learn by Video Tutorial, Attempt Assignments and grab more knowledge...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Form(
                  key: _key,
                  autovalidateMode: _isValid
                      ? AutovalidateMode.always
                      : AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTitleTextField(
                        controller: _nameController,
                        hintText: "Name",
                        onChanged: (str) {},
                        onEditingComplete: () {},
                        onSaved: (str) {},
                        keyboardType: TextInputType.text,
                        validator: (str) => commonValidator(str!, "Enter Name"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ButtonWidget(
                  text: 'Get Started',
                  onClicked: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      sharedPreferencesInitialization();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationWrapper(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
