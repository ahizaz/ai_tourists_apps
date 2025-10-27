import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

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

  @override
  void onClose() {
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
