import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
            Center(
              child: Image(image: AssetImage(IconPath.firstdotsplash,),height: 4.h,width: 72.w,fit: BoxFit.cover,),
            ),
            SizedBox(height: 123.h,),
            Center(
              child: Image(image: AssetImage(ImagePath.dalilPic),width: 200.w,height: 224.h,fit: BoxFit.cover,),
            ),
            SizedBox(height: 32.h,),
            Center(child: Text("Discover the",style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
              color: Color(0xff252525)
            ),)),
          
             Center(child: Text("AI Travel Assist App",style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
              color: Color(0xff252525)
            ),)),
            SizedBox(height: 8.h,),
            Center(
              child: Text("Smart recommendations and real-time",style: GoogleFonts.inter( 
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff878787),
              ),),
            ),
              Center(
              child: Text("guidance at your fingertips",style: GoogleFonts.inter( 
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff878787),
              ),),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
               gradient:  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
             Color(0xffF5461B),
             Color(0xffBDE446)
                ],
              )
              ),
              child: Center(
                child: Text(""),
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