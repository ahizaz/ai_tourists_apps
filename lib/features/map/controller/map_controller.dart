// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:ui' as ui;

// import 'package:ai_powered_tourists_app/core/config/api_keys.dart';
// import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
// import 'package:ai_powered_tourists_app/core/urls/urls.dart';
// import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
// import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class MapController extends GetxController {
//   final String apiKey = ApiKeys.googleMapsApiKey;

//   final double initialLat = 3.139003;
//   final double initialLng = 101.686855;

//   // Google Map-এর default POI labels সরিয়ে দেওয়া হচ্ছে।
//   // Places API থেকে clickable marker এবং নাম দেখানো হবে।
//   static const String _interactivePoiMapStyle = '''
//   [
//     {
//       "featureType": "poi",
//       "elementType": "labels",
//       "stylers": [
//         {
//           "visibility": "off"
//         }
//       ]
//     }
//   ]
//   ''';

//   final Rx<CameraPosition> cameraPosition = CameraPosition(
//     target: LatLng(3.139003, 101.686855),
//     zoom: 15,
//   ).obs;

//   CameraPosition visibleCameraPosition = CameraPosition(
//     target: LatLng(3.139003, 101.686855),
//     zoom: 15,
//   );

//   final RxSet<Marker> markers = <Marker>{}.obs;

//   final RxSet<Polyline> routePolylines = <Polyline>{}.obs;
//   final RxBool isLoadingDirections = false.obs;

//   // একই নামের marker icon বারবার তৈরি না করে cache-এ রাখা হবে।
//   final Map<String, BitmapDescriptor> _namedMarkerIconCache =
//       <String, BitmapDescriptor>{};

//   GoogleMapController? gMapController;

//   final RxMap<String, dynamic> selectedPlaceDetails = <String, dynamic>{}.obs;

//   final RxBool showPlaceDetails = false.obs;
//   final RxBool isLoadingPlaceDetails = false.obs;

//   final RxList<Map<String, dynamic>> searchResults =
//       <Map<String, dynamic>>[].obs;

//   final RxBool isSearching = false.obs;

//   final RxList<Map<String, dynamic>> nearbyPlaces =
//       <Map<String, dynamic>>[].obs;

//   final RxBool isLoadingNearbyPlaces = false.obs;

//   final RxString selectedNearbyCategory = 'lodging'.obs;
//   final RxString selectedMapCategory = 'Attractions'.obs;

//   final RxDouble userLat = 0.0.obs;
//   final RxDouble userLng = 0.0.obs;
//   final RxBool hasUserLocation = false.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     try {
//       final homeController = Get.find<HomeController>();

//       if (homeController.currentLat.value != 0.0 &&
//           homeController.currentLng.value != 0.0) {
//         userLat.value = homeController.currentLat.value;
//         userLng.value = homeController.currentLng.value;
//         hasUserLocation.value = true;

//         cameraPosition.value = CameraPosition(
//           target: LatLng(userLat.value, userLng.value),
//           zoom: 16.0,
//         );

//         visibleCameraPosition = cameraPosition.value;
//         return;
//       }
//     } catch (e) {
//       debugPrint('HomeController not found, getting location: $e');
//     }

//     getUserLocation();
//   }

//   Future<void> onMapCreated(GoogleMapController controller) async {
//     gMapController = controller;

//     await controller.setMapStyle(_interactivePoiMapStyle);

//     // Map open হওয়ার সঙ্গে সঙ্গে attraction markers দেখাবে।
//     if (markers.isEmpty) {
//       await searchByCategory('Attractions', showResultMessage: false);
//     }
//   }

//   void onCameraMove(CameraPosition position) {
//     visibleCameraPosition = position;
//   }

//   Future<void> onMapTap(LatLng position) async {
//     try {
//       debugPrint('========================================');
//       debugPrint('CLICKED LOCATION');
//       debugPrint('Latitude: ${position.latitude}');
//       debugPrint('Longitude: ${position.longitude}');
//       debugPrint('========================================');

//       isLoadingPlaceDetails.value = true;
//       showPlaceDetails.value = false;
//       routePolylines.clear();

//       selectedPlaceDetails.assignAll({
//         'name': 'Selected Location',
//         'fullAddress': 'Loading address...',
//         'rating': 'N/A',
//         'phone': 'N/A',
//         'photos': <dynamic>[],
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       });

//       markers.clear();

//       markers.add(
//         Marker(
//           markerId: const MarkerId('tapped_location'),
//           position: position,
//           infoWindow: const InfoWindow(
//             title: 'Loading...',
//             snippet: 'Fetching location details',
//           ),
//         ),
//       );

//       await moveCamera(position.latitude, position.longitude, zoom: 16);

//       final placeId = await getNearbyPlaceDetails(
//         position.latitude,
//         position.longitude,
//       );

//       if (placeId != null) {
//         await getPlaceDetails(placeId);
//       } else {
//         final List<Placemark> placemarks = await placemarkFromCoordinates(
//           position.latitude,
//           position.longitude,
//         );

//         if (placemarks.isNotEmpty) {
//           final place = placemarks.first;
//           final locationName = _getLocationName(place);

//           selectedPlaceDetails.assignAll({
//             'name': locationName,
//             'street': place.street ?? '',
//             'locality': place.locality ?? '',
//             'subLocality': place.subLocality ?? '',
//             'administrativeArea': place.administrativeArea ?? '',
//             'country': place.country ?? '',
//             'postalCode': place.postalCode ?? '',
//             'latitude': position.latitude,
//             'longitude': position.longitude,
//             'fullAddress': _formatAddress(place),
//             'rating': 'N/A',
//             'phone': 'N/A',
//             'photos': <dynamic>[],
//           });
//         }
//       }

//       markers.clear();

//       markers.add(
//         Marker(
//           markerId: const MarkerId('selected_location'),
//           position: position,
//           consumeTapEvents: true,
//           infoWindow: InfoWindow(
//             title: selectedPlaceDetails['name'] ?? 'Selected Location',
//             snippet: selectedPlaceDetails['fullAddress'] ?? '',
//           ),
//           onTap: () {
//             showPlaceDetails.value = true;
//           },
//         ),
//       );

//       showPlaceDetails.value = true;

//       await searchNearbyPlaces(
//         position.latitude,
//         position.longitude,
//         selectedNearbyCategory.value,
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get location details: $e');
//     } finally {
//       isLoadingPlaceDetails.value = false;
//     }
//   }

//   Future<String?> getNearbyPlaceDetails(double lat, double lng) async {
//     try {
//       final url =
//           'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=$lat,$lng'
//           '&radius=50'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['results'] != null && data['results'].isNotEmpty) {
//           final place = data['results'][0];

//           if (place['place_id'] != null) {
//             return place['place_id'].toString();
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error getting nearby places: $e');
//     }

//     return null;
//   }

//   Future<void> getPlaceDetails(String placeId) async {
//     try {
//       final url =
//           'https://maps.googleapis.com/maps/api/place/details/json'
//           '?place_id=$placeId'
//           '&fields=name,formatted_address,formatted_phone_number,'
//           'rating,opening_hours,website,types,geometry,photos,'
//           'reviews,price_level,url'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['result'] != null) {
//           final result = data['result'];
//           final geometry = result['geometry'];

//           List<dynamic> allPhotos = [];

//           if (result['photos'] != null) {
//             allPhotos = List<dynamic>.from(result['photos']);
//           }

//           selectedPlaceDetails.assignAll({
//             'name': result['name'] ?? 'Unknown Location',
//             'fullAddress':
//                 result['formatted_address'] ?? 'Address not available',
//             'phone': result['formatted_phone_number'] ?? 'N/A',
//             'rating': result['rating'] ?? 'N/A',
//             'website': result['website'] ?? 'N/A',
//             'types': result['types'] ?? [],
//             'openingHours': result['opening_hours']?['weekday_text'] ?? [],
//             'isOpen': result['opening_hours']?['open_now'] ?? false,
//             'photos': allPhotos,
//             'reviews': result['reviews'] ?? [],
//             'priceLevel': result['price_level'] ?? 'N/A',
//             'latitude':
//                 geometry?['location']?['lat'] ??
//                 selectedPlaceDetails['latitude'],
//             'longitude':
//                 geometry?['location']?['lng'] ??
//                 selectedPlaceDetails['longitude'],
//             'place_id': placeId,
//             'url': result['url'] ?? '',
//           });

//           debugPrint(
//             'Loaded ${allPhotos.length} photos for '
//             '${result['name']}',
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error getting place details: $e');
//     }
//   }

//   Future<void> openPlaceFromMap({
//     required String placeId,
//     required String name,
//     required String address,
//     required double lat,
//     required double lng,
//     dynamic rating,
//   }) async {
//     try {
//       isLoadingPlaceDetails.value = true;
//       searchResults.clear();
//       routePolylines.clear();

