import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController {
  // API Key
  final String apiKey = 'AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc';
  
  // Static coordinates (example: a point in Dhaka)
  final double initialLat = 23.7808875;
  final double initialLng = 90.2792371;

  // Observable camera position
  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(23.7808875, 90.2792371),
    zoom: 15,
  ).obs;

  // Observable set of markers
  final RxSet<Marker> markers = <Marker>{}.obs;

  // GoogleMap Controller
  GoogleMapController? gMapController;

  // Selected place details
  final RxMap<String, dynamic> selectedPlaceDetails = <String, dynamic>{}.obs;
  final RxBool showPlaceDetails = false.obs;
  final RxBool isLoadingPlaceDetails = false.obs;

  // Search results
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;

  // Nearby places
  final RxList<Map<String, dynamic>> nearbyPlaces = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingNearbyPlaces = false.obs;
  final RxString selectedNearbyCategory = 'lodging'.obs;

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

  // Handle map tap - get place details
  Future<void> onMapTap(LatLng position) async {
    try {
      isLoadingPlaceDetails.value = true;
      
      // Add marker at tapped location
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('tapped_location'),
        position: position,
        infoWindow: InfoWindow(
          title: 'Loading...',
          snippet: 'Fetching location details',
        ),
      ));

      // Move camera to tapped location
      await moveCamera(position.latitude, position.longitude);

      // Get place details using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        
        // Get a proper location name (not Plus Code)
        final locationName = _getLocationName(place);
        
        // Also try to get nearby places from Google Places API
        await getNearbyPlaceDetails(position.latitude, position.longitude);
        
        // Update marker with place info
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId('selected_location'),
          position: position,
          infoWindow: InfoWindow(
            title: locationName,
            snippet: '${place.locality ?? ''}${place.locality != null && place.administrativeArea != null ? ', ' : ''}${place.administrativeArea ?? ''}',
          ),
          onTap: () {
            showPlaceDetails.value = true;
          },
        ));

        // Set basic details
        selectedPlaceDetails.value = {
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
        };

        // Load nearby places (default: hotels)
        await searchNearbyPlaces(
          position.latitude,
          position.longitude,
          selectedNearbyCategory.value,
        );

        showPlaceDetails.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location details: $e');
    } finally {
      isLoadingPlaceDetails.value = false;
    }
  }

  // Get nearby place details from Google Places API
  Future<void> getNearbyPlaceDetails(double lat, double lng) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng'
          '&radius=50'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final place = data['results'][0];
          
          // Get detailed place info
          if (place['place_id'] != null) {
            await getPlaceDetails(place['place_id']);
          }
        }
      }
    } catch (e) {
      print('Error getting nearby places: $e');
    }
  }

  // Get detailed place information
  Future<void> getPlaceDetails(String placeId) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=name,formatted_address,formatted_phone_number,rating,opening_hours,website,types,geometry,photos'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] != null) {
          final result = data['result'];
          
          // Merge with existing details
          selectedPlaceDetails.addAll({
            'name': result['name'] ?? selectedPlaceDetails['name'],
            'fullAddress': result['formatted_address'] ?? selectedPlaceDetails['fullAddress'],
            'phone': result['formatted_phone_number'] ?? 'N/A',
            'rating': result['rating']?.toString() ?? 'N/A',
            'website': result['website'] ?? 'N/A',
            'types': result['types'] ?? [],
            'openingHours': result['opening_hours']?['weekday_text'] ?? [],
            'isOpen': result['opening_hours']?['open_now'] ?? false,
            'photos': result['photos'] ?? [],
          });
        }
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
  }

  // Search for places
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    try {
      isSearching.value = true;
      
      // Use Text Search API
      final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=$query'
          '&location=${initialLat},${initialLng}'
          '&radius=50000'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          searchResults.value = List<Map<String, dynamic>>.from(
            data['results'].map((place) => {
              'name': place['name'],
              'address': place['formatted_address'],
              'lat': place['geometry']['location']['lat'],
              'lng': place['geometry']['location']['lng'],
              'place_id': place['place_id'],
              'rating': place['rating']?.toString() ?? 'N/A',
              'types': place['types'] ?? [],
            })
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search: $e');
    } finally {
      isSearching.value = false;
    }
  }

  // Search by category
  Future<void> searchByCategory(String category) async {
    try {
      isSearching.value = true;
      
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${cameraPosition.value.target.latitude},${cameraPosition.value.target.longitude}'
          '&radius=5000'
          '&type=${category.toLowerCase()}'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          // Clear existing markers
          markers.clear();
          
          // Add markers for each result
          for (var place in data['results']) {
            final lat = place['geometry']['location']['lat'];
            final lng = place['geometry']['location']['lng'];
            
            markers.add(Marker(
              markerId: MarkerId(place['place_id']),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: place['name'],
                snippet: place['vicinity'],
              ),
              onTap: () async {
                await getPlaceDetails(place['place_id']);
                showPlaceDetails.value = true;
              },
            ));
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search category: $e');
    } finally {
      isSearching.value = false;
    }
  }

  // Select a search result
  Future<void> selectSearchResult(Map<String, dynamic> result) async {
    final lat = result['lat'];
    final lng = result['lng'];
    
    await moveCamera(lat, lng);
    await onMapTap(LatLng(lat, lng));
    
    searchResults.clear();
  }

  // Animate camera to new position
  Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
    final newPos = CameraPosition(target: LatLng(lat, lng), zoom: zoom);
    cameraPosition.value = newPos;
    if (gMapController != null) {
      await gMapController!.animateCamera(CameraUpdate.newCameraPosition(newPos));
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
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

      Position position = await Geolocator.getCurrentPosition();
      await moveCamera(position.latitude, position.longitude);
      
      // Add marker at current location
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  // Helper method to get proper location name (not Plus Code)
  String _getLocationName(Placemark place) {
    // Try to get a meaningful name instead of Plus Code
    // Priority: street > subLocality > locality > administrativeArea
    if (place.street?.isNotEmpty ?? false) {
      // Check if it's not a Plus Code (Plus Codes contain '+')
      if (!place.street!.contains('+')) {
        return place.street!;
      }
    }
    if (place.subLocality?.isNotEmpty ?? false) {
      return place.subLocality!;
    }
    if (place.locality?.isNotEmpty ?? false) {
      return place.locality!;
    }
    if (place.administrativeArea?.isNotEmpty ?? false) {
      return place.administrativeArea!;
    }
    // If all else fails, use locality or a generic name
    return place.locality ?? 'Selected Location';
  }

  // Helper method to format address
  String _formatAddress(Placemark place) {
    List<String> parts = [];
    if (place.street?.isNotEmpty ?? false) parts.add(place.street!);
    if (place.subLocality?.isNotEmpty ?? false) parts.add(place.subLocality!);
    if (place.locality?.isNotEmpty ?? false) parts.add(place.locality!);
    if (place.administrativeArea?.isNotEmpty ?? false) parts.add(place.administrativeArea!);
    if (place.country?.isNotEmpty ?? false) parts.add(place.country!);
    return parts.join(', ');
  }

  // Get photo URL from photo reference
  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }

  // Search nearby places by type
  Future<void> searchNearbyPlaces(double lat, double lng, String type) async {
    try {
      isLoadingNearbyPlaces.value = true;
      nearbyPlaces.clear();

      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng'
          '&radius=5000'
          '&type=$type'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['results'] != null) {
          nearbyPlaces.value = List<Map<String, dynamic>>.from(
            data['results'].take(10).map((place) {
              final placeLat = place['geometry']['location']['lat'];
              final placeLng = place['geometry']['location']['lng'];
              final distance = _calculateDistance(lat, lng, placeLat, placeLng);
              
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
            })
          );
        }
      }
    } catch (e) {
      print('Error searching nearby places: $e');
      Get.snackbar('Error', 'Failed to load nearby places');
    } finally {
      isLoadingNearbyPlaces.value = false;
    }
  }

  // Calculate distance between two coordinates (in km)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
        cos(_degreesToRadians(lat2)) *
        (sin(dLon / 2) * sin(dLon / 2));
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Open in Google Maps
  Future<void> openInGoogleMaps(double lat, double lng) async {
    try {
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      // You can use url_launcher package here
      Get.snackbar('Info', 'Opening in Google Maps: $url');
    } catch (e) {
      Get.snackbar('Error', 'Failed to open Google Maps');
    }
  }

  // Save place
  void savePlace(Map<String, dynamic> placeData) {
    // This can be implemented with local storage or database
    Get.snackbar(
      'Saved',
      '${placeData['name']} has been saved to your favorites',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}