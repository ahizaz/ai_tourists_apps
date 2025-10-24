import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen_third.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class SplashScreenSecond extends StatelessWidget {
  const SplashScreenSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImagePath.splashsecond,),fit: BoxFit.cover,)
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          
            children: [
              SizedBox(height: 130.h,),
             Center(
                 child: Text("Explore Without Limits",style: GoogleFonts.inter( 
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffFFFFFF)
                 ),),
             ),
             SizedBox(height: 6.h,),
             Center(
              child: Text("Enjoy offline access and smart recommendations,",style: GoogleFonts.inter( 
                fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)
              ),),
             ),
             SizedBox(height: 4.h,),
        
                    Center(
              child: Text("anytime, anywhere",style: GoogleFonts.inter( 
                fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)
              ),),
             ),
             Spacer(),
                InkWell(
                onTap: () {
              Get.to(()=>SplashScreenThird());
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: const DecorationImage(
                      image: AssetImage(ImagePath.button), // তোমার ইমেজ path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Get Start",
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
                            SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}