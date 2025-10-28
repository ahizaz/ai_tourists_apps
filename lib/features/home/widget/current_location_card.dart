import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentLocationCard extends StatelessWidget {
  const CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8FBFF),
            Color(0xFFEAF4FF),
            Color(0xFFDDE8FF),
            Color(0xFFCCDFFF),
            Color(0xFFB8D9FF),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF45C5FF).withOpacity(0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.r),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.r),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current location", style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff252525),
            )),
            SizedBox(height: 12.h),

            /// Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(IconPath.location, width: 24.w, height: 24.h),
                SizedBox(width: 3.w),
                Obx(() => Text(
                      controller.currentAddress.value,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff505050),
                      ),
                    )),
              ],
            ),   /// Weather & Map Button
            Row(
              children: [
                Image.asset(IconPath.sun, width: 24.w, height: 24.h),
                SizedBox(width: 3.w),
                Obx(() => Text(
                      "Weather: ${controller.currentWeather.value}",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff505050),
                      ),
                    )),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See Map',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF45C5FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
