import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/screen/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkAutoLogin();
  }

  Future<void> checkAutoLogin() async {
    // Wait a bit for a better UX
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      debugPrint("🔍 Checking for saved access token...");
      final token = Get.find<StorageService>().getAccessToken();

      if (token != null && token.isNotEmpty) {
        debugPrint("✅ Auto-Login: Token found in SharedPreferences");
        debugPrint("🔑 Token: $token");
        debugPrint("🚀 Auto-Login: Navigating to home");

        // User is already logged in, go to home
        Get.offAll(() => BottomNavbar());
      } else {
        debugPrint("❌ Auto-Login: No token found in SharedPreferences");
        debugPrint("👉 User needs to login");
        // No token, stay on splash screen - user will manually navigate
      }
    } catch (e) {
      debugPrint("❌ Auto-Login Error: $e");
      // Error checking token, stay on splash screen
    }
  }
}
