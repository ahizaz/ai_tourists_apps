import 'package:ai_powered_tourists_app/core/localization/app_translations.dart';
import 'package:ai_powered_tourists_app/core/localization/localization_service.dart';
import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen.dart';
import 'package:ai_powered_tourists_app/utils/theme/custom_themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AITourists extends StatelessWidget {
  const AITourists({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize localization service
    final localizationService = Get.put(LocalizationService());
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
        minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Tourists',
         theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // Localization settings
        translations: AppTranslations(),
        locale: localizationService.currentLocale.value,
        fallbackLocale: LocalizationService.fallbackLocale,
        supportedLocales: LocalizationService.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SplashScreen(),
      )),
    );
  }
}