//       selectedPlaceDetails.assignAll({
//         'name': name,
//         'fullAddress': address,
//         'rating': rating ?? 'N/A',
//         'phone': 'N/A',
//         'photos': <dynamic>[],
//         'latitude': lat,
//         'longitude': lng,
//         'place_id': placeId,
//       });

//       showPlaceDetails.value = true;

//       await moveCamera(lat, lng, zoom: 16);

//       await getPlaceDetails(placeId);

//       selectedPlaceDetails['name'] ??= name;
//       selectedPlaceDetails['fullAddress'] ??= address;
//       selectedPlaceDetails['latitude'] ??= lat;
//       selectedPlaceDetails['longitude'] ??= lng;
//       selectedPlaceDetails['place_id'] ??= placeId;

//       selectedPlaceDetails.refresh();
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load place details: $e');
//     } finally {
//       isLoadingPlaceDetails.value = false;
//     }
//   }

//   Future<void> searchPlaces(String query) async {
//     if (query.trim().isEmpty) {
//       searchResults.clear();
//       isSearching.value = false;
//       return;
//     }

//     try {
//       isSearching.value = true;

//       final currentLat = visibleCameraPosition.target.latitude;

//       final currentLng = visibleCameraPosition.target.longitude;

//       final encodedQuery = Uri.encodeQueryComponent(query.trim());

//       final url =
//           'https://maps.googleapis.com/maps/api/place/textsearch/json'
//           '?query=$encodedQuery'
//           '&location=$currentLat,$currentLng'
//           '&radius=50000'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['results'] != null) {
//           searchResults.assignAll(
//             List<Map<String, dynamic>>.from(
//               data['results'].map(
//                 (place) => {
//                   'name': place['name'],
//                   'address':
//                       place['formatted_address'] ?? place['vicinity'] ?? '',
//                   'lat': place['geometry']['location']['lat'],
//                   'lng': place['geometry']['location']['lng'],
//                   'place_id': place['place_id'],
//                   'rating': place['rating']?.toString() ?? 'N/A',
//                   'types': place['types'] ?? [],
//                 },
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to search: $e');
//     } finally {
//       isSearching.value = false;
//     }
//   }

//   String _placeTypeForCategoryChip(String category) {
//     switch (category) {
//       case 'Attractions':
//         return 'tourist_attraction';

//       case 'Hotel':
//         return 'lodging';

//       case 'Restaurant':
//         return 'restaurant';

//       case 'ATMs':
//         return 'atm';

//       case 'Shopping Mall':
//         return 'shopping_mall';

//       case 'Hospital':
//         return 'hospital';

//       default:
//         return category.toLowerCase();
//     }
//   }

//   // Google Maps InfoWindow শুধু marker tap করলে দেখা যায়।
//   // তাই custom marker bitmap-এর মধ্যে place name আঁকা হচ্ছে।
//   // এর ফলে attraction-এর নাম map-এ সবসময় visible থাকবে।
//   Future<BitmapDescriptor> _buildNamedMarkerIcon(String placeName) async {
//     final String label = placeName.trim().isEmpty
//         ? 'Unknown Location'
//         : placeName.trim();

//     final BitmapDescriptor? cachedIcon = _namedMarkerIconCache[label];

//     if (cachedIcon != null) {
//       return cachedIcon;
//     }

//     const double minMarkerWidth = 96;
//     const double maxMarkerWidth = 190;
//     const double markerHeight = 72;
//     const double labelHeight = 30;
//     const double horizontalPadding = 12;
//     const double pixelRatio = 3;

//     final TextPainter textPainter = TextPainter(
//       text: TextSpan(
//         text: label,
//         style: const TextStyle(
//           color: Color(0xFF222222),
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//       maxLines: 1,
//       ellipsis: '…',
//     )..layout(maxWidth: maxMarkerWidth - (horizontalPadding * 2));

//     final double markerWidth = max(
//       minMarkerWidth,
//       textPainter.width + (horizontalPadding * 2),
//     ).clamp(minMarkerWidth, maxMarkerWidth).toDouble();

//     final ui.PictureRecorder recorder = ui.PictureRecorder();

//     final ui.Canvas canvas = ui.Canvas(recorder)..scale(pixelRatio);

//     final ui.Rect labelRect = ui.Rect.fromLTWH(0, 0, markerWidth, labelHeight);

//     final ui.Path labelPath = ui.Path()
//       ..addRRect(
//         ui.RRect.fromRectAndRadius(labelRect, const ui.Radius.circular(8)),
//       );

//     canvas.drawShadow(labelPath, const Color(0x55000000), 3, true);

//     canvas.drawPath(
//       labelPath,
//       ui.Paint()
//         ..color = Colors.white
//         ..style = ui.PaintingStyle.fill,
//     );

//     canvas.drawPath(
//       labelPath,
//       ui.Paint()
//         ..color = const Color(0x22000000)
//         ..style = ui.PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );

//     textPainter.paint(
//       canvas,
//       Offset(
//         (markerWidth - textPainter.width) / 2,
//         (labelHeight - textPainter.height) / 2,
//       ),
//     );

//     final double pinCenterX = markerWidth / 2;

//     final ui.Path pinPath = ui.Path()
//       ..moveTo(pinCenterX, markerHeight - 2)
//       ..cubicTo(pinCenterX - 2, 63, pinCenterX - 13, 55, pinCenterX - 13, 44)
//       ..cubicTo(pinCenterX - 13, 36.8, pinCenterX - 7.2, 31, pinCenterX, 31)
//       ..cubicTo(
//         pinCenterX + 7.2,
//         31,
//         pinCenterX + 13,
//         36.8,
//         pinCenterX + 13,
//         44,
//       )
//       ..cubicTo(
//         pinCenterX + 13,
//         55,
//         pinCenterX + 2,
//         63,
//         pinCenterX,
//         markerHeight - 2,
//       )
//       ..close();

//     canvas.drawShadow(pinPath, const Color(0x66000000), 3, true);

//     canvas.drawPath(
//       pinPath,
//       ui.Paint()
//         ..color = const Color(0xFFE53935)
//         ..style = ui.PaintingStyle.fill,
//     );

//     canvas.drawCircle(
//       Offset(pinCenterX, 44),
//       4.5,
//       ui.Paint()
//         ..color = Colors.white
//         ..style = ui.PaintingStyle.fill,
//     );

//     final ui.Image markerImage = await recorder.endRecording().toImage(
//       (markerWidth * pixelRatio).ceil(),
//       (markerHeight * pixelRatio).ceil(),
//     );

//     final ByteData? pngData = await markerImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );

//     markerImage.dispose();

//     if (pngData == null) {
//       return BitmapDescriptor.defaultMarker;
//     }

//     final Uint8List bytes = pngData.buffer.asUint8List();

//     final BitmapDescriptor markerIcon = BitmapDescriptor.bytes(
//       bytes,
//       width: markerWidth,
//       height: markerHeight,
//     );

//     _namedMarkerIconCache[label] = markerIcon;

//     return markerIcon;
//   }

//   Future<void> searchByCategory(
//     String category, {
//     bool showResultMessage = true,
//   }) async {
//     try {
//       isSearching.value = true;
//       selectedMapCategory.value = category;

//       final placeType = _placeTypeForCategoryChip(category);

//       final currentLat = visibleCameraPosition.target.latitude;

//       final currentLng = visibleCameraPosition.target.longitude;

//       final url =
//           'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=$currentLat,$currentLng'
//           '&radius=5000'
//           '&type=$placeType'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['results'] != null) {
//           markers.clear();

//           for (final place in data['results']) {
//             final double lat = (place['geometry']['location']['lat'] as num)
//                 .toDouble();

//             final double lng = (place['geometry']['location']['lng'] as num)
//                 .toDouble();

//             final String placeId = place['place_id'].toString();

//             final String placeName = (place['name'] ?? 'Unknown Location')
//                 .toString();

//             final String placeAddress =
//                 (place['vicinity'] ?? place['formatted_address'] ?? '')
//                     .toString();

//             // Place name-সহ custom marker তৈরি করা হচ্ছে।
//             final BitmapDescriptor namedMarkerIcon =
//                 await _buildNamedMarkerIcon(placeName);

//             markers.add(
//               Marker(
//                 markerId: MarkerId(placeId),
//                 position: LatLng(lat, lng),
//                 icon: namedMarkerIcon,
//                 anchor: const Offset(0.5, 1.0),
//                 consumeTapEvents: true,
//                 infoWindow: InfoWindow(title: placeName, snippet: placeAddress),
//                 onTap: () async {
//                   await openPlaceFromMap(
//                     placeId: placeId,
//                     name: placeName,
//                     address: placeAddress,
//                     lat: lat,
//                     lng: lng,
//                     rating: place['rating'],
//                   );
//                 },
//               ),
//             );
//           }

