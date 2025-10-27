import 'package:ai_powered_tourists_app/features/auhtentication/forget_verification/screen/forget_verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController forgetpassword = TextEditingController();

  RxBool isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    forgetpassword.addListener(() {
      final text = forgetpassword.text.trim();
      // চেক করবো text ফাঁকা না আর '@' আছে কিনা
      isEmailValid.value = text.isNotEmpty && text.contains('@');
    });
  }

  void onNextPressed() {
    final email = forgetpassword.text.trim();
    if (!email.contains('@')) {
      Get.snackbar('Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar('Success', 'Reset link sent to $email',
        snackPosition: SnackPosition.BOTTOM);
         Future.delayed(const Duration(milliseconds: 100), () {
      Get.to(() => ForgetVerification());
    });
  }
}
