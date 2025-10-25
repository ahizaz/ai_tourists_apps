import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController{
  final TextEditingController pinputController = TextEditingController();
  final RxString pin = "".obs;
  final RxInt secondsRemaining = 30.obs;
  Timer? _timer;
  @override
  void onInit() {
   
    super.onInit();
    startTimer();
  }

  void startTimer({int seconds =10}){
    _timer?.cancel();
    secondsRemaining.value =seconds;
    _timer =Timer.periodic(Duration(seconds: 1),(timer){
     if(secondsRemaining.value>0){
      secondsRemaining.value--;

     }else{
      timer.cancel();
     }
    });
  }
  void resendCode(){
    if(secondsRemaining.value==0){
          startTimer();

    }else{
    
    }
  }

  void onChanged(String value){
    pin.value = value;
  }
    void onCompleted(String value) {
    pin.value = value;
    verifyPin();
  }
   Future<void> verifyPin() async {

  
  }

    @override
  void onClose() {
    _timer?.cancel();
    pinputController.dispose();
    super.onClose();
  }

}