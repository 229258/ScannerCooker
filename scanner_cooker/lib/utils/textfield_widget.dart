import 'package:flutter/material.dart';

TextField inputField(IconData icon, String text, bool isPassword, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.purple,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none)
      ),
    )
  );
}