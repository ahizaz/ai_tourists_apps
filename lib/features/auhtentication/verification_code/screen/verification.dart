import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/ai_assistant.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/verification_code/controller/verification_controller.dart';

import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

  @override
  Widget build(BuildContext context) {
  
    final VerificationController controller = Get.put(VerificationController());

    final defaultPinTheme = PinTheme(
      width: 54.w,
      height: 60.h,
      textStyle: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    // focused theme (slightly bolder border)
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xff505050) , width: 1.w),
      ),
    );

    // green theme used when all boxes are filled (matches the provided image style)
    final filledPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFBEE84F), // change this hex to match the exact shade you want
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: Colors.white, // white text on green background (like the image)
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 105.h),
              Center(
                child: Text(
                  "Verify Your E-mail",
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Text(
                  "We have sent the OTP code to example@gmail.com",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff505050),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Center(
                child: Text(
                  "the process",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff505050),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
        
              // Pinput (centered) - rebuild when controller.pin changes so we can switch theme when filled
              Center(
                child: Obx(
                  () => Pinput(
                    length: 6,
                    controller: controller.pinputController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    // Use filledPinTheme when all digits are entered, otherwise use defaultPinTheme
                    submittedPinTheme: controller.pin.value.trim().length == 6
                        ? filledPinTheme
                        : defaultPinTheme,
                    showCursor: true,
                    onChanged: controller.onChanged,
                    onCompleted: controller.onCompleted,
                    preFilledWidget: Center(
                      child: Text(
                        '_',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          color: const Color(0xff252525),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 20.h),
        
              // resend / timer row
              Center(
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.secondsRemaining.value > 0
                            ? 'Resend code in ${controller.secondsRemaining.value}s'
                            : 'Didn\'t receive the code?',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xff505050),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      controller.secondsRemaining.value == 0
                          ? GestureDetector(
                              onTap: controller.resendCode,
                              child: Text(
                                'Resend',
                                style: GoogleFonts.inter(
                                  decoration: TextDecoration.underline,
                                     decorationColor: AppColors.orangeEnd, 
                                      decorationThickness: 1.5, 
                                  
                                  fontSize: 12.sp,
                                  color: const Color(0xffF5461B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ), 
         
              Spacer(),
              Obx(
                () => controller.pin.value.trim().length == 6
                    ? InkWell(
                        onTap: () {
                         controller.verifyOtp();
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
                      )
                    : Container(
                        width: double.infinity,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Color(0xffE1E1E1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text("Next",style: GoogleFonts.inter( 
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff878787)
                          ),),
                        ),
                      ),
              ),
              SizedBox(height: 20.h,)
        
            ],
          ),
        ),
      ),
    );
  }
}