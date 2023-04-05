import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/screens/home_screen.dart';

import '../../utils/custom_button.dart';
import '../../utils/color_utils.dart';
import '../../utils/logo_widget.dart';
import '../../utils/textfield_widget.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color:
            /*stringToColorInHex("91e5f6")*/
            stringToColorInHex("000000")
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                placeImgIntoWidget("assets/images/FlutterIcon.png"),
                const SizedBox(
                  height: 40
                ),
                inputField(Icons.mail, "Enter your e-mail", false, emailTextController),
                const SizedBox(
                  height: 40
                ),
                inputField(Icons.lock_clock_sharp, "Enter your password", true, passwordTextController),
                const SizedBox(
                  height: 40
                ),
                customButton(context, "LOG IN", () {
                    String errorMessage;
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailTextController.text, 
                      password: passwordTextController.text)
                      .then((value) {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }).onError((error, StackTrace) {
                        Fluttertoast.showToast(
                          msg: "Error: ${error.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                        });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      )
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Maybe you don't have an account? ",
        style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          )
        )
      ]
    );
  }
}
