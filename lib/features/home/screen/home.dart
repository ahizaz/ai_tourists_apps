import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/features/home/widget/current_location_card.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 20.h,),
              Row(
                children: [
               Obx(()=>Text("Hello,${controller.userName.value}",style: GoogleFonts.dmSerifDisplay( 
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff252525)
               ),)),
                 const Spacer(),
                  Image(image: AssetImage(IconPath.notificationicon,),width: 44.w,height: 44.h,fit: BoxFit.cover,)
                ],              
              ),
              SizedBox(height: 22.h,),
              const CurrentLocationCard(),         

              ],
            ),
          ),
        ),
      ),
    );
  }
}