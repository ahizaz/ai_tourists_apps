import 'package:ai_powered_tourists_app/features/profile/screen/quize_options.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayAiQuize extends StatelessWidget {
  const PlayAiQuize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: AssetImage(ImagePath.aiball),
                width: 180.w,
                height: 180.h,
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Text(
                'test_travel_knowledge'.tr,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff252525),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            Center(
              child: Text(
                '${'fun_quizzes_ai'.tr} ${'places_you_explore'.tr}',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff878787),
                ),
              ),
            ),

            SizedBox(height: 29.h),

            InkWell(
              onTap: () {
                Get.to(() => QuizeOptions());
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
                child: Center(
                  child:Text(
      'start_ai_quize'.tr,
  style: GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}