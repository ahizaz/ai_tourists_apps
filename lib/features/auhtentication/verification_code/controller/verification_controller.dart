// ...existing code...
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final TextEditingController pinputController = TextEditingController();
  var pin = ''.obs;

  
  var secondsRemaining = 0.obs;
  Timer? _timer;
  final int _startSeconds = 10;

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
    _timer?.cancel();
    super.onClose();
  }

  // Start the countdown — call this only when user clicks "Resend"
  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = _startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 1) {
        timer.cancel();
        secondsRemaining.value = 0;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  // Called when user taps "Resend" in the UI
  void resendCode() {
    startTimer();
  }

  void onChanged(String value) => pin.value = value;
  void onCompleted(String value) {
    // handle completed pin entry
  }
}
// ...existing code...