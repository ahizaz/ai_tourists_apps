import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class SelectQa extends StatelessWidget {
  const SelectQa({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          'Q&A List ${controller.qaAnswers.length}/${controller.qaQuestions.length}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.qaQuestions.length,
              itemBuilder: (context, index) {
                final question = controller.qaQuestions[index];
                return _buildQuestionCard(
                  context,
                  controller,
                  index,
                  question['question'],
                  List<String>.from(question['options']),
                );
              },
            ),
          ),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    ProfileController controller,
    int questionIndex,
    String question,
    List<String> options,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => _buildOptionTile(
            controller,
            questionIndex,
            option,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    ProfileController controller,
    int questionIndex,
    String option,
  ) {
    return Obx(() {
      final isSelected = controller.isAnswerSelected(questionIndex, option);
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            if (isSelected) {
              // If already selected, unselect it
              controller.qaAnswers.remove(questionIndex);
            } else {
              // Select this option
              controller.selectAnswer(questionIndex, option);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xffE8F5E9) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xff4CAF50) : const Color(0xffE0E0E0),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? const Color(0xff2E7D32) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xff4CAF50) : const Color(0xffBDBDBD),
                      width: 2,
                    ),
                    color: isSelected ? const Color(0xff4CAF50) : Colors.white,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton(ProfileController controller) {
    return Obx(() {
      final canSubmit = controller.canSubmitQA;
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: canSubmit ? () => controller.submitQA() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSubmit ? const Color(0xffFF6B35) : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Submit Q&A',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: canSubmit ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}