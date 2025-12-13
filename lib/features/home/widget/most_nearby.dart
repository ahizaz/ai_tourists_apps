import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'place_card.dart';

class MostNearbySection extends StatelessWidget {
  const MostNearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        Row(
          children: [
            Text(
              'most_nearby'.tr,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // places list from API
        Obx(() {
          // Show loading indicator while fetching nearby places
          if (controller.isLoadingNearbyPlaces.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffBDE446)),
                ),
              ),
            );
          }

          // Show nearby places from API if available
          if (controller.nearbyPlaces.isNotEmpty) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.nearbyPlaces.length,
              itemBuilder: (context, index) {
                final nearbyPlace = controller.nearbyPlaces[index];
                // Convert NearbyPlace to Place for PlaceCard widget
                final place = nearbyPlace.toPlace();

                return PlaceCard(place: place, onTap: () {}, onBookmark: () {});
              },
            );
          }

          // If no nearby places from API, show message
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.location_off, size: 48.w, color: Colors.grey[400]),
                  SizedBox(height: 12.h),
                  Text(
                    'No nearby places found',
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Pull down to refresh location',
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
