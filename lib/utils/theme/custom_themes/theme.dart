import 'package:ai_powered_tourists_app/utils/theme/custom_themes/text_theme.dart';

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // fontFamily: 'Poppins'
    brightness: Brightness.light,
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextTheme.lightTextTheme,
    fontFamily: 'SFPro',
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // fontFamily: 'Poppins'
    brightness: Brightness.dark,
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.darkTextTheme,
    fontFamily: 'SFPro',
  );
}