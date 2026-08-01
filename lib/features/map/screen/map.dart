import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:ai_powered_tourists_app/features/map/screen/location_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapController controller = Get.find<MapController>();

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                return GoogleMap(
                  initialCameraPosition: controller.cameraPosition.value,
                  onMapCreated: controller.onMapCreated,
                  onCameraMove: controller.onCameraMove,
                  onTap: controller.onMapTap,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: controller.markers.toSet(),
                  polylines: controller.routePolylines.toSet(),
                );
              }),
            ),

            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildChip('Attractions', controller),
                        _buildChip('Hotel', controller),
                        _buildChip('Restaurant', controller),
                        _buildChip('ATMs', controller),
                        _buildChip('Shopping Mall', controller),
                        _buildChip('Hospital', controller),
                      ],
                    ),
                  ),

                  Obx(() {
                    if (controller.searchResults.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          final result = controller.searchResults[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            title: Text(result['name'] ?? ''),
                            subtitle: Text(
                              result['address'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              searchController.clear();

                              FocusScope.of(context).unfocus();

                              await controller.selectSearchResult(result);
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                ignoring: true,
                child: SizedBox(width: 28, height: 28),
              ),
            ),

            Positioned(
              right: 16,
              bottom: 24,
              child: FloatingActionButton(
                onPressed: () async {
                  await controller.getCurrentLocation();
                },
                child: const Icon(Icons.my_location),
              ),
            ),

            Obx(() {
              if (!controller.showPlaceDetails.value) {
                return const SizedBox.shrink();
              }

              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedPlaceDetails['name'] ??
                                  'Unknown',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              controller.showPlaceDetails.value = false;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      if (controller.selectedPlaceDetails['rating'] != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.selectedPlaceDetails['rating']
                                  .toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              controller.selectedPlaceDetails['fullAddress'] ??
                                  '',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),

                      if (controller.selectedPlaceDetails['phone'] != null &&
                          controller.selectedPlaceDetails['phone'] != 'N/A')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  controller.selectedPlaceDetails['phone'],
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.to(
                                  () => LocationDetailsScreen(
                                    locationData:
                                        controller.selectedPlaceDetails,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.info_outline),
                              label: const Text('View Details'),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final lat =
                                    controller.selectedPlaceDetails['latitude'];

                                final lng = controller
                                    .selectedPlaceDetails['longitude'];

                                if (lat != null && lng != null) {
                                  await controller.openInGoogleMaps(
                                    (lat as num).toDouble(),
                                    (lng as num).toDouble(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.directions),
                              label: const Text('Directions'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await controller.savePlace(
                              controller.selectedPlaceDetails,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text('Save Place'),
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
      child: Obx(() {
        final bool isSelected = controller.selectedMapCategory.value == label;

        return OutlinedButton(
          onPressed: () async {
            await controller.searchByCategory(label);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.white70,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
            ),
          ),
          child: Text(label, style: const TextStyle(fontSize: 13)),
        );
      }),
    );
  }
}
