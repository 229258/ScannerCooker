
import 'package:flutter/material.dart';

Container customButton(BuildContext context, String text, Function logic) {
  return Container (
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(70)),
    child: ElevatedButton(
      onPressed:  () {
        logic();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith( (states) {
          if(states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        )
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
        )
      )
    )
  );
}