import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ProfileLastAiAssistant extends StatelessWidget {
  const ProfileLastAiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                 SizedBox(height: 135.h),
                 Center(
                  child: Image(
                    image: AssetImage(ImagePath.dalilPic),
                    width: 200.w,
                    height: 224.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h,),
                 Center(
                  child: Text(
                    "Discover your next adventure with ",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.sp,
                      color: const Color(0xff252525),
                    ),
                  ),
                ),
                    Center(
                  child: Text(
                    "our AI-powered travel guide app!",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 20.sp,
                      color: const Color(0xff252525),
                    ),
                  ),
                ),
                SizedBox(height: 65.h,),
                Center(child: Text("Your intelligent companion for exploring and",   style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: const Color(0xff505050),
                    ),),),
                    SizedBox(height: 5.h,),
                     Center(child: Text("managing travel experiences.",   style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: const Color(0xff505050),
                    ),),),
                    SizedBox(height: 8.h,),
              Center(child: Text("Effortlessly explore and manage points of ",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                      SizedBox(height: 4.h,),
              Center(child: Text("interest for your travels, including",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                         SizedBox(height: 4.h,),
              Center(child: Text("iattractions, restaurants, and activities.",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                               SizedBox(height: 4.h,),
              Center(child: Text("Contribute unique insights and experiences ",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                                  SizedBox(height: 4.h,),
              Center(child: Text("to enhance our travel database and earn  ",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                                   SizedBox(height: 4.h,),
              Center(child: Text("rewards  ",style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xff505050),
                    ),),),
                    Spacer(),
                     InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
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
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h,),

             
          ],
        ),
      ),
    );
  }
}