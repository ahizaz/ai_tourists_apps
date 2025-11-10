import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LocalizationService extends GetxController {
  static const String _storageKey = 'selected_language';
  final storage = GetStorage();
  
  // Available locales
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale frenchLocale = Locale('fr', 'FR');
  static const Locale spanishLocale = Locale('es', 'ES');
  
  // Supported locales list
  static const List<Locale> supportedLocales = [
    englishLocale,
    frenchLocale,
    spanishLocale,
  ];
  
  // Default locale
  static const Locale fallbackLocale = englishLocale;
  
  // Language names
  static const Map<String, String> languageNames = {
    'en_US': 'English',
    'fr_FR': 'Français',
    'es_ES': 'Español',
  };
  
  // Observable current locale
  final Rx<Locale> currentLocale = englishLocale.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  // Load saved language from storage
  void _loadSavedLanguage() {
    final savedLanguage = storage.read(_storageKey);
    if (savedLanguage != null) {
      final locale = _getLocaleFromString(savedLanguage);
      currentLocale.value = locale;
      Get.updateLocale(locale);
    }
  }
  
  // Convert string to Locale
  Locale _getLocaleFromString(String localeString) {
    switch (localeString) {
      case 'en_US':
        return englishLocale;
      case 'fr_FR':
        return frenchLocale;
      case 'es_ES':
        return spanishLocale;
      default:
        return fallbackLocale;
    }
  }
  
  // Change language
  Future<void> changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    await storage.write(_storageKey, '${locale.languageCode}_${locale.countryCode}');
    Get.updateLocale(locale);
  }
  
  // Get current language name
  String getCurrentLanguageName() {
    return languageNames['${currentLocale.value.languageCode}_${currentLocale.value.countryCode}'] ?? 'English';
  }
  
  // Check if locale is current
  bool isCurrentLocale(Locale locale) {
    return currentLocale.value.languageCode == locale.languageCode &&
           currentLocale.value.countryCode == locale.countryCode;
  }
}
