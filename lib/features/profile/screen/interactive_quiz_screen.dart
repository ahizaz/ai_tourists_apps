import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/interactive_quiz_controller.dart';
import '../widgets/answer_feedback_overlay.dart';
import 'package:ai_powered_tourists_app/utils/share_helper.dart';

class InteractiveQuizScreen extends StatelessWidget {
  const InteractiveQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InteractiveQuizController>();

    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SafeArea(
        child: Stack(
          children: [
            // Main quiz content
            Obx(() => controller.isQuizComplete.value
                ? _buildResultsScreen(controller)
                : _buildQuizContent(controller)),
            // Feedback overlay (only show when quiz is not complete)
            Obx(() {
              final hasAnswered = controller.hasAnswered.value;
              final selectedAnswer = controller.selectedAnswer.value;
              final isQuizComplete = controller.isQuizComplete.value;
              
              if (hasAnswered && selectedAnswer != null && !isQuizComplete) {
                final isCorrect = controller.isCorrectAnswer(selectedAnswer);
                return AnswerFeedbackOverlay(
                  isCorrect: isCorrect,
                  onComplete: () {
                    // Automatically move to next question after feedback animation
                    controller.nextQuestion();
                  },
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent(InteractiveQuizController controller) {
    return Column(
      children: [
        _buildHeader(controller),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Obx(() => Container(
              key: ValueKey(controller.currentQuestionIndex.value),
              child: _buildQuestionCard(controller),
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(InteractiveQuizController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => _showQuitDialog(),
              ),
              Expanded(
                child: Obx(() => LinearProgressIndicator(
                  value: controller.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFF6B35)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                )),
              ),
              SizedBox(width: 12.w),
              Obx(() => Text(
                '${controller.currentQuestionIndex.value + 1}/${controller.totalQuestions}',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff252525),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(InteractiveQuizController controller) {
    final question = controller.currentQuestion;
    
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            question['question'],
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff252525),
              height: 1.3,
            ),
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: ListView.builder(
              itemCount: (question['options'] as List).length,
              itemBuilder: (context, index) {
                final option = question['options'][index];
                return _buildAnswerOption(controller, option, index);
              },
            ),
          ),
          _buildCheckButton(controller),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(InteractiveQuizController controller, String option, int index) {
    return Obx(() {
      final isSelected = controller.selectedAnswer.value == option;
      final hasAnswered = controller.hasAnswered.value;
      final isCorrect = controller.isCorrectAnswer(option);
      
      Color backgroundColor = Colors.white;
      Color borderColor = const Color(0xffE0E0E0);
      Color textColor = const Color(0xff252525);
      IconData? icon;
      Color? iconColor;

      if (hasAnswered) {
        if (isSelected) {
          if (isCorrect) {
            backgroundColor = const Color(0xffD4EDDA);
            borderColor = const Color(0xff28A745);
            textColor = const Color(0xff155724);
            icon = Icons.check_circle;
            iconColor = const Color(0xff28A745);
          } else {
            backgroundColor = const Color(0xffF8D7DA);
            borderColor = const Color(0xffDC3545);
            textColor = const Color(0xff721C24);
            icon = Icons.cancel;
            iconColor = const Color(0xffDC3545);
          }
        } else if (isCorrect) {
          // Show the correct answer even if not selected
          backgroundColor = const Color(0xffD4EDDA);
          borderColor = const Color(0xff28A745);
          textColor = const Color(0xff155724);
          icon = Icons.check_circle;
          iconColor = const Color(0xff28A745);
        }
      } else if (isSelected) {
        backgroundColor = const Color(0xffFFF4E6);
        borderColor = const Color(0xffFF6B35);
        textColor = const Color(0xff252525);
      }

      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: isSelected && hasAnswered ? 1.02 : 1.0,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              child: InkWell(
                onTap: hasAnswered ? null : () => controller.selectAnswer(option),
                borderRadius: BorderRadius.circular(16.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (icon != null)
                        AnimatedScale(
                          duration: const Duration(milliseconds: 400),
                          scale: hasAnswered ? 1.0 : 0.0,
                          curve: Curves.elasticOut,
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildCheckButton(InteractiveQuizController controller) {
    return Obx(() {
      final hasAnswered = controller.hasAnswered.value;
      final selectedAnswer = controller.selectedAnswer.value;

      // Hide button when answer has been checked (overlay is showing)
      if (hasAnswered) {
        return SizedBox(height: 76.h); // Maintain spacing
      }

      return Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: selectedAnswer == null
                ? null
                : () {
                    controller.checkAnswer();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedAnswer == null 
                ? Colors.grey.shade300 
                : const Color(0xffFF6B35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(
              'CHECK',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: selectedAnswer == null ? Colors.grey.shade600 : Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResultsScreen(InteractiveQuizController controller) {
    final score = controller.score.value;
    final total = controller.totalQuestions;
    final percentage = (score / total * 100).round();
    
    String emoji = '🎉';
    String title = 'Congratulations!';
    String message = 'You did great!';
    Color accentColor = const Color(0xff28A745);

    if (percentage >= 80) {
      emoji = '🎉';
      title = 'Outstanding!';
      message = 'You\'re a travel expert!';
      accentColor = const Color(0xff28A745);
    } else if (percentage >= 60) {
      emoji = '👏';
      title = 'Good Job!';
      message = 'You know your stuff!';
      accentColor = const Color(0xffFF6B35);
    } else if (percentage >= 40) {
      emoji = '💪';
      title = 'Not Bad!';
      message = 'Keep learning!';
      accentColor = const Color(0xffFFC107);
    } else {
      emoji = '📚';
      title = 'Keep Trying!';
      message = 'Practice makes perfect!';
      accentColor = const Color(0xffDC3545);
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: 100.sp),
                ),
                SizedBox(height: 24.h),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff252525),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff878787),
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Score',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff878787),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$score',
                            style: GoogleFonts.inter(
                              fontSize: 64.sp,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                          Text(
                            '/$total',
                            style: GoogleFonts.inter(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff878787),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$percentage% Correct',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff252525),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ShareHelper.shareQuizResult(
                        quizTitle: 'Interactive Quiz',
                        score: score,
                        total: total,
                        appLink: null,
                      );
                    },
                    icon: const Icon(Icons.share, color: Color(0xffFF6B35)),
                    label: Text(
                      'SHARE RESULT',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6B35),
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffFF6B35), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () => controller.restartQuiz(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'TRY AGAIN',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffFF6B35), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'BACK TO HOME',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6B35),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),  // SingleChildScrollView
        ),  // Padding
        );
      },
    );
  }

  void _showQuitDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Quit Quiz?',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to quit? Your progress will be lost.',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'CANCEL',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff878787),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close quiz
            },
            child: Text(
              'QUIT',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xffDC3545),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
