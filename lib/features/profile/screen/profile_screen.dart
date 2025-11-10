import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/account_screen.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_ai_assistant.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/select_map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/play_ai_quize.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/save_place.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/subscription_screen.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/terms_condition.dart';
import 'package:ai_powered_tourists_app/features/profile/widget/profile_option.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final imageFile = controller.profileImage.value;
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffFDDAD1),
                            width: 8.w,
                          ),
                          image: imageFile != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(imageFile),
                                )
                              : null,
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          color: Color(0xffFDDAD1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h,),
            Center(
              child: Obx(()=>Text(controller.userName.value,
              style: GoogleFonts.inter(fontSize: 20.sp,fontWeight: FontWeight.w600,
              color: Color(0xff2A222C)),
              )),
            ),
              SizedBox(height: 4.h,),
             Center(
  child: Obx(() => Text(
        controller.userEmail.value,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff878787),
        ),
      )),
),
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.account,
                title: "account".tr,
                onTap: () {
                    Get.to(()=>AccountScreen());
                },
              ),
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.subscription,
                title: "subscription".tr,
                onTap: () {
                 Get.to(()=>SubscriptionScreen());
                },
              ),
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.playquize,
                title: "play_quiz".tr,
                onTap: () {
                      Get.to(()=>PlayAiQuize());
                },
              ),
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.aisetup,
                title: "ai_setup".tr,
                onTap: () {
                   Get.to(()=>ProfileAiAssistant());
                },
              ),
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.saveplace,
                title: "save_place".tr,
                onTap: () {
                Get.to(()=>SavePlace());
                },
              ),
             
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.offilinemapdownload,
                title: "download_offline_map".tr,
                onTap: () {
                Get.to(()=>SelectMap());
                },
              ),
             
           
              SizedBox(height: 32.h,),
              ProfileOptionItem(
                iconPath: IconPath.termscondition,
                title: "Terms and Conditions".tr,
                onTap: () {
            Get.to(()=>TermsCondition());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}