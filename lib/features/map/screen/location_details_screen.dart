import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> locationData;

  const LocationDetailsScreen({
    super.key,
    required this.locationData,
  });

  @override
  Widget build(BuildContext context) {
    final MapController controller = Get.find<MapController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Images
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.black),
                    onPressed: () {
                      // Share functionality
                      Get.snackbar('Share', 'Share functionality coming soon');
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() {
                final photos = controller.selectedPlaceDetails['photos'] as List?;
                
                if (photos != null && photos.isNotEmpty) {
                  return PageView.builder(
                    itemCount: photos.length > 5 ? 5 : photos.length,
                    itemBuilder: (context, index) {
                      final photoReference = photos[index]['photo_reference'];
                      final photoUrl = controller.getPhotoUrl(photoReference);
                      
                      return Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return _buildDefaultImage();
                }
              }),
            ),
          ),

          // Place Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place Name
                  Text(
                    locationData['name'] ?? 'Unknown Location',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Rating and Type
                  Obx(() {
                    final rating = controller.selectedPlaceDetails['rating'];
                    final types = controller.selectedPlaceDetails['types'] as List?;
                    
                    return Row(
                      children: [
                        if (rating != null && rating != 'N/A') ...[
                          Icon(Icons.star, color: Colors.amber, size: 20.sp),
                          SizedBox(width: 4.w),
                          Text(
                            rating.toString(),
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 16.w),
                        ],
                        if (types != null && types.isNotEmpty)
                          Expanded(
                            child: Text(
                              _formatTypes(types),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 16.h),

                  // Address
                  _buildInfoRow(
                    Icons.location_on,
                    locationData['fullAddress'] ?? 'Address not available',
                  ),
                  SizedBox(height: 12.h),

                  // Phone
                  Obx(() {
                    final phone = controller.selectedPlaceDetails['phone'];
                    if (phone != null && phone != 'N/A') {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildInfoRow(Icons.phone, phone),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Opening Hours
                  Obx(() {
                    final isOpen = controller.selectedPlaceDetails['isOpen'];
                    if (isOpen != null) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: isOpen ? Colors.green : Colors.red,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              isOpen ? 'Open Now' : 'Closed',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isOpen ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Website
                  Obx(() {
                    final website = controller.selectedPlaceDetails['website'];
                    if (website != null && website != 'N/A') {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildInfoRow(Icons.language, website),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  SizedBox(height: 24.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final lat = locationData['latitude'];
                            final lng = locationData['longitude'];
                            // Open in Google Maps
                            controller.openInGoogleMaps(lat, lng);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          icon: Icon(Icons.directions),
                          label: Text('Directions'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            controller.savePlace(locationData);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          icon: Icon(Icons.bookmark_border),
                          label: Text('Save'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Nearby Places Section
                  Text(
                    'Nearby Places',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Category Tabs
                  _buildNearbyCategories(controller),
                ],
              ),
            ),
          ),

          // Nearby Places List
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoadingNearbyPlaces.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.h),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.nearbyPlaces.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.h),
                    child: Text(
                      'No nearby places found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = controller.nearbyPlaces[index];
                  return _buildNearbyPlaceCard(place, controller);
                },
              );
            }),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 32.h),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 80.sp,
            color: Colors.grey[500],
          ),
          SizedBox(height: 8.h),
          Text(
            'No images available',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyCategories(MapController controller) {
    final categories = [
      {'name': 'Hotel', 'icon': Icons.hotel, 'type': 'lodging'},
      {'name': 'Restaurant', 'icon': Icons.restaurant, 'type': 'restaurant'},
      {'name': 'ATM', 'icon': Icons.atm, 'type': 'atm'},
      {'name': 'Shopping', 'icon': Icons.shopping_bag, 'type': 'shopping_mall'},
      {'name': 'Hospital', 'icon': Icons.local_hospital, 'type': 'hospital'},
    ];

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          
          return Obx(() {
            final isSelected = controller.selectedNearbyCategory.value == category['type'];
            
            return GestureDetector(
              onTap: () {
                controller.selectedNearbyCategory.value = category['type'] as String;
                final lat = locationData['latitude'];
                final lng = locationData['longitude'];
                controller.searchNearbyPlaces(lat, lng, category['type'] as String);
              },
              child: Container(
                width: 90.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 32.sp,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildNearbyPlaceCard(Map<String, dynamic> place, MapController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to this place's details
          final lat = place['latitude'];
          final lng = place['longitude'];
          controller.onMapTap(LatLng(lat, lng));
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.grey[300],
                  child: place['photo'] != null
                      ? Image.network(
                          controller.getPhotoUrl(place['photo']),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[500],
                              size: 40.sp,
                            );
                          },
                        )
                      : Icon(
                          Icons.location_on,
                          color: Colors.grey[500],
                          size: 40.sp,
                        ),
                ),
              ),
              SizedBox(width: 12.w),

              // Place Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    if (place['rating'] != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            place['rating'].toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.place, color: Colors.grey[600], size: 14.sp),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            place['vicinity'] ?? place['address'] ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (place['distance'] != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '${place['distance']} km away',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTypes(List types) {
    if (types.isEmpty) return '';
    
    final formatted = types
        .take(3)
        .map((type) => type.toString().replaceAll('_', ' '))
        .join(' • ');
    
    return formatted.capitalize ?? formatted;
  }
}
