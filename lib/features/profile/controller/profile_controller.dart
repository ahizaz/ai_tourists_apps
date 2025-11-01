import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
  var profileImage = Rx<File?>(null);
  var userName = "Brooklyn Simmons".obs;
  var userEmail = "brooklyn.sim@example.com".obs;
  var phoneNumber = "+880 10-46-828200".obs;
  var selectedPlan = RxnString();
  
  // Quiz options
  var selectedQuantity = RxnInt();
  var selectedSubject = RxnString();
  
  // Computed property to check if quiz can start
  bool get canStartQuiz => selectedQuantity.value != null && selectedSubject.value != null;
  
  Future<void>pickImage()async{
     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(pickedFile!=null){
      profileImage.value = File(pickedFile.path);
     }
  }

  void selectSubscriptionPlan(String plan) {
    if (selectedPlan.value == plan) {
      selectedPlan.value = null; // Unselect if same plan clicked again
    } else {
      selectedPlan.value = plan;
    }
  }


  void subscribeNow() {
    if (selectedPlan.value != null) {
  
    }
  }

  // Quiz selection methods
  void selectQuantity(int quantity) {
    selectedQuantity.value = quantity;
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void resetQuizOptions() {
    selectedQuantity.value = null;
    selectedSubject.value = null;
  }
}