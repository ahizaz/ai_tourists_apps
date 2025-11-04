import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the controller (will survive as long as route exists)
    final MapController controller = Get.put(MapController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Map area
            Positioned.fill(
              child: Obx(() {
                // Use controller.cameraPosition and controller.markers
                return GoogleMap(
                  initialCameraPosition: controller.cameraPosition.value,
                  onMapCreated: controller.onMapCreated,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: controller.markers.toSet(),
                );
              }),
            ),

            // Top search box with a slight transparent background
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
                      onSubmitted: (value) {
                   
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        hintText: 'Search location',
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
                        _buildChip('Hotel'),
                        _buildChip('Restaurant'),
                        _buildChip('ATMs'),
                        _buildChip('Shopping Mall'),
                        _buildChip('Hospital'),
                      ],
                    ),
                  ),
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

            // Bottom-floating button to "move to static location" (example)
            Positioned(
              right: 16,
              bottom: 24,
              child: FloatingActionButton(
                onPressed: () {
                  // Example: move camera to the static lat/lng from controller
                  controller.moveCamera(controller.initialLat, controller.initialLng, zoom: 16);
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {
          // In the future you can filter places and move the map
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