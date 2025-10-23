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
      ),
    );
  }
}