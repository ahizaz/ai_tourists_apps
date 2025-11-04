
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_second_ai_assistant.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/widget/options_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFirstAiAssistant extends StatelessWidget {
  const ProfileFirstAiAssistant({super.key});

  Widget _topProgress(int step) {
    return Row(
      children: List.generate(3, (i) {
        final active = (i + 1) == step;
        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF9ED12E) : const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController ctrl = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 18.h),
          child: Column(
            children: [
              _topProgress(1),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'AI Preferences gander',
                      style: GoogleFonts.inter(fontSize: 18.sp, color: const Color(0xFF6B6B6B)),
                    ),
                  ),
                ],
              ),
              Align(alignment: Alignment.centerRight, child: Text('1/3', style: TextStyle(color: const Color(0xFF9B9B9B), fontSize: 12.sp))),
              SizedBox(height: 18.h),
              Align(alignment: Alignment.centerLeft, child: Text('AI Gander', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600))),
              SizedBox(height: 12.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: [
                        OptionTile(
                          label: 'Male',
                          selected: ctrl.gender.value == 'Male',
                          isCheckbox: false,
                          onTap: () => ctrl.selectGender('Male'),
                        ),
                        OptionTile(
                          label: 'Female',
                          selected: ctrl.gender.value == 'Female',
                          isCheckbox: false,
                          onTap: () => ctrl.selectGender('Female'),
                        ),
                        SizedBox(height: 120.h),
                      ],
                    );
                  }),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileSecondAiAssistant());
                },
                child: Container(
                  height: 52.h,
                  margin: EdgeInsets.only(top: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF05A1B), Color(0xFFF7C64A)],
                    ),
                  ),
                  child: Center(
                    child: Text('Next', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp)),
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