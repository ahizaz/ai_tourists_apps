import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              // bookmark action
            },
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            // Image
            Hero(
              tag: 'place-${place.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  place.imageUrl,
                  height: 220.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
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
                    Text(
                      place.title,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Short summary or subtitle can go here',
                      style: GoogleFonts.dmSans(
                          fontSize: 13.sp, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      place.description,
                      style: GoogleFonts.dmSans(
                          fontSize: 14.sp, height: 1.6, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 12.h),
        
                    // (Optional) more detailed text to emulate long details - you can replace with real content
                    Text(
                      '\nMore details\n\n' +
                          ('${place.description} ' * 3),
                      style: GoogleFonts.dmSans(
                          fontSize: 14.sp, height: 1.6, color: Colors.grey[800]),
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
              color: Colors.black.withOpacity(0.06),
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
                Icon(Icons.location_on_outlined, size: 16.w, color: Colors.grey),
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
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: Icon(Icons.map_outlined, color: Colors.grey[800]),
                onPressed: () {
                  // map action
                },
              ),
            ),
            SizedBox(width: 8.w),

            // more / directions
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.grey[800]),
                onPressed: () {
                  // more action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}