import 'package:flutter/material.dart';
import '../../constants/style.dart';

extension MyTextStyle on TextStyle {
  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get red => copyWith(color: Colors.red);

  TextStyle get black => copyWith(color: Colors.black);

  TextStyle get blue => copyWith(color: Colors.blue);

  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get lightGreen => copyWith(color: Colors.lightGreen);

  TextStyle get secondaryColor => copyWith(color: MyColors.secondaryColor);
}

extension MyInputDecoration on InputDecoration {
  InputDecoration get withPadding =>
      copyWith(contentPadding: const EdgeInsets.all(16));
}

extension MyButtonStyle on ButtonStyle {
  ButtonStyle get withPadding => copyWith(
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)));

  ButtonStyle get withBorder => copyWith(
      side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: MyColors.primaryColor)));

  ButtonStyle get noElevation =>
      copyWith(elevation: MaterialStateProperty.all<double>(0));
}
