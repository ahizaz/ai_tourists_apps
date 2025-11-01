import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

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
            const Text(
              'Select Question Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                _buildQuantityOption(controller, '10 Q&A', 10),
                const SizedBox(width: 16),
                _buildQuantityOption(controller, '20 Q&A', 20),
                const SizedBox(width: 16),
                _buildQuantityOption(controller, '30 Q&A', 30),
              ],
            )),
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
              child: Obx(() => ListView(
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
                  const SizedBox(height: 12),
                  _buildSubjectOption(
                    controller,
                    'Landmarks',
                    'Challenge yourself to identify iconic places and monuments',
                  ),
                ],
              )),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.canStartQuiz
                    ? () {
                        // Navigate to quiz screen
                        print('Starting quiz with ${controller.selectedQuantity.value} questions on ${controller.selectedSubject.value}');
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
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityOption(ProfileController controller, String label, int value) {
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
              color: isSelected ? const Color(0xffFF6B35) : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xff8BC34A) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xff8BC34A) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectOption(ProfileController controller, String title, String description) {
    final isSelected = controller.selectedSubject.value == title;
    
    return GestureDetector(
      onTap: () => controller.selectSubject(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xffFF6B35) : Colors.grey.shade300,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
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
                color: isSelected ? const Color(0xff8BC34A) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xff8BC34A) : Colors.grey.shade400,
                  width: 2,
                ),
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
    );
  }
}