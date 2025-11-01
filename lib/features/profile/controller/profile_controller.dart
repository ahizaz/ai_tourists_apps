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
    if (selectedQuantity.value == quantity) {
      selectedQuantity.value = null; // Unselect if same quantity clicked again
    } else {
      selectedQuantity.value = quantity;
    }
  }

  void selectSubject(String subject) {
    if (selectedSubject.value == subject) {
      selectedSubject.value = null; // Unselect if same subject clicked again
    } else {
      selectedSubject.value = subject;
    }
  }

  void resetQuizOptions() {
    selectedQuantity.value = null;
    selectedSubject.value = null;
  }

  // Q&A List functionality
  var qaAnswers = <int, String>{}.obs; // Map of question index to selected answer
  
  final List<Map<String, dynamic>> qaQuestions = [
    {
      'question': 'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes'
      ],
      'correctAnswer': 'B) Hanging Gardens'
    },
    {
      'question': 'Q1: Who was the first emperor of Rome?',
      'options': [
        'A) Julius Caesar',
        'B) Augustus',
        'C) Nero',
        'D) Constantine'
      ],
      'correctAnswer': 'B) Augustus'
    },
    {
      'question': 'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes'
      ],
      'correctAnswer': 'C) Temple of Artemis'
    },
  ];

  void selectAnswer(int questionIndex, String answer) {
    qaAnswers[questionIndex] = answer;
  }

  bool isAnswerSelected(int questionIndex, String answer) {
    return qaAnswers[questionIndex] == answer;
  }

  bool get canSubmitQA => qaAnswers.length == qaQuestions.length;

  void submitQA() {
    if (canSubmitQA) {
      // Calculate score
      int correctCount = 0;
      for (int i = 0; i < qaQuestions.length; i++) {
        if (qaAnswers[i] == qaQuestions[i]['correctAnswer']) {
          correctCount++;
        }
      }
      // Handle submission (navigate to results, etc.)
      Get.snackbar(
        'Quiz Completed',
        'You got $correctCount out of ${qaQuestions.length} correct!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetQAAnswers() {
    qaAnswers.clear();
  }
}