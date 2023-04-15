import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/screens/home_screen.dart';
import 'package:scanner_cooker/utils/constants.dart';

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
            stringToColorInHex(Constants.backgroundColorHex)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.width * 0.65,
                  child: Image.asset(
                    "assets/images/scanner_cooker_200.png",
                    fit: BoxFit.fill,
                  )),
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
                customButton(context, "LOG IN", ()  async {
                    String? errorMessage;
                    if(emailTextController.text != "" && passwordTextController.text != "") {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailTextController.text,
                            password: passwordTextController.text);
                      } on FirebaseAuthException catch (error) {
                        switch (error.code) {
                          case "ERROR_EMAIL_ALREADY_IN_USE":
                          case "account-exists-with-different-credential":
                          case "email-already-in-use":
                            errorMessage = "Email already used. Go to login page.";
                            break;
                          case "ERROR_WRONG_PASSWORD":
                          case "wrong-password":
                            errorMessage = "Wrong email/password combination.";
                            break;
                          case "ERROR_USER_NOT_FOUND":
                          case "user-not-found":
                            errorMessage = "No user found with this email.";
                            break;
                          case "ERROR_USER_DISABLED":
                          case "user-disabled":
                            errorMessage = "User disabled.";
                            break;
                          case "ERROR_TOO_MANY_REQUESTS":
                            errorMessage = "Too many requests to log into this account.";
                            break;
                          case "ERROR_OPERATION_NOT_ALLOWED":
                          case "operation-not-allowed":
                            errorMessage = "Server error, please try again later.";
                            break;
                          case "ERROR_INVALID_EMAIL":
                          case "invalid-email":
                            errorMessage = "Email address is invalid.";
                            break;
                          default:
                            break;
                        }
                      } catch( otherException) {
                        errorMessage = otherException.toString();
                      }
                      if(errorMessage == null && mounted) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        return;
                      }
                    } else {
                      errorMessage = "You need to fulfill both e-mail and password text fields!";
                    }
                    Fluttertoast.showToast(
                          msg: "Error: ${errorMessage.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0
                    );
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
