import 'package:ai_powered_tourists_app/features/home/screen/home_select_place_map.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlaceDetails extends StatelessWidget {
  final Place place;

  const PlaceDetails({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            // Image
            Hero(
              tag: 'place-${place.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl,
                  height: 220.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  maxHeightDiskCache: 500,
                  maxWidthDiskCache: 800,
                  memCacheHeight: 500,
                  memCacheWidth: 800,
                  placeholder: (context, url) => Container(
                    height: 220.h,
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 220.h,
                    color: Colors.grey[200],
                    child: Icon(Icons.photo, size: 40.w, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.title,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18.w),
                            SizedBox(width: 4.w),
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Description
                    Text(
                      place.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 80.h), // spacing for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                Icon(
                  Icons.location_on_outlined,
                  size: 16.w,
                  color: Colors.grey,
                ),
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

            // Start de Visit button
            GestureDetector(
              onTap: () {
                // Navigate to the map screen with the place data
                Get.to(() => const HomeSelectPlaceMap(), arguments: place);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF9ED12E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Start de Visit',
                  style: GoogleFonts.dmSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
