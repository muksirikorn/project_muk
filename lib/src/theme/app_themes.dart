import 'package:flutter/material.dart';

class AppTheme {
  ThemeData appThemes() {
    return ThemeData(fontFamily: 'Kanit');
  }

  static const String IMAGE_DIR_CAR = 'assets/images';
  static const String IMAGE_CAR = '$IMAGE_DIR_CAR/car.png';

  static const Color PRIMARY_COLOR = Color(0xFF212121);
  static const Color ORANGE_COLOR = Color(0xFFD56343);
  static const Color B_COLOR = Color(0xFFC2EAF6);
  static const Color BK_COLOR = Color(0xFF686A73);
  static const Color GG_COLOR = Color(0xFFB9F6CA);
  static const Color YEOLLOW_COLOR = Color(0xFFFFF176);
  static const Color WHITE_COLOR = Color(0xFFFFFFFF);
  static const Color BLACK_COLOR = Color(0xFF000000);
  static const Color GREEN_COLOR = Color(0xFF00C853);

  static const String PROMPT_REGULAR = 'Prompt_Regular';
  static const String PROMPT_MEDIUM = 'Prompt_Medium';
}
