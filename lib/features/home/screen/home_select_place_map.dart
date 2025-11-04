import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSelectPlaceMap extends StatelessWidget {
  const HomeSelectPlaceMap({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the place data from arguments
    final Place? place = Get.arguments as Place?;
    
    // Get HomeController
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Map area
            Positioned.fill(
              child: Obx(() {
                return GoogleMap(
                  initialCameraPosition: controller.mapCameraPosition.value,
                  onMapCreated: controller.onMapCreated,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: controller.mapMarkers.toSet(),
                );
              }),
            ),

            // Back button
            Positioned(
              left: 16.w,
              top: 16.h,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.black87),
                ),
              ),
            ),

            // Location display box
            Positioned(
              left: 16.w,
              right: 16.w,
              top: 70.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red[400], size: 20.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        place?.title ?? 'Select a location',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center marker indicator (red dot)
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: .9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),

            // Bottom floating action button - My Location
            Positioned(
              right: 16.w,
              bottom: 100.h,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  controller.moveToCurrentLocation();
                },
                child: Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: place != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 10.r,
                    offset: Offset(0, -4.r),
                  ),
                ],
              ),
              height: 74.h,
              child: Row(
                children: [
                  // rating
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16.w),
                        SizedBox(width: 8.w),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // distance
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16.w, color: Colors.grey),
                      SizedBox(width: 6.w),
                      Text(
                        '${place.distanceKm}km',
                        style: GoogleFonts.dmSans(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // map button
                  Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Image.asset(IconPath.mapactive,
                          height: 30.h, width: 30.w, fit: BoxFit.cover)),
                  SizedBox(width: 8.w),

                  // more / directions
                  InkWell(
                    onTap: (){
                      
                    },
                    child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Image.asset(IconPath.aiactive)),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}