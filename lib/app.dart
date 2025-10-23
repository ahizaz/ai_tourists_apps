import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen.dart';
import 'package:ai_powered_tourists_app/utils/theme/custom_themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AITourists extends StatelessWidget {
  const AITourists({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
        minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Tourists',
         theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: SplashScreen(),
      ),
    );
  }
}