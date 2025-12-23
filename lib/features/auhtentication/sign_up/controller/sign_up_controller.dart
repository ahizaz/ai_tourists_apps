import 'dart:convert';

import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/verification_code/screen/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
 Future<void>signUp()async{
  final email = emailOrPhoneController.text.trim();
  final password = passwordController.text.trim();
  final name = nameController.text.trim();
   debugPrint("Signup Input:");
    debugPrint("Name: $name");
    debugPrint("Email: $email");
    debugPrint("Password: $password");
  if (name.isEmpty){
    EasyLoading.showError("Enter name");
    return;
  }
  if(email.isEmpty){
    EasyLoading.showError("Enter email");
    return;
  }
  if(password.isEmpty){
    EasyLoading.showError("Enter password");
    return;
  }
  try{
    EasyLoading.show(status: "Signing up...");
    debugPrint(" API URL: ${Url.signup}");
    final response = await http.post( 
    Uri.parse(Url.signup),
    headers: {
      "Content-Type":"application/json",
    },
    body: jsonEncode(
       {

        "email":email,
        "password":password,
        "name":name,
       }
    ),
    );
        debugPrint(" Status Code: ${response.statusCode}");
      debugPrint("Raw Response Body: ${response.body}");
    final data = jsonDecode(response.body);
    if(response.statusCode ==200 || response.statusCode==201){
        EasyLoading.showSuccess("Signup Successful");
        //clearFields
        nameController.clear();
        emailOrPhoneController.clear();
        passwordController.clear();
        rememberMe.value=false;

        // Persist name and email so profile/home show correct values
        try {
          final storage = Get.find<StorageService>();
          storage.saveUserName(name);
          storage.saveUserEmail(email);
        } catch (e) {
          debugPrint('Error saving signup info to storage: $e');
        }

       Get.to(() => const Verification(),arguments: email);  

    }else{
        debugPrint(" Signup Failed Response: $data");
      EasyLoading.showError(
         data["message"] ?? "Signup failed",
      );
    }

  }catch(e,s){
    debugPrint("Signup Error: $e");
        debugPrint(" StackTrace: $s");
   EasyLoading.showError("Something went wrong");
      
  }

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