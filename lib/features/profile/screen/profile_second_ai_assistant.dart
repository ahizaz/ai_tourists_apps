
// import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/widget/options_tile.dart';
// import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
// import 'package:ai_powered_tourists_app/features/profile/screen/profile_third_ai_assistant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfileSecondAiAssistant extends StatelessWidget {
//   const ProfileSecondAiAssistant({super.key});

//   Widget _topProgress(int step) {
//     return Row(
//       children: List.generate(3, (index) {
//         final active = (index + 1) == step;

//         return Expanded(
//           child: Container(
//             height: 4.h,
//             margin: EdgeInsets.symmetric(horizontal: 6.w),
//             decoration: BoxDecoration(
//               color: active ? const Color(0xFF9ED12E) : const Color(0xFFE6E6E6),
//               borderRadius: BorderRadius.circular(4.r),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProfileController controller = Get.find<ProfileController>();

//     // Internal values.
//     // These values are used by the controller/API.
//     // Visible labels are translated below.
//     final voices = <Map<String, String>>[
//       {'value': 'cool', 'translation': 'cool'},
//       {'value': 'serious', 'translation': 'serious'},
//       {'value': 'friendly', 'translation': 'friendly'},
//       {'value': 'professional', 'translation': 'professional'},
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 18.h),
//           child: Column(
//             children: [
//               // --------------------------------------------------
//               // Progress
//               // --------------------------------------------------
//               _topProgress(2),

//               SizedBox(height: 18.h),

//               // --------------------------------------------------
//               // Title
//               // --------------------------------------------------
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'ai_preferences_voice'.tr,
//                       style: GoogleFonts.inter(
//                         fontSize: 18.sp,
//                         color: const Color(0xFF6B6B6B),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // --------------------------------------------------
//               // Step Counter
//               // --------------------------------------------------
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   '2/3',
//                   style: TextStyle(
//                     color: const Color(0xFF9B9B9B),
//                     fontSize: 12.sp,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 18.h),

//               // --------------------------------------------------
//               // Section Title
//               // --------------------------------------------------
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'ai_voice'.tr,
//                   style: GoogleFonts.inter(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 12.h),

//               // --------------------------------------------------
//               // Voice Options
//               // --------------------------------------------------
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Obx(() {
//                     return Column(
//                       children: voices.map((voice) {
//                         final String value = voice['value']!;

//                         final String translationKey = voice['translation']!;

//                         return OptionTile(
//                           label: translationKey.tr,
//                           selected:
//                               controller.voice.value?.toLowerCase() ==
//                               value.toLowerCase(),
//                           isCheckbox: false,
//                           onTap: () {
//                             controller.selectVoice(value);
//                           },
//                         );
//                       }).toList(),
//                     );
//                   }),
//                 ),
//               ),

//               // --------------------------------------------------
//               // Next Button
//               // --------------------------------------------------
//               GestureDetector(
//                 onTap: () {
//                   final selectedVoice = controller.voice.value;

//                   if (selectedVoice == null || selectedVoice.isEmpty) {
//                     EasyLoading.showError('select_ai_speech_type'.tr);
//                     return;
//                   }

//                   Get.to(() => const ProfileThirdAiAssistant());
//                 },
//                 child: Container(
//                   height: 52.h,
//                   margin: EdgeInsets.only(top: 8.h),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12.r),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFF05A1B), Color(0xFFF7C64A)],
//                     ),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     'next_btn'.tr,
//                     style: GoogleFonts.inter(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/widget/options_tile.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_third_ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSecondAiAssistant extends StatelessWidget {
  const ProfileSecondAiAssistant({super.key});

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

    // Internal values.
    // These values are used by the controller/API.
    // Visible labels are translated below.
    final voices = <Map<String, String>>[
      {'value': 'cool', 'translation': 'cool'},
      {'value': 'serious', 'translation': 'serious'},
      {'value': 'friendly', 'translation': 'friendly'},
      {'value': 'professional', 'translation': 'professional'},
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // --------------------------------------------------
              // Progress
              // --------------------------------------------------
              _topProgress(2),

              SizedBox(height: 18.h),

              // --------------------------------------------------
              // Title
              // --------------------------------------------------
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

              // --------------------------------------------------
              // Step Counter
              // --------------------------------------------------
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '2/3',
                  style: TextStyle(
                    color: const Color(0xFF9B9B9B),
                    fontSize: 12.sp,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              // --------------------------------------------------
              // Section Title
              // --------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ai_voice'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // --------------------------------------------------
              // Voice Options
              // --------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: voices.map((voice) {
                        final String value = voice['value']!;
                        final String translationKey =
                            voice['translation']!;

                        return OptionTile(
                          label: translationKey.tr,
                          selected:
                              controller.voice.value?.toLowerCase() ==
                                  value.toLowerCase(),
                          isCheckbox: false,
                          onTap: () {
                            controller.selectVoice(value);
                          },
                        );
                      }).toList(),
                    );
                  }),
                ),
              ),

              // --------------------------------------------------
              // Next Button
              // --------------------------------------------------
              GestureDetector(
                onTap: () {
                  final selectedVoice = controller.voice.value;

                  if (selectedVoice == null || selectedVoice.isEmpty) {
                    EasyLoading.showError(
                      'select_ai_speech_type'.tr,
                    );
                    return;
                  }

                  Get.to(() => const ProfileThirdAiAssistant());
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
                    'next_btn'.tr,
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