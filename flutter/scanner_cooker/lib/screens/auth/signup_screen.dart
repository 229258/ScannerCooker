import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/screens/home_screen.dart';

import '../../utils/custom_button.dart';
import '../../utils/color_utils.dart';
import '../../utils/textfield_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _nameState();
}

class _nameState extends State<SignUpScreen> {
  TextEditingController passwordTextController = TextEditingController();
    TextEditingController renteredPasswordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color:
            stringToColorInHex("91e5f6")
        ),
        child: SingleChildScrollView(
           child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 40
                ),
                inputField(Icons.mail, "Enter your e-mail", false, emailTextController),
                const SizedBox(
                  height: 40
                ),
                inputField(Icons.lock_clock_sharp, "Enter password", true, passwordTextController),
                const SizedBox(
                  height: 40
                ),
                inputField(Icons.lock_clock_sharp, "Renter password", true, renteredPasswordTextController),
                const SizedBox(
                  height: 40
                ),
                customButton(context, "SIGN UP", () {
                  if(passwordTextController.text == renteredPasswordTextController.text) {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailTextController.text, 
                      password: passwordTextController.text).then( (value) {
                        print("Created new account!");
                        addUser(value.user!.uid);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                          msg: "Error: ${error.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      });
                  } else {
                      Fluttertoast.showToast(
                      msg: "Password and rentered password are the same!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0
                      );
                  }
                })
              ]
            )
           )
        )
      )
    );
  }
}

bool addUser(String user)
{
  if (user != null)
  {
    FirebaseFirestore.instance.collection("users").doc(user).collection('/recipes');
    return true;
  }
  else
  {
    return false;
  }
}
