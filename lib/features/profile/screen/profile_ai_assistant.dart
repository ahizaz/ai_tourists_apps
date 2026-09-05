// import 'package:ai_powered_tourists_app/features/profile/screen/profile_first_ai_assistant.dart';
// import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfileAiAssistant extends StatelessWidget {
//   const ProfileAiAssistant({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ensure single controller instance for whole flow

//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 150.h),
//             Center(
//               child: Image(
//                 image: AssetImage(ImagePath.aiassistant),
//                 height: 220.h,
//                 width: 170.w,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(height: 20.h),
//             Center(
//               child: ShaderMask(
//                 shaderCallback: (bounds) => const LinearGradient(
//                   colors: [
//                     Color(0xFFCDCDCD),
//                     Color(0xFF313131),
//                     Color(0xFFE3E3E3),
//                     Color(0xFF404040),
//                     Color(0xFFCFCFCF),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ).createShader(bounds),
//                 child: Text(
//                   "Create Your Custom AI Assistant",
//                   style: GoogleFonts.inter(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20.sp,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 5.h),
//             Center(
//               child: Text(
//                 "Personalize your experience choose how your AI ",
//                 style: GoogleFonts.inter(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xff878787),
//                 ),
//               ),
//             ),
//             SizedBox(height: 6.h),
//             Center(
//               child: Text(
//                 "guide speaks, sounds, and helps you explore. ",
//                 style: GoogleFonts.inter(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xff878787),
//                 ),
//               ),
//             ),
//             SizedBox(height: 50.h),
//             InkWell(
//               onTap: () {
//                 Get.to(() => ProfileFirstAiAssistant());
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 48.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                   image: const DecorationImage(
//                     image: AssetImage(ImagePath.button),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Start Customize AI",
//                     style: GoogleFonts.inter(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           offset: const Offset(0, 1),
//                           blurRadius: 4,
//                           color: Colors.black.withAlpha(100),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:ai_powered_tourists_app/features/profile/screen/profile_first_ai_assistant.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAiAssistant extends StatelessWidget {
  const ProfileAiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure single controller instance for whole flow

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150.h),

                Center(
                  child: Image(
                    image: AssetImage(ImagePath.aiassistant),
                    height: 220.h,
                    width: 170.w,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 20.h),

                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFCDCDCD),
                        Color(0xFF313131),
                        Color(0xFFE3E3E3),
                        Color(0xFF404040),
                        Color(0xFFCFCFCF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'create_custom_ai_assistant'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                Center(
                  child: Text(
                    'customize_ai_description'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff878787),
                    ),
                  ),
                ),

                SizedBox(height: 50.h),

                InkWell(
                  onTap: () {
                    Get.to(() => ProfileFirstAiAssistant());
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
                        'start_customize_ai'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black.withAlpha(100),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30.h,
            left: 12.w,
            child: GestureDetector(
              onTap: Get.back,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
