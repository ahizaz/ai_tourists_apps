import 'dart:convert';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_in/screen/sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController {
  final String token;
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  ResetPasswordController({required this.token});

  final RxBool isNewPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  final RxBool isButtonEnabled = false.obs;

  void togglePasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void validatePasswords() {
    if (newPassword.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        newPassword.text == confirmPassword.text) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    newPassword.addListener(validatePasswords);
    confirmPassword.addListener(validatePasswords);
  }

  Future<void> resetPassword() async {
    debugPrint("🚀 Reset Password API Called");

    if (newPassword.text.isEmpty || confirmPassword.text.isEmpty) {
      EasyLoading.showError("Please fill all fields");
      return;
    }

    if (newPassword.text != confirmPassword.text) {
      EasyLoading.showError("Passwords do not match");
      return;
    }

    try {
      EasyLoading.show(status: "Resetting Password...");

      debugPrint("🌐 API URL: ${Url.resetPassword}");
      debugPrint("🔑 Using Token: $token");
      debugPrint("📤 Request Body: { new_password: ${newPassword.text} }");

      final response = await http.post(
        Uri.parse(Url.resetPassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "new_password": newPassword.text,
        }),
      );

      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("🎉 PASSWORD RESET SUCCESS");
        EasyLoading.showSuccess(data['message'] ?? "Password Reset Successful");
        
        // Clear token after successful reset
        debugPrint("🗑️ Token removed after successful reset");
        
        // Remove listeners before navigation to prevent disposed controller error
        newPassword.removeListener(validatePasswords);
        confirmPassword.removeListener(validatePasswords);
        
        // Clear password fields
        newPassword.clear();
        confirmPassword.clear();
        
        // Navigate to Sign In
        await Future.delayed(const Duration(seconds: 1));
        Get.to(() => SignIn());
        debugPrint("➡️ Navigated to SignIn");
      } else {
        debugPrint("❌ Password Reset Failed: ${data['message']}");
        EasyLoading.showError(data['message'] ?? "Password Reset Failed");
      }
    } catch (e) {
      debugPrint("🔥 Exception Error: $e");
      EasyLoading.showError("Something went wrong");
    }
  }

  @override
  void onClose() {
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
