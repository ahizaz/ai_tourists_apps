import 'package:ai_powered_tourists_app/core/common/widgets/custom_password_field.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/reset_password/controller/reset_password_controller.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_in/screen/sign_in.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150.h),
              Center(
                child: Text(
                  "Reset Password",
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
                    color: const Color(0xff878787),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "your personal acccount again",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff878787),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              PasswordTextField(
                controller: controller.newPassword,
                isPasswordHidden: controller.isNewPasswordHidden,
                onToggle: controller.togglePasswordVisibility,
                prefixIcon: Icons.lock_outline,
                hintText: "New Password",
              ),
              SizedBox(height: 16.h),
              PasswordTextField(
                controller: controller.confirmPassword,
                isPasswordHidden: controller.isConfirmPasswordHidden,
                onToggle: controller.toggleConfirmPasswordVisibility,
                prefixIcon: Icons.lock_outline,
                hintText: "Confirm Password",
              ),
              const Spacer(),

              ///  Dynamic button (active/inactive)
              Obx(() {
                return InkWell(
                  onTap: controller.isButtonEnabled.value
                      ? () {
                       
                          controller.newPassword.clear();
                          controller.confirmPassword.clear();
                          controller.isButtonEnabled.value = false;

                         Get.to(()=>SignIn());
                       
                        }
                      : null,
                  child: controller.isButtonEnabled.value
                      ? Container(
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
                        ),
                );
              }),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