//           if (showResultMessage && data['results'].isNotEmpty) {
//             final resultsCount = data['results'].length as int;

//             final hasMore =
//                 data['next_page_token'] != null &&
//                 data['next_page_token'].toString().isNotEmpty;

//             final displayCount = hasMore ? '$resultsCount+' : '$resultsCount';

//             final countLabel = category == 'Attractions'
//                 ? 'attractions'
//                 : category.toLowerCase();

//             Get.snackbar(
//               'Results',
//               'Found $displayCount $countLabel nearby',
//               snackPosition: SnackPosition.BOTTOM,
//               duration: const Duration(seconds: 2),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to search category: $e');
//     } finally {
//       isSearching.value = false;
//     }
//   }

//   Future<void> selectSearchResult(Map<String, dynamic> result) async {
//     try {
//       final double lat = (result['lat'] as num).toDouble();

//       final double lng = (result['lng'] as num).toDouble();

//       final String placeId = result['place_id'].toString();

//       final String name = (result['name'] ?? 'Unknown Location').toString();

//       final String address = (result['address'] ?? '').toString();

//       final BitmapDescriptor namedMarkerIcon = await _buildNamedMarkerIcon(
//         name,
//       );

//       markers.clear();

//       markers.add(
//         Marker(
//           markerId: MarkerId(placeId),
//           position: LatLng(lat, lng),
//           icon: namedMarkerIcon,
//           anchor: const Offset(0.5, 1.0),
//           consumeTapEvents: true,
//           infoWindow: InfoWindow(title: name, snippet: address),
//           onTap: () async {
//             await openPlaceFromMap(
//               placeId: placeId,
//               name: name,
//               address: address,
//               lat: lat,
//               lng: lng,
//               rating: result['rating'],
//             );
//           },
//         ),
//       );

//       searchResults.clear();

//       await openPlaceFromMap(
//         placeId: placeId,
//         name: name,
//         address: address,
//         lat: lat,
//         lng: lng,
//         rating: result['rating'],
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to select location: $e');
//     }
//   }

//   Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
//     final newPosition = CameraPosition(target: LatLng(lat, lng), zoom: zoom);

//     cameraPosition.value = newPosition;
//     visibleCameraPosition = newPosition;

//     if (gMapController != null) {
//       await gMapController!.animateCamera(
//         CameraUpdate.newCameraPosition(newPosition),
//       );
//     }
//   }

