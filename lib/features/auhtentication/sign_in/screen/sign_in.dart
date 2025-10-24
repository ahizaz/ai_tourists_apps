import 'package:ai_powered_tourists_app/features/auhtentication/sign_in/controller/sign_in_controller.dart';
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
    // register the controller (will be disposed automatically by GetX when removed)
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
                    "Sign In Your Account",
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Email / Phone field implemented using Container + inner TextField (borderless)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    // border color and width set here
                    border: Border.all(color: AppColors.border, width: 1.5.w),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.black54),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: controller.emailOrPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                            hintText: "Phone number or email",
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Password field implemented with Container + inner TextField and a right-side toggle icon
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      // border color and width set here
                      border: Border.all(color: AppColors.border, width: 1.5.w),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.black54),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                              hintText: "Password",
                              hintStyle: TextStyle(color: AppColors.textSecondary),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Remember me & Forgot password
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
                          "Remember me",
                          style:GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff878787)

                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                     
                      },
                      child: Text(
                        "Forget password?",
                        style: GoogleFonts.inter( 
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff252525)
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Sign Up link
                 InkWell(
                onTap: () {
              
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
                      "Sign In",
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
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}