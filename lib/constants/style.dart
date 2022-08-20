import 'package:flutter/material.dart';
import '../../constants/extensions.dart';

class TextStyles {
  static TextStyle get mediumText => const TextStyle(fontSize: 16);

  static TextStyle get titleText => const TextStyle(fontSize: 20);

  static TextStyle get smallText => const TextStyle(fontSize: 12);
}

class ButtonStyles {
  static ButtonStyle get elevatedButtonFill => ElevatedButton.styleFrom(
      primary: Colors.blue, textStyle: TextStyles.mediumText.white);

  static ButtonStyle get elevatedButtonHolo => ElevatedButton.styleFrom(
      primary: Colors.white, textStyle: TextStyles.mediumText.blue);
}

class MyColors {
  static Color get primaryColor => Colors.blue;

  static Color get secondaryColor => const Color(0xFF14224A);
  static Color get red => Colors.red;
  static Color get green => Colors.green;
}

class TextFieldDecoration {
  static InputDecoration get roundedDecoration => InputDecoration(
        labelStyle: TextStyles.mediumText.copyWith(letterSpacing: 0),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(0),
      );

  static InputDecoration get underLine => InputDecoration(
        labelStyle: TextStyles.mediumText.copyWith(letterSpacing: 0),
        contentPadding: const EdgeInsets.all(0),
      );
}