//   Future<void> getUserLocation() async {
//     try {
//       final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         debugPrint('Location services are disabled');
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied) {
//           debugPrint('Location permission denied');
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         debugPrint('Location permission permanently denied');
//         return;
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       userLat.value = position.latitude;
//       userLng.value = position.longitude;
//       hasUserLocation.value = true;

//       cameraPosition.value = CameraPosition(
//         target: LatLng(position.latitude, position.longitude),
//         zoom: 16,
//       );

//       visibleCameraPosition = cameraPosition.value;

//       debugPrint(
//         'User location: ${position.latitude}, '
//         '${position.longitude}',
//       );
//     } catch (e) {
//       debugPrint('Failed to get user location: $e');
//       hasUserLocation.value = false;
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     try {
//       final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         Get.snackbar('Error', 'Location services are disabled');
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied) {
//           Get.snackbar('Error', 'Location permission denied');
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar(
//           'Error',
//           'Location permission permanently denied. '
//               'Please enable it from settings.',
//         );
//         return;
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       userLat.value = position.latitude;
//       userLng.value = position.longitude;
//       hasUserLocation.value = true;
//       routePolylines.clear();

//       await moveCamera(position.latitude, position.longitude, zoom: 16);

//       final placeId = await getNearbyPlaceDetails(
//         position.latitude,
//         position.longitude,
//       );

//       if (placeId != null) {
//         await getPlaceDetails(placeId);

//         markers.clear();

//         markers.add(
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: LatLng(position.latitude, position.longitude),
//             consumeTapEvents: true,
//             infoWindow: InfoWindow(
//               title: selectedPlaceDetails['name'] ?? 'Current Location',
//               snippet: selectedPlaceDetails['fullAddress'] ?? '',
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueBlue,
//             ),
//             onTap: () {
//               showPlaceDetails.value = true;
//             },
//           ),
//         );

//         showPlaceDetails.value = true;
//       } else {
//         selectedPlaceDetails.assignAll({
//           'name': 'Current Location',
//           'fullAddress': '',
//           'rating': 'N/A',
//           'phone': 'N/A',
//           'photos': <dynamic>[],
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//         });

//         markers.clear();

//         markers.add(
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: LatLng(position.latitude, position.longitude),
//             consumeTapEvents: true,
//             infoWindow: const InfoWindow(title: 'Current Location'),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueBlue,
//             ),
//             onTap: () {
//               showPlaceDetails.value = true;
//             },
//           ),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get current location: $e');
//     }
//   }

//   String _getLocationName(Placemark place) {
//     if (place.subLocality?.isNotEmpty ?? false) {
//       return place.subLocality!;
//     }

//     if (place.locality?.isNotEmpty ?? false) {
//       return place.locality!;
//     }

//     if (place.administrativeArea?.isNotEmpty ?? false) {
//       return place.administrativeArea!;
//     }

//     if (place.street?.isNotEmpty ?? false) {
//       if (!place.street!.contains('+')) {
//         return place.street!;
//       }
//     }

//     return 'Selected Location';
//   }

//   String _formatAddress(Placemark place) {
//     final List<String> parts = [];

//     if (place.street?.isNotEmpty ?? false) {
//       parts.add(place.street!);
//     }

//     if (place.subLocality?.isNotEmpty ?? false) {
//       parts.add(place.subLocality!);
//     }

//     if (place.locality?.isNotEmpty ?? false) {
//       parts.add(place.locality!);
//     }

//     if (place.administrativeArea?.isNotEmpty ?? false) {
//       parts.add(place.administrativeArea!);
//     }

//     if (place.country?.isNotEmpty ?? false) {
//       parts.add(place.country!);
//     }

//     return parts.join(', ');
//   }

//   String getPhotoUrl(String photoReference, {int maxWidth = 800}) {
//     return 'https://maps.googleapis.com/maps/api/place/photo'
//         '?maxwidth=$maxWidth'
//         '&photo_reference=$photoReference'
//         '&key=$apiKey';
//   }

//   List<String> getPhotoUrls(
//     List<dynamic> photos, {
//     int maxCount = 5,
//     int maxWidth = 800,
//   }) {
//     final List<String> urls = [];

//     final count = photos.length > maxCount ? maxCount : photos.length;

//     for (int i = 0; i < count; i++) {
//       if (photos[i]['photo_reference'] != null) {
//         urls.add(getPhotoUrl(photos[i]['photo_reference'], maxWidth: maxWidth));
//       }
//     }

//     return urls;
//   }

//   Future<void> searchNearbyPlaces(double lat, double lng, String type) async {
//     try {
//       isLoadingNearbyPlaces.value = true;
//       nearbyPlaces.clear();

//       final url =
//           'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=$lat,$lng'
//           '&radius=5000'
//           '&type=$type'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['results'] != null) {
//           nearbyPlaces.assignAll(
//             List<Map<String, dynamic>>.from(
//               data['results'].take(10).map((place) {
//                 final double placeLat =
//                     (place['geometry']['location']['lat'] as num).toDouble();

//                 final double placeLng =
//                     (place['geometry']['location']['lng'] as num).toDouble();

//                 final distance = _calculateDistance(
//                   lat,
//                   lng,
//                   placeLat,
//                   placeLng,
//                 );

//                 return {
//                   'name': place['name'],
//                   'vicinity': place['vicinity'],
//                   'address': place['formatted_address'] ?? place['vicinity'],
//                   'rating': place['rating'],
//                   'latitude': placeLat,
//                   'longitude': placeLng,
//                   'place_id': place['place_id'],
//                   'photo': place['photos']?[0]?['photo_reference'],
//                   'distance': distance.toStringAsFixed(1),
//                   'isOpen': place['opening_hours']?['open_now'],
//                 };
//               }),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error searching nearby places: $e');

//       Get.snackbar('Error', 'Failed to load nearby places');
//     } finally {
//       isLoadingNearbyPlaces.value = false;
//     }
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2,
//   ) {
//     const double earthRadius = 6371;

//     final dLat = _degreesToRadians(lat2 - lat1);

//     final dLon = _degreesToRadians(lon2 - lon1);

//     final a =
//         (sin(dLat / 2) * sin(dLat / 2)) +
//         cos(_degreesToRadians(lat1)) *
//             cos(_degreesToRadians(lat2)) *
//             (sin(dLon / 2) * sin(dLon / 2));

//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));

//     return earthRadius * c;
//   }

//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }

//   Future<void> openInGoogleMaps(double lat, double lng) async {
//     try {
//       await showInternalDirections(lat, lng);
//     } catch (e) {
//       debugPrint('Error loading internal directions: $e');

//       Get.snackbar(
//         'Error',
//         'Failed to load directions',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> showInternalDirections(double lat, double lng) async {
//     try {
//       isLoadingDirections.value = true;
//       routePolylines.clear();

//       final origin = hasUserLocation.value
//           ? LatLng(userLat.value, userLng.value)
//           : visibleCameraPosition.target;
//       final destination = LatLng(lat, lng);

//       final routePoints = await _fetchDirectionsPolyline(origin, destination);

//       if (routePoints.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'No route could be loaded for this location',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }

//       routePolylines.add(
//         Polyline(
//           polylineId: const PolylineId('selected_route'),
//           points: routePoints,
//           color: Colors.blue,
//           width: 6,
//         ),
//       );

//       await _fitRouteOnMap(routePoints);
//     } catch (e) {
//       debugPrint('Error building internal directions: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to load directions',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoadingDirections.value = false;
//     }
//   }

//   Future<List<LatLng>> _fetchDirectionsPolyline(
//     LatLng origin,
//     LatLng destination,
//   ) async {
//     try {
//       final url =
//           'https://maps.googleapis.com/maps/api/directions/json'
//           '?origin=${origin.latitude},${origin.longitude}'
//           '&destination=${destination.latitude},${destination.longitude}'
//           '&mode=driving'
//           '&key=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode != 200) {
//         return <LatLng>[];
//       }

//       final data = json.decode(response.body);
//       if (data['routes'] == null || data['routes'].isEmpty) {
//         return <LatLng>[];
//       }

//       final polylinePoints =
//           data['routes'][0]['overview_polyline']?['points'] as String?;

//       if (polylinePoints == null || polylinePoints.isEmpty) {
//         return <LatLng>[];
//       }

//       return _decodePolyline(polylinePoints);
//     } catch (e) {
//       debugPrint('Error fetching route polyline: $e');
//       return <LatLng>[];
//     }
//   }

//   List<LatLng> _decodePolyline(String encoded) {
//     final points = <LatLng>[];
//     int index = 0;
//     int lat = 0;
//     int lng = 0;

//     while (index < encoded.length) {
//       int shift = 0;
//       int result = 0;

//       while (true) {
//         final int b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//         if (b < 0x20) {
//           break;
//         }
//       }

//       final int dLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
//       lat += dLat;

//       shift = 0;
//       result = 0;

//       while (true) {
//         final int b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//         if (b < 0x20) {
//           break;
//         }
//       }

//       final int dLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
//       lng += dLng;

//       points.add(LatLng(lat / 1E5, lng / 1E5));
//     }

//     return points;
//   }

//   Future<void> _fitRouteOnMap(List<LatLng> routePoints) async {
//     if (gMapController == null || routePoints.isEmpty) {
//       return;
//     }

//     if (routePoints.length == 1) {
//       await gMapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(routePoints.first, 15),
//       );
//       return;
//     }

//     double minLat = routePoints.first.latitude;
//     double maxLat = routePoints.first.latitude;
//     double minLng = routePoints.first.longitude;
//     double maxLng = routePoints.first.longitude;

//     for (final point in routePoints) {
//       minLat = min(minLat, point.latitude);
//       maxLat = max(maxLat, point.latitude);
//       minLng = min(minLng, point.longitude);
//       maxLng = max(maxLng, point.longitude);
//     }

//     final bounds = LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );

//     await gMapController!.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 80),
//     );
//   }

//   Future<void> savePlace(Map<String, dynamic> placeData) async {
//     try {
//       final token = Get.find<StorageService>().getAccessToken();

//       if (token == null || token.isEmpty) {
//         debugPrint('No access token found');

//         EasyLoading.showError('Authentication required');
//         return;
//       }

//       ProfileController profile;

//       try {
//         if (Get.isRegistered<ProfileController>()) {
//           profile = Get.find<ProfileController>();
//         } else {
//           profile = Get.put(ProfileController());
//         }

//         if (!profile.hasLoadedSavedPlaces.value) {
//           await profile.fetchSavedPlaces();
//         }
//       } catch (e) {
//         debugPrint('Error accessing ProfileController: $e');
//       }

//       final placeName = (placeData['place_name'] ?? placeData['name'] ?? '')
//           .toString();

//       if (placeName.isNotEmpty) {
//         try {
//           if (Get.isRegistered<ProfileController>()) {
//             final profileController = Get.find<ProfileController>();

//             if (profileController.isPlaceSaved(placeName)) {
//               EasyLoading.showInfo('Already saved');

//               Get.snackbar(
//                 'Info',
//                 '$placeName already saved',
//                 snackPosition: SnackPosition.BOTTOM,
//               );

//               return;
//             }
//           }
//         } catch (e) {
//           debugPrint('Error checking saved places: $e');
//         }
//       }

//       EasyLoading.show(status: 'Saving...');

//       final normalizedName =
//           (placeData['place_name'] ?? placeData['name'] ?? '').toString();

//       final normalizedAddress =
//           (placeData['place_address'] ??
//                   placeData['fullAddress'] ??
//                   placeData['vicinity'] ??
//                   '')
//               .toString();

//       final normalizedDescription =
//           (placeData['place_description'] ?? normalizedAddress).toString();

//       final normalizedImage = (placeData['place_image'] ?? '').toString();

//       final rawRating = (placeData['place_rating'] ?? placeData['rating'] ?? '')
//           .toString();

//       final normalizedRating = rawRating == 'N/A' || rawRating == 'null'
//           ? ''
//           : rawRating;

//       final normalizedLat = placeData['latitude'] ?? placeData['lat'] ?? 0.0;

//       final normalizedLng = placeData['longitude'] ?? placeData['lng'] ?? 0.0;

//       final rawPlaceId = (placeData['place_id'] ?? placeData['id'] ?? '')
//           .toString()
//           .trim();

//       final normalizedPlaceId = rawPlaceId.isNotEmpty
//           ? rawPlaceId
//           : 'custom_'
//                 '${normalizedLat.toStringAsFixed(6)}_'
//                 '${normalizedLng.toStringAsFixed(6)}';

//       final payload = <String, dynamic>{
//         'place_id': normalizedPlaceId,
//         'place_name': normalizedName,
//         'place_description': normalizedDescription.isNotEmpty
//             ? normalizedDescription
//             : normalizedName,
//         if (normalizedAddress.isNotEmpty) 'place_address': normalizedAddress,
//         if (normalizedImage.isNotEmpty) 'place_image': normalizedImage,
//         if (normalizedRating.isNotEmpty) 'place_rating': normalizedRating,
//         'latitude': normalizedLat,
//         'longitude': normalizedLng,
//       };

//       debugPrint('API: ${Url.savePlace}');

//       debugPrint('Sending payload: $payload');

//       final response = await http.post(
//         Uri.parse(Url.savePlace),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(payload),
//       );

//       debugPrint('Save place status: ${response.statusCode}');

//       debugPrint('Save place body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         EasyLoading.dismiss();

//         EasyLoading.showSuccess('Place saved');

//         Get.snackbar(
//           'Saved',
//           '${normalizedName.isNotEmpty ? normalizedName : 'Place'} '
//               'saved successfully',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         try {
//           if (Get.isRegistered<ProfileController>()) {
//             final profileController = Get.find<ProfileController>();

//             profileController.hasLoadedSavedPlaces.value = false;

//             await profileController.fetchSavedPlaces();
//           }
//         } catch (e) {
//           debugPrint('Error refreshing saved places: $e');
//         }
//       } else {
//         EasyLoading.dismiss();

//         EasyLoading.showError('Failed to save');

//         Get.snackbar(
//           'Error',
//           'Failed to save place',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       EasyLoading.dismiss();

//       debugPrint('Exception saving place: $e');

//       EasyLoading.showError('Failed to save');
//     }
//   }

//   @override
//   void onClose() {
//     gMapController?.dispose();

//     markers.clear();
//     _namedMarkerIconCache.clear();
//     searchResults.clear();
//     nearbyPlaces.clear();
//     selectedPlaceDetails.clear();

//     super.onClose();
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ai_powered_tourists_app/core/config/api_keys.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController {
  final String apiKey = ApiKeys.googleMapsApiKey;

  final double initialLat = 3.139003;
  final double initialLng = 101.686855;

  // =====================================================
  // Google Map Style
  // =====================================================
  static const String _interactivePoiMapStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    }
  ]
  ''';

  // =====================================================
  // Camera
  // =====================================================
  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(3.139003, 101.686855),
    zoom: 15,
  ).obs;

  CameraPosition visibleCameraPosition = CameraPosition(
    target: LatLng(3.139003, 101.686855),
    zoom: 15,
  );

  // =====================================================
  // Map Data
  // =====================================================
  final RxSet<Marker> markers = <Marker>{}.obs;

  final RxSet<Polyline> routePolylines = <Polyline>{}.obs;

  final RxBool isLoadingDirections = false.obs;

  final Map<String, BitmapDescriptor> _namedMarkerIconCache =
      <String, BitmapDescriptor>{};

  GoogleMapController? gMapController;

  // =====================================================
  // Selected Place
  // =====================================================
  final RxMap<String, dynamic> selectedPlaceDetails = <String, dynamic>{}.obs;

  final RxBool showPlaceDetails = false.obs;

  final RxBool isLoadingPlaceDetails = false.obs;

  // =====================================================
  // Search
  // =====================================================
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;

  final RxBool isSearching = false.obs;

  // =====================================================
  // Nearby Places
  // =====================================================
  final RxList<Map<String, dynamic>> nearbyPlaces =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoadingNearbyPlaces = false.obs;

  final RxString selectedNearbyCategory = 'lodging'.obs;

  // IMPORTANT:
  // Always store category keys in lowercase.
  final RxString selectedMapCategory = 'attractions'.obs;

  // =====================================================
  // User Location
  // =====================================================
  final RxDouble userLat = 0.0.obs;

  final RxDouble userLng = 0.0.obs;

  final RxBool hasUserLocation = false.obs;

  // =====================================================
  // Init
  // =====================================================
  @override
  void onInit() {
    super.onInit();

    try {
      final homeController = Get.find<HomeController>();

      if (homeController.currentLat.value != 0.0 &&
          homeController.currentLng.value != 0.0) {
        userLat.value = homeController.currentLat.value;
        userLng.value = homeController.currentLng.value;
        hasUserLocation.value = true;

        cameraPosition.value = CameraPosition(
          target: LatLng(userLat.value, userLng.value),
          zoom: 16.0,
        );

        visibleCameraPosition = cameraPosition.value;

        return;
      }
    } catch (e) {
      debugPrint('HomeController not found, getting location: $e');
    }

    getUserLocation();
  }

  // =====================================================
  // Map Created
  // =====================================================
  Future<void> onMapCreated(GoogleMapController controller) async {
    gMapController = controller;

    await controller.setMapStyle(_interactivePoiMapStyle);

    // Show attractions initially.
    if (markers.isEmpty) {
      await searchByCategory('attractions', showResultMessage: false);
    }
  }

  // =====================================================
  // Camera Move
  // =====================================================
  void onCameraMove(CameraPosition position) {
    visibleCameraPosition = position;
  }

  // =====================================================
  // Map Tap
  // =====================================================
  Future<void> onMapTap(LatLng position) async {
    try {
      debugPrint('========================================');
      debugPrint('CLICKED LOCATION');
      debugPrint('Latitude: ${position.latitude}');
      debugPrint('Longitude: ${position.longitude}');
      debugPrint('========================================');

      isLoadingPlaceDetails.value = true;

      showPlaceDetails.value = false;

      routePolylines.clear();

      selectedPlaceDetails.assignAll({
        'name': 'Selected Location',
        'fullAddress': 'Loading address...',
        'rating': 'N/A',
        'phone': 'N/A',
        'photos': <dynamic>[],
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      markers.clear();

      markers.add(
        Marker(
          markerId: const MarkerId('tapped_location'),
          position: position,
          infoWindow: const InfoWindow(
            title: 'Loading...',
            snippet: 'Fetching location details',
          ),
        ),
      );

      await moveCamera(position.latitude, position.longitude, zoom: 16);

      final placeId = await getNearbyPlaceDetails(
        position.latitude,
        position.longitude,
      );

      if (placeId != null) {
        await getPlaceDetails(placeId);
      } else {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          final locationName = _getLocationName(place);

          selectedPlaceDetails.assignAll({
            'name': locationName,
            'street': place.street ?? '',
            'locality': place.locality ?? '',
            'subLocality': place.subLocality ?? '',
            'administrativeArea': place.administrativeArea ?? '',
            'country': place.country ?? '',
            'postalCode': place.postalCode ?? '',
            'latitude': position.latitude,
            'longitude': position.longitude,
            'fullAddress': _formatAddress(place),
            'rating': 'N/A',
            'phone': 'N/A',
            'photos': <dynamic>[],
          });
        }
      }

      markers.clear();

      markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          consumeTapEvents: true,
          infoWindow: InfoWindow(
            title: selectedPlaceDetails['name'] ?? 'Selected Location',
            snippet: selectedPlaceDetails['fullAddress'] ?? '',
          ),
          onTap: () {
            showPlaceDetails.value = true;
          },
        ),
      );

      showPlaceDetails.value = true;

      await searchNearbyPlaces(
        position.latitude,
        position.longitude,
        selectedNearbyCategory.value,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location details: $e');
    } finally {
      isLoadingPlaceDetails.value = false;
    }
  }

  // =====================================================
  // Get Nearby Place ID
  // =====================================================
  Future<String?> getNearbyPlaceDetails(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng'
          '&radius=50'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final place = data['results'][0];

          if (place['place_id'] != null) {
            return place['place_id'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting nearby places: $e');
    }

    return null;
  }

  // =====================================================
  // Place Details
  // =====================================================
  Future<void> getPlaceDetails(String placeId) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=name,formatted_address,formatted_phone_number,'
          'rating,opening_hours,website,types,geometry,photos,'
          'reviews,price_level,url'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'OK') {
          debugPrint('Place Details API status: ${data['status']}');
          return;
        }

        if (data['result'] != null) {
          final result = data['result'];

          final geometry = result['geometry'];

          List<dynamic> allPhotos = [];

          if (result['photos'] != null) {
            allPhotos = List<dynamic>.from(result['photos']);
          }

          selectedPlaceDetails.assignAll({
            'name': result['name'] ?? 'Unknown Location',
            'fullAddress':
                result['formatted_address'] ?? 'Address not available',
            'phone': result['formatted_phone_number'] ?? 'N/A',
            'rating': result['rating'] ?? 'N/A',
            'website': result['website'] ?? 'N/A',
            'types': result['types'] ?? [],
            'openingHours': result['opening_hours']?['weekday_text'] ?? [],
            'isOpen': result['opening_hours']?['open_now'] ?? false,
            'photos': allPhotos,
            'reviews': result['reviews'] ?? [],
            'priceLevel': result['price_level'] ?? 'N/A',
            'latitude':
                geometry?['location']?['lat'] ??
                selectedPlaceDetails['latitude'],
            'longitude':
                geometry?['location']?['lng'] ??
                selectedPlaceDetails['longitude'],
            'place_id': placeId,
            'url': result['url'] ?? '',
          });

          debugPrint(
            'Loaded ${allPhotos.length} photos for '
            '${result['name']}',
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  // =====================================================
  // Open Place From Map
  // =====================================================
  Future<void> openPlaceFromMap({
    required String placeId,
    required String name,
    required String address,
    required double lat,
    required double lng,
    dynamic rating,
  }) async {
    try {
      isLoadingPlaceDetails.value = true;

      searchResults.clear();

      routePolylines.clear();

      selectedPlaceDetails.assignAll({
        'name': name,
        'fullAddress': address,
        'rating': rating ?? 'N/A',
        'phone': 'N/A',
        'photos': <dynamic>[],
        'latitude': lat,
        'longitude': lng,
        'place_id': placeId,
      });

      showPlaceDetails.value = true;

      await moveCamera(lat, lng, zoom: 16);

      await getPlaceDetails(placeId);

      selectedPlaceDetails['name'] ??= name;

      selectedPlaceDetails['fullAddress'] ??= address;

      selectedPlaceDetails['latitude'] ??= lat;

      selectedPlaceDetails['longitude'] ??= lng;

      selectedPlaceDetails['place_id'] ??= placeId;

      selectedPlaceDetails.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load place details: $e');
    } finally {
      isLoadingPlaceDetails.value = false;
    }
  }

  // =====================================================
  // Text Search
  // =====================================================
  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    try {
      isSearching.value = true;

      final currentLat = visibleCameraPosition.target.latitude;

      final currentLng = visibleCameraPosition.target.longitude;

      final encodedQuery = Uri.encodeQueryComponent(query.trim());

      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=$encodedQuery'
          '&location=$currentLat,$currentLng'
          '&radius=50000'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
          debugPrint('Text Search API status: ${data['status']}');

          searchResults.clear();
          return;
        }

        if (data['results'] != null) {
          searchResults.assignAll(
            List<Map<String, dynamic>>.from(
              data['results'].map(
                (place) => {
                  'name': place['name'],
                  'address':
                      place['formatted_address'] ?? place['vicinity'] ?? '',
                  'lat': place['geometry']['location']['lat'],
                  'lng': place['geometry']['location']['lng'],
                  'place_id': place['place_id'],
                  'rating': place['rating']?.toString() ?? 'N/A',
                  'types': place['types'] ?? [],
                },
              ),
            ),
          );
        } else {
          searchResults.clear();
        }
      }
    } catch (e) {
      debugPrint('Search error: $e');

      Get.snackbar('Error', 'Failed to search: $e');
    } finally {
      isSearching.value = false;
    }
  }

  // =====================================================
  // CATEGORY TYPE FIX
  // =====================================================
  String _normalizeCategory(String category) {
    final value = category
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    switch (value) {
      case 'attraction':
      case 'attractions':
      case 'tourist_attraction':
        return 'attractions';

      case 'hotel':
      case 'hotels':
      case 'lodging':
        return 'hotel';

      case 'restaurant':
      case 'restaurants':
        return 'restaurant';

      case 'atm':
      case 'atms':
        return 'atms';

      case 'shopping_mall':
      case 'shopping':
      case 'mall':
        return 'shopping_mall';

      case 'hospital':
      case 'hospitals':
        return 'hospital';

      default:
        return value;
    }
  }

  // =====================================================
  // Google Places Type
  // =====================================================
  String _placeTypeForCategoryChip(String category) {
    final normalized = _normalizeCategory(category);

    switch (normalized) {
      case 'attractions':
        return 'tourist_attraction';

      case 'hotel':
        return 'lodging';

      case 'restaurant':
        return 'restaurant';

      case 'atms':
        return 'atm';

      case 'shopping_mall':
        return 'shopping_mall';

      case 'hospital':
        return 'hospital';

      default:
        return normalized;
    }
  }

  // =====================================================
  // Search Keyword Fallback
  // =====================================================
  String _keywordForCategory(String category) {
    final normalized = _normalizeCategory(category);

    switch (normalized) {
      case 'attractions':
        return 'tourist attraction';

      case 'hotel':
        return 'hotel';

      case 'restaurant':
        return 'restaurant';

      case 'atms':
        return 'ATM';

      case 'shopping_mall':
        return 'shopping mall';

      case 'hospital':
        return 'hospital';

      default:
        return normalized;
    }
  }

  // =====================================================
  // Named Marker Icon
  // =====================================================
  Future<BitmapDescriptor> _buildNamedMarkerIcon(String placeName) async {
    final String label = placeName.trim().isEmpty
        ? 'Unknown Location'
        : placeName.trim();

    final BitmapDescriptor? cachedIcon = _namedMarkerIconCache[label];

    if (cachedIcon != null) {
      return cachedIcon;
    }

    const double minMarkerWidth = 96;
    const double maxMarkerWidth = 190;
    const double markerHeight = 72;
    const double labelHeight = 30;
    const double horizontalPadding = 12;
    const double pixelRatio = 3;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF222222),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxMarkerWidth - (horizontalPadding * 2));

    final double markerWidth = max(
      minMarkerWidth,
      textPainter.width + (horizontalPadding * 2),
    ).clamp(minMarkerWidth, maxMarkerWidth).toDouble();

    final ui.PictureRecorder recorder = ui.PictureRecorder();

    final ui.Canvas canvas = ui.Canvas(recorder)..scale(pixelRatio);

    final ui.Rect labelRect = ui.Rect.fromLTWH(0, 0, markerWidth, labelHeight);

    final ui.Path labelPath = ui.Path()
      ..addRRect(
        ui.RRect.fromRectAndRadius(labelRect, const ui.Radius.circular(8)),
      );

    canvas.drawShadow(labelPath, const Color(0x55000000), 3, true);

    canvas.drawPath(
      labelPath,
      ui.Paint()
        ..color = Colors.white
        ..style = ui.PaintingStyle.fill,
    );

    canvas.drawPath(
      labelPath,
      ui.Paint()
        ..color = const Color(0x22000000)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(
      canvas,
      Offset(
        (markerWidth - textPainter.width) / 2,
        (labelHeight - textPainter.height) / 2,
      ),
    );

    final double pinCenterX = markerWidth / 2;

    final ui.Path pinPath = ui.Path()
      ..moveTo(pinCenterX, markerHeight - 2)
      ..cubicTo(pinCenterX - 2, 63, pinCenterX - 13, 55, pinCenterX - 13, 44)
      ..cubicTo(pinCenterX - 13, 36.8, pinCenterX - 7.2, 31, pinCenterX, 31)
      ..cubicTo(
        pinCenterX + 7.2,
        31,
        pinCenterX + 13,
        36.8,
        pinCenterX + 13,
        44,
      )
      ..cubicTo(
        pinCenterX + 13,
        55,
        pinCenterX + 2,
        63,
        pinCenterX,
        markerHeight - 2,
      )
      ..close();

    canvas.drawShadow(pinPath, const Color(0x66000000), 3, true);

    canvas.drawPath(
      pinPath,
      ui.Paint()
        ..color = const Color(0xFFE53935)
        ..style = ui.PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(pinCenterX, 44),
      4.5,
      ui.Paint()
        ..color = Colors.white
        ..style = ui.PaintingStyle.fill,
    );

    final ui.Image markerImage = await recorder.endRecording().toImage(
      (markerWidth * pixelRatio).ceil(),
      (markerHeight * pixelRatio).ceil(),
    );

    final ByteData? pngData = await markerImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    markerImage.dispose();

    if (pngData == null) {
      return BitmapDescriptor.defaultMarker;
    }

    final Uint8List bytes = pngData.buffer.asUint8List();

    final BitmapDescriptor markerIcon = BitmapDescriptor.bytes(
      bytes,
      width: markerWidth,
      height: markerHeight,
    );

    _namedMarkerIconCache[label] = markerIcon;

    return markerIcon;
  }

  // =====================================================
  // CATEGORY SEARCH — FIXED
  // =====================================================
  Future<void> searchByCategory(
    String category, {
    bool showResultMessage = true,
  }) async {
    final String normalizedCategory = _normalizeCategory(category);

    try {
      isSearching.value = true;

      // Store ONLY normalized lowercase key.
      selectedMapCategory.value = normalizedCategory;

      // IMPORTANT:
      // Clear old markers BEFORE making API request.
      // Otherwise API error can leave previous
      // category markers visible.
      markers.clear();

      showPlaceDetails.value = false;

      selectedPlaceDetails.clear();

      routePolylines.clear();

      final String placeType = _placeTypeForCategoryChip(normalizedCategory);

      final String keyword = _keywordForCategory(normalizedCategory);

      final double currentLat = visibleCameraPosition.target.latitude;

      final double currentLng = visibleCameraPosition.target.longitude;

      debugPrint('========================================');

      debugPrint('CATEGORY SEARCH');

      debugPrint('Original: $category');

      debugPrint('Normalized: $normalizedCategory');

      debugPrint('Google Type: $placeType');

      debugPrint('Keyword: $keyword');

      debugPrint('Location: $currentLat, $currentLng');

      debugPrint('========================================');

      // =================================================
      // First request: Nearby Search using type
      // =================================================
      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$currentLat,$currentLng'
          '&radius=5000'
          '&type=$placeType'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        debugPrint(
          'Nearby Search HTTP error: '
          '${response.statusCode}',
        );

        Get.snackbar(
          'Error',
          'Unable to load places',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      final data = json.decode(response.body);

      final String apiStatus = (data['status'] ?? '').toString();

      debugPrint('Nearby Search API status: $apiStatus');

      List<dynamic> results = data['results'] != null
          ? List<dynamic>.from(data['results'])
          : <dynamic>[];

      // =================================================
      // Keyword fallback
      //
      // Useful for restaurant / mall etc.
      // if type search returns nothing.
      // =================================================
      if (results.isEmpty && apiStatus != 'REQUEST_DENIED') {
        debugPrint(
          'No results using type=$placeType. '
          'Trying keyword=$keyword',
        );

        final fallbackUrl =
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=$currentLat,$currentLng'
            '&radius=5000'
            '&keyword=${Uri.encodeQueryComponent(keyword)}'
            '&key=$apiKey';

        final fallbackResponse = await http.get(Uri.parse(fallbackUrl));

        if (fallbackResponse.statusCode == 200) {
          final fallbackData = json.decode(fallbackResponse.body);

          debugPrint(
            'Fallback API status: '
            '${fallbackData['status']}',
          );

          if (fallbackData['results'] != null) {
            results = List<dynamic>.from(fallbackData['results']);
          }
        }
      }

      // =================================================
      // Handle API errors
      // =================================================
      if (results.isEmpty) {
        markers.clear();

        if (apiStatus == 'REQUEST_DENIED') {
          debugPrint('Google Places API REQUEST_DENIED');

          Get.snackbar(
            'Google Maps',
            'Places API request was denied. '
                'Please check API configuration.',
            snackPosition: SnackPosition.BOTTOM,
          );

          return;
        }

        if (apiStatus == 'ZERO_RESULTS' || results.isEmpty) {
          Get.snackbar(
            'No Results',
            'No ${_displayCategoryName(normalizedCategory)} found nearby.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );

          return;
        }
      }

      // =================================================
      // Build markers
      // =================================================
      markers.clear();

      for (final place in results) {
        try {
          final geometry = place['geometry'];

          final location = geometry?['location'];

          if (location == null) {
            continue;
          }

          final lat = (location['lat'] as num).toDouble();

          final lng = (location['lng'] as num).toDouble();

          final String placeId = (place['place_id'] ?? '${lat}_$lng')
              .toString();

          final String placeName = (place['name'] ?? 'Unknown Location')
              .toString();

          final String placeAddress =
              (place['vicinity'] ?? place['formatted_address'] ?? '')
                  .toString();

          final BitmapDescriptor namedMarkerIcon = await _buildNamedMarkerIcon(
            placeName,
          );

          markers.add(
            Marker(
              markerId: MarkerId(placeId),
              position: LatLng(lat, lng),
              icon: namedMarkerIcon,
              anchor: const Offset(0.5, 1.0),
              consumeTapEvents: true,
              infoWindow: InfoWindow(title: placeName, snippet: placeAddress),
              onTap: () async {
                await openPlaceFromMap(
                  placeId: placeId,
                  name: placeName,
                  address: placeAddress,
                  lat: lat,
                  lng: lng,
                  rating: place['rating'],
                );
              },
            ),
          );
        } catch (e) {
          debugPrint('Error creating marker: $e');
        }
      }

      // =================================================
      // Result Message
      // =================================================
      if (showResultMessage) {
        final int resultsCount = results.length;

        final String countLabel = _displayCategoryName(normalizedCategory);

        if (resultsCount > 0) {
          Get.snackbar(
            'Results',
            'Found $resultsCount '
                '$countLabel nearby',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      }

      debugPrint(
        'Total markers added: '
        '${markers.length}',
      );
    } catch (e) {
      markers.clear();

      debugPrint('Error searching category: $e');

      Get.snackbar(
        'Error',
        'Failed to search category',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  // =====================================================
  // Category Display Name
  // =====================================================
  String _displayCategoryName(String category) {
    switch (_normalizeCategory(category)) {
      case 'attractions':
        return 'attractions';

      case 'hotel':
        return 'hotels';

      case 'restaurant':
        return 'restaurants';

      case 'atms':
        return 'ATMs';

      case 'shopping_mall':
        return 'shopping malls';

      case 'hospital':
        return 'hospitals';

      default:
        return category;
    }
  }

  // =====================================================
  // Select Search Result
  // =====================================================
  Future<void> selectSearchResult(Map<String, dynamic> result) async {
    try {
      final double lat = (result['lat'] as num).toDouble();

      final double lng = (result['lng'] as num).toDouble();

      final String placeId = result['place_id'].toString();

      final String name = (result['name'] ?? 'Unknown Location').toString();

      final String address = (result['address'] ?? '').toString();

      final BitmapDescriptor namedMarkerIcon = await _buildNamedMarkerIcon(
        name,
      );

      markers.clear();

      markers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: LatLng(lat, lng),
          icon: namedMarkerIcon,
          anchor: const Offset(0.5, 1.0),
          consumeTapEvents: true,
          infoWindow: InfoWindow(title: name, snippet: address),
          onTap: () async {
            await openPlaceFromMap(
              placeId: placeId,
              name: name,
              address: address,
              lat: lat,
              lng: lng,
              rating: result['rating'],
            );
          },
        ),
      );

      searchResults.clear();

      await openPlaceFromMap(
        placeId: placeId,
        name: name,
        address: address,
        lat: lat,
        lng: lng,
        rating: result['rating'],
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to select location: $e');
    }
  }

  // =====================================================
  // Move Camera
  // =====================================================
  Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
    final newPosition = CameraPosition(target: LatLng(lat, lng), zoom: zoom);

    cameraPosition.value = newPosition;

    visibleCameraPosition = newPosition;

    if (gMapController != null) {
      await gMapController!.animateCamera(
        CameraUpdate.newCameraPosition(newPosition),
      );
    }
  }

  // =====================================================
  // Get User Location
  // =====================================================
  Future<void> getUserLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission permanently denied');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLat.value = position.latitude;

      userLng.value = position.longitude;

      hasUserLocation.value = true;

      cameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );

      visibleCameraPosition = cameraPosition.value;

      debugPrint(
        'User location: '
        '${position.latitude}, '
        '${position.longitude}',
      );
    } catch (e) {
      debugPrint('Failed to get user location: $e');

      hasUserLocation.value = false;
    }
  }

  // =====================================================
  // Current Location
  // =====================================================
  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Error',
          'Location permission permanently denied. '
              'Please enable it from settings.',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLat.value = position.latitude;

      userLng.value = position.longitude;

      hasUserLocation.value = true;

      routePolylines.clear();

      await moveCamera(position.latitude, position.longitude, zoom: 16);

      final placeId = await getNearbyPlaceDetails(
        position.latitude,
        position.longitude,
      );

      if (placeId != null) {
        await getPlaceDetails(placeId);

        markers.clear();

        markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            consumeTapEvents: true,
            infoWindow: InfoWindow(
              title: selectedPlaceDetails['name'] ?? 'Current Location',
              snippet: selectedPlaceDetails['fullAddress'] ?? '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            onTap: () {
              showPlaceDetails.value = true;
            },
          ),
        );

        showPlaceDetails.value = true;
      } else {
        selectedPlaceDetails.assignAll({
          'name': 'Current Location',
          'fullAddress': '',
          'rating': 'N/A',
          'phone': 'N/A',
          'photos': <dynamic>[],
          'latitude': position.latitude,
          'longitude': position.longitude,
        });

        markers.clear();

        markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            consumeTapEvents: true,
            infoWindow: const InfoWindow(title: 'Current Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            onTap: () {
              showPlaceDetails.value = true;
            },
          ),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  // =====================================================
  // Location Name
  // =====================================================
  String _getLocationName(Placemark place) {
    if (place.subLocality?.isNotEmpty ?? false) {
      return place.subLocality!;
    }

    if (place.locality?.isNotEmpty ?? false) {
      return place.locality!;
    }

    if (place.administrativeArea?.isNotEmpty ?? false) {
      return place.administrativeArea!;
    }

    if (place.street?.isNotEmpty ?? false) {
      if (!place.street!.contains('+')) {
        return place.street!;
      }
    }

    return 'Selected Location';
  }

  // =====================================================
  // Format Address
  // =====================================================
  String _formatAddress(Placemark place) {
    final List<String> parts = [];

    if (place.street?.isNotEmpty ?? false) {
      parts.add(place.street!);
    }

    if (place.subLocality?.isNotEmpty ?? false) {
      parts.add(place.subLocality!);
    }

    if (place.locality?.isNotEmpty ?? false) {
      parts.add(place.locality!);
    }

    if (place.administrativeArea?.isNotEmpty ?? false) {
      parts.add(place.administrativeArea!);
    }

    if (place.country?.isNotEmpty ?? false) {
      parts.add(place.country!);
    }

    return parts.join(', ');
  }

  // =====================================================
  // Photo URL
  // =====================================================
  String getPhotoUrl(String photoReference, {int maxWidth = 800}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }

  // =====================================================
  // Photo URLs
  // =====================================================
  List<String> getPhotoUrls(
    List<dynamic> photos, {
    int maxCount = 5,
    int maxWidth = 800,
  }) {
    final List<String> urls = [];

    final count = photos.length > maxCount ? maxCount : photos.length;

    for (int i = 0; i < count; i++) {
      if (photos[i]['photo_reference'] != null) {
        urls.add(getPhotoUrl(photos[i]['photo_reference'], maxWidth: maxWidth));
      }
    }

    return urls;
  }

  // =====================================================
  // Search Nearby Places
  // =====================================================
  Future<void> searchNearbyPlaces(double lat, double lng, String type) async {
    try {
      isLoadingNearbyPlaces.value = true;

      nearbyPlaces.clear();

      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng'
          '&radius=5000'
          '&type=$type'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          nearbyPlaces.assignAll(
            List<Map<String, dynamic>>.from(
              data['results'].take(10).map((place) {
                final double placeLat =
                    (place['geometry']['location']['lat'] as num).toDouble();

                final double placeLng =
                    (place['geometry']['location']['lng'] as num).toDouble();

                final distance = _calculateDistance(
                  lat,
                  lng,
                  placeLat,
                  placeLng,
                );

                return {
                  'name': place['name'],
                  'vicinity': place['vicinity'],
                  'address': place['formatted_address'] ?? place['vicinity'],
                  'rating': place['rating'],
                  'latitude': placeLat,
                  'longitude': placeLng,
                  'place_id': place['place_id'],
                  'photo': place['photos']?[0]?['photo_reference'],
                  'distance': distance.toStringAsFixed(1),
                  'isOpen': place['opening_hours']?['open_now'],
                };
              }),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error searching nearby places: $e');

      Get.snackbar('Error', 'Failed to load nearby places');
    } finally {
      isLoadingNearbyPlaces.value = false;
    }
  }

  // =====================================================
  // Calculate Distance
  // =====================================================
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371;

    final dLat = _degreesToRadians(lat2 - lat1);

    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // =====================================================
  // Directions
  // =====================================================
  Future<void> openInGoogleMaps(double lat, double lng) async {
    try {
      await showInternalDirections(lat, lng);
    } catch (e) {
      debugPrint('Error loading internal directions: $e');

      Get.snackbar(
        'Error',
        'Failed to load directions',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =====================================================
  // Internal Directions
  // =====================================================
  Future<void> showInternalDirections(double lat, double lng) async {
    try {
      isLoadingDirections.value = true;

      routePolylines.clear();

      final origin = hasUserLocation.value
          ? LatLng(userLat.value, userLng.value)
          : visibleCameraPosition.target;

      final destination = LatLng(lat, lng);

      final routePoints = await _fetchDirectionsPolyline(origin, destination);

      if (routePoints.isEmpty) {
        Get.snackbar(
          'Error',
          'No route could be loaded for this location',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      routePolylines.add(
        Polyline(
          polylineId: const PolylineId('selected_route'),
          points: routePoints,
          color: Colors.blue,
          width: 6,
        ),
      );

      await _fitRouteOnMap(routePoints);
    } catch (e) {
      debugPrint('Error building internal directions: $e');

      Get.snackbar(
        'Error',
        'Failed to load directions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDirections.value = false;
    }
  }

  // =====================================================
  // Fetch Directions Polyline
  // =====================================================
  Future<List<LatLng>> _fetchDirectionsPolyline(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=driving'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return <LatLng>[];
      }

      final data = json.decode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) {
        return <LatLng>[];
      }

      final polylinePoints =
          data['routes'][0]['overview_polyline']?['points'] as String?;

      if (polylinePoints == null || polylinePoints.isEmpty) {
        return <LatLng>[];
      }

      return _decodePolyline(polylinePoints);
    } catch (e) {
      debugPrint('Error fetching route polyline: $e');

      return <LatLng>[];
    }
  }

  // =====================================================
  // Decode Polyline
  // =====================================================
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;

      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;

        result |= (b & 0x1f) << shift;

        shift += 5;

        if (b < 0x20) {
          break;
        }
      }

      final int dLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);

      lat += dLat;

      shift = 0;
      result = 0;

      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;

        result |= (b & 0x1f) << shift;

        shift += 5;

        if (b < 0x20) {
          break;
        }
      }

      final int dLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);

      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // =====================================================
  // Fit Route
  // =====================================================
  Future<void> _fitRouteOnMap(List<LatLng> routePoints) async {
    if (gMapController == null || routePoints.isEmpty) {
      return;
    }

    if (routePoints.length == 1) {
      await gMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(routePoints.first, 15),
      );

      return;
    }

    double minLat = routePoints.first.latitude;

    double maxLat = routePoints.first.latitude;

    double minLng = routePoints.first.longitude;

    double maxLng = routePoints.first.longitude;

    for (final point in routePoints) {
      minLat = min(minLat, point.latitude);

      maxLat = max(maxLat, point.latitude);

      minLng = min(minLng, point.longitude);

      maxLng = max(maxLng, point.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await gMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  // =====================================================
  // Save Place
  // =====================================================
  Future<void> savePlace(Map<String, dynamic> placeData) async {
    try {
      final token = Get.find<StorageService>().getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('No access token found');

        EasyLoading.showError('Authentication required');

        return;
      }

      ProfileController profile;

      try {
        if (Get.isRegistered<ProfileController>()) {
          profile = Get.find<ProfileController>();
        } else {
          profile = Get.put(ProfileController());
        }

        if (!profile.hasLoadedSavedPlaces.value) {
          await profile.fetchSavedPlaces();
        }
      } catch (e) {
        debugPrint('Error accessing ProfileController: $e');
      }

      final placeName = (placeData['place_name'] ?? placeData['name'] ?? '')
          .toString();

      if (placeName.isNotEmpty) {
        try {
          if (Get.isRegistered<ProfileController>()) {
            final profileController = Get.find<ProfileController>();

            if (profileController.isPlaceSaved(placeName)) {
              EasyLoading.showInfo('Already saved');

              Get.snackbar(
                'Info',
                '$placeName already saved',
                snackPosition: SnackPosition.BOTTOM,
              );

              return;
            }
          }
        } catch (e) {
          debugPrint('Error checking saved places: $e');
        }
      }

      EasyLoading.show(status: 'Saving...');

      final normalizedName =
          (placeData['place_name'] ?? placeData['name'] ?? '').toString();

      final normalizedAddress =
          (placeData['place_address'] ??
                  placeData['fullAddress'] ??
                  placeData['vicinity'] ??
                  '')
              .toString();

      final normalizedDescription =
          (placeData['place_description'] ?? normalizedAddress).toString();

      final normalizedImage = (placeData['place_image'] ?? '').toString();

      final rawRating = (placeData['place_rating'] ?? placeData['rating'] ?? '')
          .toString();

      final normalizedRating = rawRating == 'N/A' || rawRating == 'null'
          ? ''
          : rawRating;

      final normalizedLat = placeData['latitude'] ?? placeData['lat'] ?? 0.0;

      final normalizedLng = placeData['longitude'] ?? placeData['lng'] ?? 0.0;

      final rawPlaceId = (placeData['place_id'] ?? placeData['id'] ?? '')
          .toString()
          .trim();

      final normalizedPlaceId = rawPlaceId.isNotEmpty
          ? rawPlaceId
          : 'custom_'
                '${normalizedLat.toStringAsFixed(6)}_'
                '${normalizedLng.toStringAsFixed(6)}';

      final payload = <String, dynamic>{
        'place_id': normalizedPlaceId,
        'place_name': normalizedName,
        'place_description': normalizedDescription.isNotEmpty
            ? normalizedDescription
            : normalizedName,
        if (normalizedAddress.isNotEmpty) 'place_address': normalizedAddress,
        if (normalizedImage.isNotEmpty) 'place_image': normalizedImage,
        if (normalizedRating.isNotEmpty) 'place_rating': normalizedRating,
        'latitude': normalizedLat,
        'longitude': normalizedLng,
      };

      debugPrint('API: ${Url.savePlace}');

      debugPrint('Sending payload: $payload');

      final response = await http.post(
        Uri.parse(Url.savePlace),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      debugPrint(
        'Save place status: '
        '${response.statusCode}',
      );

      debugPrint(
        'Save place body: '
        '${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();

        EasyLoading.showSuccess('Place saved');

        Get.snackbar(
          'Saved',
          '${normalizedName.isNotEmpty ? normalizedName : 'Place'} '
              'saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        try {
          if (Get.isRegistered<ProfileController>()) {
            final profileController = Get.find<ProfileController>();

            profileController.hasLoadedSavedPlaces.value = false;

            await profileController.fetchSavedPlaces();
          }
        } catch (e) {
          debugPrint('Error refreshing saved places: $e');
        }
      } else {
        EasyLoading.dismiss();

        EasyLoading.showError('Failed to save');

        Get.snackbar(
          'Error',
          'Failed to save place',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();

      debugPrint('Exception saving place: $e');

      EasyLoading.showError('Failed to save');
    }
  }

  // =====================================================
  // Dispose
  // =====================================================
  @override
  void onClose() {
    gMapController?.dispose();

    markers.clear();

    _namedMarkerIconCache.clear();

    searchResults.clear();

    nearbyPlaces.clear();

    selectedPlaceDetails.clear();

    super.onClose();
  }
}
