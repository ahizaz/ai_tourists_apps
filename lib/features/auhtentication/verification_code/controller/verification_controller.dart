
import 'dart:async';
import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VerificationController extends GetxController {
  final TextEditingController pinputController = TextEditingController();
  var pin = ''.obs;
  final String email  = Get.arguments??"";
  
  var secondsRemaining = 0.obs;
  Timer? _timer;
  

  @override
  void onInit() {
    super.onInit();
    debugPrint("VerificationController Initialized");
    debugPrint("Email Received : $email");
 
    pinputController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    pin.value = pinputController.text;
    debugPrint("OTP Typing :${pin.value}");
  }
  void onChanged(String value){
    pin.value =value;
     debugPrint("🔄 OTP Changed: $value");
  }
  void onCompleted(String value){
       pin.value = value;
    debugPrint(" OTP Completed: $value");
  }

  Future<void>resendCode()async{
    debugPrint("Resend Button Clicked");
    EasyLoading.show(status: "Resending OTP...");
    try{
      final response = await http.post(
        Uri.parse(Url.verifyotp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email":email}),
      );
      debugPrint("Resend APi Response :${response.statusCode}");
      debugPrint("Response Body :${response.body}");
       EasyLoading.dismiss();
       if(response.statusCode==200 || response.statusCode==201){
        EasyLoading.showSuccess("OTP Sent Successfully");
        startTimer();
       }else{
         EasyLoading.showError("Failed to resend OTP");

       }
    }catch(e){
       debugPrint("🔥 Resend Error: $e");
      EasyLoading.showError("Something went wrong");
    }
  }
  
  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 1) {
        timer.cancel();
        secondsRemaining.value = 0;
      } else {
        secondsRemaining.value--;
      }
    });
  }
   Future<void> verifyOtp() async {
    debugPrint("🚀 Verify Button Clicked");

    if (pin.value.trim().length != 6) {
      debugPrint("❌ Invalid OTP Length: ${pin.value}");
      EasyLoading.showError("Enter valid OTP");
      return;
    }

    debugPrint("📤 VERIFY API BODY: { email: $email, otp_code: ${pin.value.trim()} }");

    try {
      EasyLoading.show(status: "Verifying...");

      final response = await http.post(
        Uri.parse(Url.verifyotp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp_code": pin.value.trim()}),
      );

      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("✅ Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("🎉 OTP VERIFIED SUCCESS");
        
        // Save access token
        if (data['data'] != null && data['data']['access'] != null) {
          final accessToken = data['data']['access'];
          Get.find<StorageService>().saveAccessToken(accessToken);
          debugPrint("🔑 Access Token Saved: $accessToken");
        }
        
        EasyLoading.showSuccess("Verification Successful");
        Get.to(() => AiAssistant());
      } else {
        debugPrint("❌ OTP VERIFY FAILED: $data");
        EasyLoading.showError(data["message"] ?? "OTP Verification Failed");
      }
    } catch (e, s) {
      debugPrint("🔥 VERIFY ERROR: $e");
      debugPrint("📛 STACK TRACE: $s");
      EasyLoading.showError("Something went wrong");
    }
  }

  @override
  void onClose() {
  debugPrint(" VerificationController Disposed");
    pinputController.dispose();
    _timer?.cancel();
   
    super.onClose();
  }
}
// ...existing code...