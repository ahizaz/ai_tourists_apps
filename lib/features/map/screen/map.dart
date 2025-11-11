import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:ai_powered_tourists_app/features/map/screen/location_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapController controller = Get.put(MapController());
    final TextEditingController searchController = TextEditingController();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Map area
            Positioned.fill(
              child: Obx(() {
                return GoogleMap(
                  initialCameraPosition: controller.cameraPosition.value,
                  onMapCreated: controller.onMapCreated,
                  onTap: controller.onMapTap,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: controller.markers.toSet(),
                );
              }),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Column(
                children: [
                  // Search box
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        controller.searchPlaces(value);
                      },
                      onSubmitted: (value) {
                        controller.searchPlaces(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        hintText: 'search_location'.tr,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category chips like in the picture
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [ 
                        _buildChip('Hotel', controller),
                        _buildChip('Restaurant', controller),
                        _buildChip('ATMs', controller),
                        _buildChip('Shopping Mall', controller),
                        _buildChip('Hospital', controller),
                      ],
                    ),
                  ),
                  
                  // Search results dropdown
                  Obx(() {
                    if (controller.searchResults.isEmpty) return SizedBox.shrink();
                    return Container(
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          final result = controller.searchResults[index];
                          return ListTile(
                            leading: Icon(Icons.location_on, color: Colors.red),
                            title: Text(result['name'] ?? ''),
                            subtitle: Text(
                              result['address'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              searchController.clear();
                              controller.selectSearchResult(result);
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Center indicator (red dot) to mimic the screenshot center marker
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: .9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),

          
            Positioned(
              right: 16,
              bottom: 24,
              child: FloatingActionButton(
                onPressed: () {
                  controller.getCurrentLocation();
                },
                child: const Icon(Icons.my_location),
              ),
            ),
            
            // Place details bottom sheet
            Obx(() {
              if (!controller.showPlaceDetails.value) return SizedBox.shrink();
              
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedPlaceDetails['name'] ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              controller.showPlaceDetails.value = false;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (controller.selectedPlaceDetails['rating'] != null)
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              controller.selectedPlaceDetails['rating'].toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey, size: 20),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              controller.selectedPlaceDetails['fullAddress'] ?? '',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                      if (controller.selectedPlaceDetails['phone'] != null && 
                          controller.selectedPlaceDetails['phone'] != 'N/A')
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey, size: 20),
                              SizedBox(width: 4),
                              Text(
                                controller.selectedPlaceDetails['phone'],
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Open detailed view
                                Get.to(() => LocationDetailsScreen(
                                  locationData: controller.selectedPlaceDetails,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.info_outline),
                              label: Text('View Details'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Directions functionality can be added later
                                Get.snackbar('Info', 'Directions feature coming soon');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.directions),
                              label: Text('Directions'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Save functionality
                            controller.savePlace(controller.selectedPlaceDetails);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(Icons.bookmark_border),
                          label: Text('Save Place'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, MapController controller) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {
          controller.searchByCategory(label);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white70,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }
}