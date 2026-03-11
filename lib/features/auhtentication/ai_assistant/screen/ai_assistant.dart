import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/controller/ai_assistant_controller.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/first_ai_assistant.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AiAssistant extends StatelessWidget {
  const AiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure single controller instance for whole flow
  
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image(
                image: AssetImage(ImagePath.aiassistant),
                height: 220.r,
                width: 220.r,
                fit: BoxFit.contain,
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
                  "Create Your Custom AI Assistant",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                "Personalize your experience, choose how your AI guide speaks, sounds, and helps you explore.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff878787),
                  height: 1.6,
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Get.put(AiAssistantController()); // Register the controller here
                Get.to(() => FirstAiAssistant());
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
                    "Start Customize AI",
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
            SizedBox(height: 30.h,)
          ],
        ),
      ),
    );
  }
} 