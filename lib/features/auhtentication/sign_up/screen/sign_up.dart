import 'package:ai_powered_tourists_app/core/common/widgets/custom_password_field.dart';
import 'package:ai_powered_tourists_app/core/common/widgets/custom_textField.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_in/screen/sign_in.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/sign_up/controller/sign_up_controller.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/verification_code/screen/verification.dart';

import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
       final SignUpController controller = Get.put(SignUpController());
    return Scaffold(
       backgroundColor: AppColors.backgroundColor,
       body: SafeArea(child: Padding(padding:EdgeInsets.symmetric(horizontal: 12.w),
       child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 105.h),
                Center(
                  child: Text(
                    "create_an_account".tr,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                      SizedBox(height: 40.h),
                      CustomTextField(
                  controller: controller.nameController,
                  hintText: "name".tr,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.person,
                ),
                 SizedBox(height: 16.h),
                            CustomTextField(
                  controller: controller.emailOrPhoneController,
                  hintText: "email_or_phone".tr,
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
                          "i_agree_to".tr,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff878787),
                          ),
                        ),
                        SizedBox(width: 6.w,),
                        Text("terms_and_condition".tr,style: GoogleFonts.inter( 
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff505050),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xff878787)
                        ),
                        ),
                   
                     
                      ],
                    ),
                   
                  ],
                ),
                SizedBox(height: 30.h,),
                
                       InkWell(
                  onTap: () {
               controller.signUp(); 
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
                        "next_btn".tr,
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
                        Text("already_have_account".tr,style: GoogleFonts.inter( 
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400
                        ),),
                        SizedBox(width: 5.w,),
                     InkWell(
               onTap: () {
                Get.to(()=>SignIn());
               },
                 child: Text(
                  "sign_in".tr,
              style: GoogleFonts.inter(
             color: AppColors.orangeEnd,
              fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                 decoration: TextDecoration.underline, 
                    decorationColor: AppColors.orangeEnd, 
                   decorationThickness: 1.5, 
    ),
  ),
)

                      ],
                  ),
                )
           

        ],

        ),
       ),
       
       
       )),

    );
  }
}