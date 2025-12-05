import 'dart:convert';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/reset_password/screen/reset_password.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgetVerificationController extends GetxController{
  final String email;
  final TextEditingController pinputController = TextEditingController();
  var pin = ''.obs;

  ForgetVerificationController({required this.email});
   @override
  void onInit() {
    super.onInit();
 
    pinputController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    pin.value = pinputController.text;
  }

  @override
  void onClose() {
    pinputController.removeListener(_onPinChanged);
    pinputController.dispose();
    super.onClose();
  }

  void onChanged(String value) => pin.value = value;
  
  void onCompleted(String value) {
    debugPrint("✅ OTP Completed: $value");
  }

  Future<void> verifyOtp(String otpCode) async {
    debugPrint("🚀 Verify Button Clicked");

    if (otpCode.trim().length != 6) {
      debugPrint("❌ Invalid OTP Length: $otpCode");
      EasyLoading.showError("Enter valid OTP");
      return;
    }

    debugPrint("📤 VERIFY API BODY: { email: $email, otp_code: $otpCode }");

    try {
      EasyLoading.show(status: "Verifying...");

      debugPrint("🌐 API URL: ${Url.verifyotp}");

      final response = await http.post(
        Uri.parse(Url.verifyotp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "otp_code": otpCode,
        }),
      );

      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("🎉 OTP VERIFIED SUCCESS");
        
        // Extract access token from response for password reset
        if (data['data'] != null && data['data']['access'] != null) {
          final String accessToken = data['data']['access'];
          debugPrint("🔑 Access Token Received: $accessToken");
          EasyLoading.showSuccess("Verification Successful");
          
          // Remove listener before navigation to prevent disposed controller error
          pinputController.removeListener(_onPinChanged);
          
          Get.to(() => ResetPassword(token: accessToken));
          debugPrint("➡️ Navigated to ResetPassword with access token");
        } else {
          debugPrint("⚠️ Access token not found in response");
          debugPrint("🔍 Response Data: $data");
          EasyLoading.showError("Token not received from server");
        }
      } else {
        debugPrint("❌ OTP Verification Failed: ${data['message']}");
        EasyLoading.showError(data['message'] ?? "OTP Verification Failed");
      }
    } catch (e) {
      debugPrint("🔥 Exception Error: $e");
      EasyLoading.showError("Something went wrong");
    }
  }


}