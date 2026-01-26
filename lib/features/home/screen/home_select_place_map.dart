import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

    // If a place was passed, request the controller to geocode and show it.
    if (place != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.lastShownPlaceName.value != place.title) {
          controller.showPlaceByName(place.title);
        }
      });
    }

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
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: controller.mapMarkers.toSet(),
                );
              }),
            ),

            // Image overlay when AI guide is started
            Obx(() {
              if (controller.isAIGuideStarted.value && place != null) {
                return Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: place.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 80.w,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),

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
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
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

                  // map button
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Image.asset(
                        IconPath.mapactive,
                        height: 22.h,
                        width: 22.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // AI button
                  InkWell(
                    onTap: () {
                      controller.openAIGuideSheet();
                      _showAIGuideBottomSheet(context, place, controller);
                    },
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Image.asset(
                          IconPath.aiactive,
                          height: 22.h,
                          width: 22.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _showAIGuideBottomSheet(
    BuildContext context,
    Place place,
    HomeController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(() {
        return Container(
          height: controller.isAIGuideStarted.value ? 290.h : 480.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: controller.isAIGuideStarted.value
              ? _buildAudioPlayerView(controller, place)
              : _buildInitialGuideView(context, place, controller),
        );
      }),
    ).whenComplete(() {
      controller.closeAIGuideSheet();
    });
  }

  Widget _buildInitialGuideView(
    BuildContext context,
    Place place,
    HomeController controller,
  ) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        // Handle bar
        Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(height: 12.h),

        // Map preview with marker
        Center(
          child: Image(
            image: AssetImage(ImagePath.aiassistant),
            height: 200.h,
            width: 160.w,
            fit: BoxFit.cover,
          ),
        ),

        SizedBox(height: 8.h),

        // Place title and description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  place.title,
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff252525),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'AI is ready to guide you with history, culture',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Color(0xff878787),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Center(
                child: Text(
                  'and secrets of this landmark.',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Color(0xff878787),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),

        Spacer(),

        // Start AI Tourist Guide Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: InkWell(
            onTap: () {
              controller.startAITouristGuide(place: place);
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'Start AI Tourist Guide',
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioPlayerView(HomeController controller, Place place) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            child: CachedNetworkImage(
              imageUrl: place.imageUrl,
              fit: BoxFit.cover,
              maxHeightDiskCache: 600,
              maxWidthDiskCache: 800,
              memCacheHeight: 600,
              memCacheWidth: 800,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 50.w, color: Colors.grey),
              ),
            ),
          ),
        ),
        // Dark overlay for better text visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
          ),
        ),
        // Content on top
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 4.h),
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),

              // Audio waveform visualization
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.graphic_eq, size: 24.w, color: Colors.white),
                  SizedBox(width: 12.w),
                  Text(
                    'AI Tourist Guide Playing...',
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              SizedBox(
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(25, (index) {
                    return Obx(() {
                      // Animate bars when playing
                      final isPlaying = controller.isAudioPlaying.value;
                      final baseHeight = 8.h;
                      final maxHeight = 40.h;

                      // Create wave effect
                      final animatedHeight = isPlaying
                          ? baseHeight +
                                (maxHeight - baseHeight) *
                                    ((index % 3 == 0
                                        ? 0.7
                                        : index % 3 == 1
                                        ? 0.9
                                        : 0.5))
                          : baseHeight;

                      return Container(
                        width: 3.w,
                        height: animatedHeight,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? (index % 2 == 0
                                    ? Colors.orange
                                    : Colors.deepOrange)
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      );
                    });
                  }),
                ),
              ),

              SizedBox(height: 16.h),

              // Elapsed time display (no total duration)
              Obx(() {
                return Text(
                  controller.formatDuration(controller.audioPosition.value),
                  style: GoogleFonts.dmSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                );
              }),

              SizedBox(height: 20.h),

              // Play/Pause button
              Obx(() {
                return InkWell(
                  onTap: () {
                    controller.toggleAudioPlayback();
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isAudioPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 32.w,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
