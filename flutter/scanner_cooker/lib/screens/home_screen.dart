import 'package:flutter/material.dart';
import 'package:scanner_cooker/screens/auth/signin_screen.dart';
import 'package:scanner_cooker/screens/recipes_screen.dart';
import 'package:scanner_cooker/screens/show_recipes/show_recipes_page.dart';

import '../utils/color_utils.dart';
import '../utils/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
          decoration: BoxDecoration(color:
              stringToColorInHex("91e5f6")
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  customButton(context, "CREATE PRODUCTS LIST", () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => const RecipesScreen()));
                  }),
                  const SizedBox(
                    height: 40
                  ),
                  customButton(context, "SHOW THE RECIPES", () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => const ShowRecipesPage()));
                  }),
                  const SizedBox(
                    height: 40
                  ),
                  customButton(context, "LOG OUT", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  }),
              ])
            )
          )
        )
    );
  }
}