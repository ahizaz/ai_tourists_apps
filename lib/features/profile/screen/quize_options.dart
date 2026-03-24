import 'package:ai_powered_tourists_app/features/profile/screen/interactive_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';
import '../controller/interactive_quiz_controller.dart';
import '../services/play_quize.dart';

class QuizeOptions extends StatelessWidget {
  const QuizeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Question Quantity',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff252525),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  _buildQuantityOption(controller, '10 Q&A', 10),
                  const SizedBox(width: 16),
                  _buildQuantityOption(controller, '20 Q&A', 20),
                  const SizedBox(width: 16),
                  _buildQuantityOption(controller, '30 Q&A', 30),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Q&A Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView(
                  children: [
                    _buildSubjectOption(
                      controller,
                      'History',
                      'Test your knowledge of ancient events, empires, and heritage',
                    ),
                    const SizedBox(height: 12),
                    _buildSubjectOption(
                      controller,
                      'Culture',
                      'Discover local customs, art, and stories from around the world.',
                    ),
                    const SizedBox(height: 12),
                    _buildSubjectOption(
                      controller,
                      'Food',
                      'Guess famous dishes, flavors, and culinary traditions',
                    ),
                    // const SizedBox(height: 12),
                    // _buildSubjectOption(
                    //   controller,
                    //   'Landmarks',
                    //   'Challenge yourself to identify iconic places and monuments',
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.canStartQuiz
                      ? () async {
                          final selectedCount =
                              controller.selectedQuantity.value ?? 10;
                          final lat =
                              controller.cameraPosition.value.target.latitude;
                          final lng =
                              controller.cameraPosition.value.target.longitude;

                          debugPrint(
                            'Requesting quiz for ($lat, $lng) count: $selectedCount',
                          );

                          final selectedSubjectValue =
                              controller.selectedSubject.value;
                          final topics = selectedSubjectValue != null
                              ? [selectedSubjectValue.trim().toLowerCase()]
                              : ['food'];

                          final quizData =
                              await PlayQuizeService.fetchLocationQuiz(
                                latitude: lat,
                                longitude: lng,
                                count: selectedCount,
                                topics: topics,
                              );

                          if (quizData.isNotEmpty) {
                            final quizController = Get.put(
                              InteractiveQuizController(),
                            );
                            quizController.questions = quizData;
                            Get.to(() => const InteractiveQuizScreen());
                          } else {
                            Get.snackbar(
                              'Quiz',
                              'Failed to load quiz. Please try again.',
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.canStartQuiz
                        ? const Color(0xffFF6B35)
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Q&A',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: controller.canStartQuiz
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityOption(
    ProfileController controller,
    String label,
    int value,
  ) {
    final isSelected = controller.selectedQuantity.value == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectQuantity(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xffE5F5B4) : Color(0xffFFFFFF),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Color(0xff505050) : Color(0xff878787),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xff8BC34A)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xff8BC34A)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildSubjectOption(
    ProfileController controller,
    String title,
    String description,
  ) {
    final isSelected = controller.selectedSubject.value == title;

    return GestureDetector(
      onTap: () => controller.selectSubject(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xffE5F5B4) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff878787),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xff8BC34A)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff8BC34A)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
