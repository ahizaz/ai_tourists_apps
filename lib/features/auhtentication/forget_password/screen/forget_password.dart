
import 'package:ai_powered_tourists_app/core/common/widgets/custom_textField.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/forget_password/controller/forget_password_controller.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController controller = Get.put(
      ForgetPasswordController(),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              // Back button
              Positioned(
                top: 16.h,
                left: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: Get.back,
                    borderRadius: BorderRadius.circular(50.r),
                    child: Container(
                      width: 42.w,
                      height: 42.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE6E6E6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150.h),

                  Center(
                    child: Text(
                      "Forget Password",
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
                      "Reset your account password and access",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffA1A1A1),
                      ),
                    ),
                  ),

                  Center(
                    child: Text(
                      "your personal account again",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffA1A1A1),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  CustomTextField(
                    controller: controller.forgetpassword,
                    hintText: "Phone number or email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),

                  const Spacer(),

                  Obx(() {
                    return controller.isEmailValid.value
                        ? InkWell(
                            onTap: controller.onNextPressed,
                            borderRadius: BorderRadius.circular(12.r),
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
                                        color: Colors.black.withValues(
                                          alpha: .4,
                                        ),
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
                              color: const Color(0xffE1E1E1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff878787),
                                ),
                              ),
                            ),
                          );
                  }),

                  SizedBox(height: 20.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
