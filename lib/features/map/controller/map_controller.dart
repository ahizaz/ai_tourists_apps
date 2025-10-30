import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  // Static coordinates (example: a point in Dhaka). Replace with whatever static coords you want.
  final double initialLat = 23.7808875;
  final double initialLng = 90.2792371;

  // Observable camera position
  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(23.7808875, 90.2792371),
    zoom: 15,
  ).obs;

  // Observable set of markers
  final RxSet<Marker> markers = <Marker>{}.obs;

  // GoogleMap Controller (non-reactive)
  GoogleMapController? gMapController;

  @override
  void onInit() {
    super.onInit();
    // Add the initial marker
    final initialMarker = Marker(
      markerId: const MarkerId('initial_marker'),
      position: LatLng(initialLat, initialLng),
      infoWindow: const InfoWindow(title: 'You are here'),
    );
    markers.add(initialMarker);
  }

  // Called when the GoogleMap is created
  void onMapCreated(GoogleMapController controller) {
    gMapController = controller;
  }

  // Animate camera to new position
  Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
    final newPos = CameraPosition(target: LatLng(lat, lng), zoom: zoom);
    cameraPosition.value = newPos;
    if (gMapController != null) {
      await gMapController!.animateCamera(CameraUpdate.newCameraPosition(newPos));
    }
    // update marker
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId('marker_${lat}_$lng'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(title: 'Selected location'),
    ));
  }
}