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
      // এখন শুধু ফাঁকা না থাকলেই valid ধরা হবে
      isEmailValid.value = text.isNotEmpty;
    });
  }

  void onNextPressed() {
    final input = forgetpassword.text.trim();
    if (input.isEmpty) {
      Get.snackbar('Error', 'Please enter your email or phone number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Snackbar না দেখিয়ে সরাসরি অন্য পেজে যাওয়ার আগে TextField clear করে দিচ্ছি
    forgetpassword.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      Get.to(() => ForgetVerification());
    });
  }
}
