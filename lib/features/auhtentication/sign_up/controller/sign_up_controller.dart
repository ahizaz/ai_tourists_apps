import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
    final TextEditingController nameController = TextEditingController();
   
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
   void signUP() {
    final emailOrPhone = emailOrPhoneController.text.trim();
    final password = passwordController.text.trim();
    final name =nameController.text.trim();
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
    if(name.isEmpty){
       Get.snackbar('Error', 'Please enter name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }


    debugPrint(
        'Sign in requested: email/phone="$emailOrPhone", password="$password", remember=$remember',  );

  }
    @override
  void onClose() {
    // Dispose controllers to free resources
    emailOrPhoneController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.onClose();
  }

}