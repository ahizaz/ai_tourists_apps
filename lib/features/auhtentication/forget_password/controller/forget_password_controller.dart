import 'dart:convert';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/forget_verification/screen/forget_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordController extends GetxController {
  final TextEditingController forgetpassword = TextEditingController();
  RxBool isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    debugPrint("ForgetPasswordController Init");

    forgetpassword.addListener(() {
      final text = forgetpassword.text.trim();
      isEmailValid.value = text.isNotEmpty;
      debugPrint(" Input Changed: $text");
    });
  }

  void onNextPressed() async {
    final input = forgetpassword.text.trim();

    debugPrint("Next Button Pressed");
    debugPrint(" User Input: $input");

    if (input.isEmpty) {
      EasyLoading.showError('Input is empty');
      debugPrint(" Input Empty");
      return;
    }

    EasyLoading.show(status: 'Sending OTP...');
    debugPrint(" EasyLoading Showed");

    try {
      debugPrint(" API URL: ${Url.forgetpassword}");
      debugPrint(" Request Body: { email: $input }");

      final response = await http.post(
        Uri.parse(Url.forgetpassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": input,
        }),
      );

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'OTP Sent');

        final userEmail = input;
        forgetpassword.clear();
        debugPrint(" TextField Cleared");

        Get.to(() => ForgetVerification(email: userEmail));
        debugPrint(" Navigated to ForgetVerification with email: $userEmail");
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Request Failed');
        debugPrint(" API Failed");
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Server Error');
      debugPrint(" Exception Error: $e");
    }
  }

  @override
  void onClose() {
    forgetpassword.dispose();
    debugPrint(" ForgetPasswordController Disposed");
    super.onClose();
  }
}
