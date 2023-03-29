import 'package:flutter/material.dart';

Image placeImgIntoWidget(String imagePath) {
  return Image.asset(
    imagePath,
    fit: BoxFit.fitWidth,
    width: 250,
    height: 250,
    color: Colors.white
  );
}