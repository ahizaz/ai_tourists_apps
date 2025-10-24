import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  // Text controllers for phone/email and password fields
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive state for password visibility and remember checkbox
  final RxBool isPasswordHidden = true.obs;
  final RxBool rememberMe = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle remember me checkbox (used by Checkbox onChanged)
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Example sign in action using the controllers (customize as needed)
  void signIn() {
    final emailOrPhone = emailOrPhoneController.text.trim();
    final password = passwordController.text.trim();
    final remember = rememberMe.value;

    // Basic validation example
    if (emailOrPhone.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number or email',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Please enter password',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // TODO: Add your sign-in logic here (API call, validation, etc.)
    debugPrint(
        'Sign in requested: email/phone="$emailOrPhone", password="$password", remember=$remember');

    // Optionally show loading, call API, handle response...
  }

  @override
  void onClose() {
    // Dispose controllers to free resources
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}