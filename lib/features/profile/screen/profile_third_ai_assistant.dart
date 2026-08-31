
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/widget/options_tile.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_last_ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileThirdAiAssistant extends StatelessWidget {
  const ProfileThirdAiAssistant({super.key});

  Widget _topProgress(int step) {
    return Row(
      children: List.generate(3, (index) {
        final active = (index + 1) == step;

        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF9ED12E)
                  : const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    // Localization keys
    final types = <String>[
      'historical_focus',
      'artistic_focus',
      'fun_facts',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          child: Column(
            children: [
              // --------------------------------------------------
              // Back Button
              // --------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              _topProgress(3),

              SizedBox(height: 18.h),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ai_preferences_voice'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'step_three_of_three'.tr,
                  style: TextStyle(
                    color: const Color(0xFF9B9B9B),
                    fontSize: 12.sp,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ai_visit_focus'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: types.map((item) {
                        return OptionTile(
                          label: item.tr,
                          selected: controller.voiceTypes.any(
                            (selectedItem) =>
                                selectedItem.toLowerCase() ==
                                item.toLowerCase(),
                          ),
                          isCheckbox: true,
                          onTap: () {
                            final success = controller.toggleVoiceType(
                              item.toLowerCase(),
                            );

                            if (!success) {
                              Get.snackbar(
                                'limit_reached'.tr,
                                'voice_type_selection_limit'.trParams({
                                  'count': controller.maxVoiceTypesSelections
                                      .toString(),
                                }),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black87,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(12.w),
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  }),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  final success = await controller.updateAiPreferences();

                  if (success) {
                    Get.to(
                      () => const ProfileLastAiAssistant(),
                    );
                  }
                },
                child: Container(
                  height: 52.h,
                  margin: EdgeInsets.only(top: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF05A1B),
                        Color(0xFFF7C64A),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'complete_btn'.tr,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}