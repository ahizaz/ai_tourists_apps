import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/screen/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignInController extends GetxController {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> signIn() async {
    final email = emailOrPhoneController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("=== SignIn Started ===");
    debugPrint("Email: $email");
    debugPrint("Password: ${password.isNotEmpty ? '***' : 'empty'}");

    // Basic validation
    if (email.isEmpty) {
      EasyLoading.showError("Enter email");
      return;
    }
    if (password.isEmpty) {
      EasyLoading.showError("Enter password");
      return;
    }

    try {
      EasyLoading.show(status: "Signing in...");
      debugPrint("API URL: ${Url.signin}");

      final response = await http.post(
        Uri.parse(Url.signin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Raw Response Body: ${response.body}");

      // Dismiss loading first
      EasyLoading.dismiss();

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          debugPrint("✅ Parsed Response: $data");

          // Check if access token exists in response (inside 'data' object)
          if (data['data'] != null &&
              data['data']['access'] != null &&
              data['data']['access'].toString().isNotEmpty) {
            final accessToken = data['data']['access'];
            debugPrint("🔑 Access Token received from API: $accessToken");

            // Save access token
            Get.find<StorageService>().saveAccessToken(accessToken);
            debugPrint("✅ Access Token saved successfully");

            // Save refresh token if available
            if (data['data']['refresh'] != null &&
                data['data']['refresh'].toString().isNotEmpty) {
              final refreshToken = data['data']['refresh'];
              debugPrint("🔑 Refresh Token received from API: $refreshToken");
              Get.find<StorageService>().saveRefreshToken(refreshToken);
              debugPrint("✅ Refresh Token saved successfully");
            }

            // Show success message
            await EasyLoading.showSuccess("SignIn Successful");

            // Clear fields
            emailOrPhoneController.clear();
            passwordController.clear();
            rememberMe.value = false;

            debugPrint("🎉 SignIn Success - Navigating to Home");

            // Navigate to home
            await Future.delayed(const Duration(milliseconds: 500));
            Get.offAll(() => BottomNavbar());
          } else {
            debugPrint("❌ No access token in response");
            EasyLoading.showError("Invalid response from server");
          }
        } catch (parseError) {
          debugPrint("❌ Error parsing response: $parseError");
          EasyLoading.showError("Invalid server response");
        }
      } else {
        // Handle error response
        try {
          final data = jsonDecode(response.body);
          debugPrint("❌ SignIn Failed: $data");

          // Extract error message
          String errorMessage = "SignIn failed";
          if (data['message'] != null) {
            errorMessage = data['message'];
          } else if (data['error'] != null) {
            errorMessage = data['error'];
          } else if (data['detail'] != null) {
            errorMessage = data['detail'];
          } else if (data['non_field_errors'] != null) {
            errorMessage = data['non_field_errors'][0] ?? errorMessage;
          }

          EasyLoading.showError(errorMessage);
        } catch (e) {
          debugPrint("❌ Error parsing error response: $e");
          EasyLoading.showError("Invalid email or password");
        }
      }
    } catch (e, s) {
      EasyLoading.dismiss();
      debugPrint("❌ SignIn Error: $e");
      debugPrint("StackTrace: $s");

      // Check for specific network errors
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        EasyLoading.showError("No internet connection");
      } else if (e.toString().contains('TimeoutException')) {
        EasyLoading.showError("Request timeout");
      } else {
        EasyLoading.showError("Something went wrong");
      }
    }

    debugPrint("=== SignIn Ended ===");
  }

  @override
  void onClose() {
    // Dispose controllers to free resources
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
