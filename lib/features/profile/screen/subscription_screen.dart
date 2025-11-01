import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
       appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Subscription',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h,),
            Text(
              "Choose the plan that's right for you",
              style: GoogleFonts.inter( 
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff252525)
              ),
            ),
            SizedBox(height: 32.h,),
            // Monthly Plan
            Obx(() => GestureDetector(
              onTap: () {
                controller.selectSubscriptionPlan("Monthly");
              },
              child: _buildSubscriptionCard(
                title: "Monthly",
                price: "\$99",
                billingPeriod: "/ Billing monthly",
                isSelected: controller.selectedPlan.value == "Monthly",
              ),
            )),
            SizedBox(height: 20.h,),
            // Yearly Plan
            Obx(() => GestureDetector(
              onTap: () {
                controller.selectSubscriptionPlan("Yearly");
              },
              child: _buildSubscriptionCard(
                title: "Yearly",
                price: "\$99",
                billingPeriod: "/ Billing monthly",
                isSelected: controller.selectedPlan.value == "Yearly",
              ),
            )),
            Spacer(),
            // Subscribe Now Button
            Obx(() => Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: controller.selectedPlan.value != null
                    ? LinearGradient(
                        colors: [Color(0xffFF8C42), Color(0xffFF6B35)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: controller.selectedPlan.value == null ? Color(0xffE1E1E1) : null,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.selectedPlan.value != null
                      ? () {
                          controller.subscribeNow();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Center(
                    child: Text(
                      "Subscribe Now",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: controller.selectedPlan.value != null ? Colors.white : Color(0xff999999),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(height: 16.h,)
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required String billingPeriod,
    required bool isSelected,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isSelected
            ? Border.all(color: Color(0xffFF6B35), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff252525),
            ),
          ),
          SizedBox(height: 16.h,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFF4444),
                ),
              ),
              SizedBox(width: 4.w,),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  billingPeriod,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h,),
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: Colors.black,
                size: 20.sp,
              ),
              SizedBox(width: 8.w,),
              Text(
                "All Advanced Features Included",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff252525),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}