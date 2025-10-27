import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen_second.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: SingleChildScrollView( // ✅ শুধু এটুকু যোগ করা হলো
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35.h),
                    Center(
                      child: Image(
                        image: AssetImage(IconPath.firstdotsplash),
                        height: 4.h,
                        width: 72.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 110.h),
                    Center(
                      child: Image(
                        image: AssetImage(ImagePath.dalilPic),
                        width: 200.w,
                        height: 224.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Center(
                      child: Text(
                        "Discover the",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: const Color(0xff252525),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "AI Travel Assist App",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: const Color(0xff252525),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        "Smart recommendations and real-time",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff878787),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "guidance at your fingertips",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff878787),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SplashScreenSecond());
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
                          child: Text(
                            "Next",
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 4,
                                  color: Colors.black.withValues(alpha: .4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
