import 'package:ai_powered_tourists_app/features/home/screen/place_details.dart';
import 'package:ai_powered_tourists_app/features/home/screen/home_select_place_map.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onBookmark;
  final RxBool isBookmarked = false.obs;
  final Map<String, dynamic>? rawData;

  PlaceCard({
    super.key,
    required this.place,
    this.onBookmark,
    this.rawData,
    required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to details page with Hero animation
        Get.to(() => PlaceDetails(place: place));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image with Hero
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: SizedBox(
                height: 140.h,
                width: double.infinity,
                child: Hero(
                  tag: 'place-${place.id}',
                  child: Image.network(
                    place.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.photo, size: 40.w, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title + bookmark icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.title,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () async {
                          isBookmarked.value = !isBookmarked.value;
                          if (onBookmark != null) onBookmark!();

                          // Build payload for API. Prefer rawData (NearbyPlace json) if available.
                          final payload = rawData ?? {
                            'place_id': place.id,
                            'place_name': place.title,
                            'place_image': place.imageUrl,
                            'place_description': place.description,
                            'place_rating': place.rating.toStringAsFixed(2),
                            'latitude': 0.0,
                            'longitude': 0.0,
                          };

                          try {
                            MapController mapController;
                            if (Get.isRegistered<MapController>()) {
                              mapController = Get.find<MapController>();
                            } else {
                              mapController = Get.put(MapController());
                            }

                            await mapController.savePlace(payload);
                          } catch (e) {
                            debugPrint('Failed to save place: $e');
                          }
                        },
                        child: Obx(
                          () => Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Icon(
                              isBookmarked.value
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 20.w,
                              color: isBookmarked.value
                                  ? Colors.red
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // description
                  Text(
                    place.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // footer row: rating, distance, actions
                  Row(
                    children: [
                      // rating
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14.w),
                            SizedBox(width: 6.w),
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: GoogleFonts.dmSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
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
                              size: 16.w, color: Colors.grey[600]),
                          SizedBox(width: 6.w),
                          Text(
                            '${place.distanceKm}km',
                            style: GoogleFonts.dmSans(
                              fontSize: 12.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      // action icons (map / details)////map ar
                      GestureDetector(
                        onTap: () {
                          // Navigate to HomeSelectPlaceMap
                          Get.to(() => const HomeSelectPlaceMap(), arguments: place);
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Image.asset(IconPath.mapinactive,width: 30.w,height: 30.w,fit: BoxFit.cover,),
                        ),
                      ),
                      SizedBox(width: 8.w),
                       Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child:Image.asset(IconPath.aiactive)
            ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}