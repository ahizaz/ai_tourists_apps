
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileLastAiAssistant extends StatelessWidget {
  const ProfileLastAiAssistant({super.key});

  void _finishCustomization(ProfileController controller) {
    controller.persistAiAssistantPreferences();

    final storage = Get.find<StorageService>();

    debugPrint('✅ Final gender: ${storage.getAiGender()}');
    debugPrint('✅ Final voice: ${storage.getAiVoice()}');
    debugPrint(
      '✅ Final voice types: '
      '${storage.getAiVoiceTypes()}',
    );

    Get.close(5);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90.h),

              Center(
                child: Image(
                  image: const AssetImage(ImagePath.dalilPic),
                  width: 200.w,
                  height: 224.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                'discover_next_adventure'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.sp,
                  color: const Color(0xFF252525),
                ),
              ),

              SizedBox(height: 65.h),

              Text(
                'your_intelligent_companion'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: const Color(0xFF505050),
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'explore_manage_points'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: const Color(0xFF505050),
                ),
              ),

              SizedBox(height: 20.h),

              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  _finishCustomization(controller);
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: const DecorationImage(
                      image: AssetImage(ImagePath.button),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'next'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
