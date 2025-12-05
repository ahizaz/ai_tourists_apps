import 'package:ai_powered_tourists_app/core/common/widgets/custom_password_field.dart';
import 'package:ai_powered_tourists_app/core/common/widgets/custom_textField.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/forget_password/screen/forget_password.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_in/controller/sign_in_controller.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_up/screen/sign_up.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/screen/bottom_navbar.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
    final SignInController controller = Get.put(SignInController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 105.h),
                Center(
                  child: Text(
                    'sign_in_account'.tr,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                CustomTextField(
                  controller: controller.emailOrPhoneController,
                  hintText: 'phone_or_email'.tr,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: 16.h),
                PasswordTextField(
                  controller: controller.passwordController,
                  isPasswordHidden: controller.isPasswordHidden,
                  onToggle: controller.togglePasswordVisibility,
                  prefixIcon: Icons.lock_outline,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: controller.toggleRememberMe,
                          ),
                        ),
                        Text(
                          'remember_me'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff878787),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => ForgetPassword());
                      },
                      child: Text(
                        'forget_password'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff252525),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                InkWell(
                  onTap: controller.signIn,
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
                        'sign_in'.tr,
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
                SizedBox(height: 24.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have_account'.tr,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      InkWell(
                        onTap: () {
                          Get.to(() => SignUp());
                        },
                        child: Text(
                          'sign_up'.tr,
                          style: GoogleFonts.inter(
                            color: AppColors.orangeEnd,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.orangeEnd,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
