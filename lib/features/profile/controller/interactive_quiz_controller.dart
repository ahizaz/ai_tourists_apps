import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InteractiveQuizController extends GetxController {
  // Observable variables
  var currentQuestionIndex = 0.obs;
  var score = 0.obs;
  var selectedAnswer = Rx<String?>(null);
  var hasAnswered = false.obs;
  var isQuizComplete = false.obs;

  // Quiz data - can be populated from ProfileController or API
  List<Map<String, dynamic>> questions = [
    {
      'question': 'Which ancient wonder was located in Babylon?',
      'options': [
        'The Great Pyramid of Giza',
        'Hanging Gardens',
        'Temple of Artemis',
        'Colossus of Rhodes',
      ],
      'correctAnswer': 'Hanging Gardens',
    },
    {
      'question': 'Who was the first emperor of Rome?',
      'options': [
        'Julius Caesar',
        'Augustus',
        'Nero',
        'Constantine',
      ],
      'correctAnswer': 'Augustus',
    },
    {
      'question': 'Which city is known as the "City of Love"?',
      'options': [
        'Rome',
        'Paris',
        'Venice',
        'Vienna',
      ],
      'correctAnswer': 'Paris',
    },
    {
      'question': 'What is the tallest building in the world?',
      'options': [
        'Shanghai Tower',
        'Burj Khalifa',
        'One World Trade Center',
        'Taipei 101',
      ],
      'correctAnswer': 'Burj Khalifa',
    },
    {
      'question': 'Which country is home to the ancient city of Petra?',
      'options': [
        'Egypt',
        'Jordan',
        'Turkey',
        'Greece',
      ],
      'correctAnswer': 'Jordan',
    },
  ];

  @override
  void onInit() {
    super.onInit();
   
  }

  // Getters
  int get totalQuestions => questions.length;
  
  Map<String, dynamic> get currentQuestion => questions[currentQuestionIndex.value];
  
  double get progress => (currentQuestionIndex.value + 1) / totalQuestions;
  
  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  // Methods
  void selectAnswer(String answer) {
    if (!hasAnswered.value) {
      selectedAnswer.value = answer;
      // Light haptic feedback on selection
      HapticFeedback.selectionClick();
    }
  }

  bool isCorrectAnswer(String answer) {
    return answer == currentQuestion['correctAnswer'];
  }

  void checkAnswer() {
    if (selectedAnswer.value != null) {
      hasAnswered.value = true;
      
      if (isCorrectAnswer(selectedAnswer.value!)) {
        score.value++;
        // Success haptic feedback
        HapticFeedback.mediumImpact();
      
      } else {
        // Error haptic feedback
        HapticFeedback.heavyImpact();
     
      }
    }
  }

  void nextQuestion() {
    if (isLastQuestion) {
      // Quiz is complete
      isQuizComplete.value = true;
    } else {
      // Move to next question
      currentQuestionIndex.value++;
      selectedAnswer.value = null;
      hasAnswered.value = false;
    }
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    selectedAnswer.value = null;
    hasAnswered.value = false;
    isQuizComplete.value = false;
  }

  
  void loadQuestionsFromProfile(List<Map<String, dynamic>> qaQuestions) {
    questions = qaQuestions.map((q) {
      return {
        'question': q['question'].toString().replaceFirst(RegExp(r'^Q\d+:\s*'), ''),
        'options': (q['options'] as List).map((opt) {
          return opt.toString().replaceFirst(RegExp(r'^[A-D]\)\s*'), '');
        }).toList(),
        'correctAnswer': q['correctAnswer'].toString().replaceFirst(RegExp(r'^[A-D]\)\s*'), ''),
      };
    }).toList();
  }
}
