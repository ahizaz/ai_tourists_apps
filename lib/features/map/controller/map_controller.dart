import 'dart:convert';
import 'dart:math';
import 'package:ai_powered_tourists_app/core/config/api_keys.dart';
import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapController extends GetxController {
  // API Key - Using centralized configuration
  final String apiKey = ApiKeys.googleMapsApiKey;
  
  // Static coordinates (example: Kuala Lumpur, Malaysia)
  final double initialLat = 3.139003;
  final double initialLng = 101.686855;

  // Observable camera position
  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(3.139003, 101.686855),
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

  // User's current location
  final RxDouble userLat = 0.0.obs;
  final RxDouble userLng = 0.0.obs;
  final RxBool hasUserLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Check if HomeController already has location, use that instead of defaulting to Malaysia
    try {
      final homeController = Get.find<HomeController>();
      if (homeController.currentLat.value != 0.0 && homeController.currentLng.value != 0.0) {
        // Use location from HomeController
        userLat.value = homeController.currentLat.value;
        userLng.value = homeController.currentLng.value;
        hasUserLocation.value = true;
        cameraPosition.value = CameraPosition(
          target: LatLng(userLat.value, userLng.value),
          zoom: 16.0,
        );
        return;
      }
    } catch (e) {
      // HomeController not found, continue to get location
      debugPrint('HomeController not found, getting location: $e');
    }
    
    // Automatically get user's location on init
    getUserLocation();
  }

  // Called when the GoogleMap is created
  void onMapCreated(GoogleMapController controller) {
    gMapController = controller;
  }

  // Handle map tap - get place details
  Future<void> onMapTap(LatLng position) async {
    try {
      // Debug: Print clicked location coordinates
      print('========================================');
      print('📍 CLICKED LOCATION:');
      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
      print('========================================');
      
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
      await moveCamera(position.latitude, position.longitude, zoom: 16);

      // First, try to get nearby places from Google Places API
      final placeId = await getNearbyPlaceDetails(position.latitude, position.longitude);
      
      if (placeId != null) {
        // If we found a place_id, get full details
        await getPlaceDetails(placeId);
      } else {
        // Fallback to reverse geocoding if no nearby place found
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final locationName = _getLocationName(place);
          
          // Set basic details from geocoding
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
            'rating': 'N/A',
            'phone': 'N/A',
            'photos': [],
          };
        }
      }
      
      // Update marker with final place info
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('selected_location'),
        position: position,
        infoWindow: InfoWindow(
          title: selectedPlaceDetails['name'] ?? 'Selected Location',
          snippet: selectedPlaceDetails['fullAddress'] ?? '',
        ),
        onTap: () {
          showPlaceDetails.value = true;
        },
      ));

      // Load nearby places (default: hotels)
      await searchNearbyPlaces(
        position.latitude,
        position.longitude,
        selectedNearbyCategory.value,
      );

      showPlaceDetails.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location details: $e');
    } finally {
      isLoadingPlaceDetails.value = false;
    }
  }

  // Get nearby place details from Google Places API
  Future<String?> getNearbyPlaceDetails(double lat, double lng) async {
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
          
          // Return the place_id if found
          if (place['place_id'] != null) {
            return place['place_id'];
          }
        }
      }
    } catch (e) {
      print('Error getting nearby places: $e');
    }
    return null;
  }

  // Get detailed place information
  Future<void> getPlaceDetails(String placeId) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=name,formatted_address,formatted_phone_number,rating,opening_hours,website,types,geometry,photos,reviews,price_level,url'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] != null) {
          final result = data['result'];
          final geometry = result['geometry'];
          
          // Get all photos, not just first few
          List<dynamic> allPhotos = [];
          if (result['photos'] != null) {
            allPhotos = List<dynamic>.from(result['photos']);
          }
          
          // Update selected place details with all information
          selectedPlaceDetails.value = {
            'name': result['name'] ?? 'Unknown Location',
            'fullAddress': result['formatted_address'] ?? 'Address not available',
            'phone': result['formatted_phone_number'] ?? 'N/A',
            'rating': result['rating'] ?? 'N/A',
            'website': result['website'] ?? 'N/A',
            'types': result['types'] ?? [],
            'openingHours': result['opening_hours']?['weekday_text'] ?? [],
            'isOpen': result['opening_hours']?['open_now'] ?? false,
            'photos': allPhotos, // Store all photos
            'reviews': result['reviews'] ?? [],
            'priceLevel': result['price_level'] ?? 'N/A',
            'latitude': geometry?['location']?['lat'] ?? selectedPlaceDetails['latitude'],
            'longitude': geometry?['location']?['lng'] ?? selectedPlaceDetails['longitude'],
            'place_id': placeId,
            'url': result['url'] ?? '', // Google Maps URL
          };
          
          print('Loaded ${allPhotos.length} photos for ${result['name']}');
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
            final placeId = place['place_id'];
            
            markers.add(Marker(
              markerId: MarkerId(placeId),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: place['name'],
                snippet: place['vicinity'],
              ),
              onTap: () async {
                // Move camera to marker position
                await moveCamera(lat, lng, zoom: 16);
                // Get full place details
                await getPlaceDetails(placeId);
                showPlaceDetails.value = true;
              },
            ));
          }
          
          // Show snackbar with results count
          if (data['results'].length > 0) {
            Get.snackbar(
              'Results',
              'Found ${data['results'].length} ${category.toLowerCase()}s nearby',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
            );
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
    final placeId = result['place_id'];
    
    // Move camera to location
    await moveCamera(lat, lng, zoom: 16);
    
    // Clear existing markers and add new one
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(placeId),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: result['name'],
        snippet: result['address'],
      ),
      onTap: () {
        showPlaceDetails.value = true;
      },
    ));
    
    // Get full place details
    await getPlaceDetails(placeId);
    
    // Show place details
    showPlaceDetails.value = true;
    
    // Clear search results
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

  // Get user's current location (simplified version to just get lat/lng)
  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Update observable variables
      userLat.value = position.latitude;
      userLng.value = position.longitude;
      hasUserLocation.value = true;
      
      print('User location: ${position.latitude}, ${position.longitude}');
      
    } catch (e) {
      print('Failed to get user location: $e');
      hasUserLocation.value = false;
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

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permission permanently denied. Please enable in settings.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Update observable variables
      userLat.value = position.latitude;
      userLng.value = position.longitude;
      hasUserLocation.value = true;
      
      // Move camera to current location
      await moveCamera(position.latitude, position.longitude, zoom: 16);
      
      // Try to get nearby place details
      final placeId = await getNearbyPlaceDetails(position.latitude, position.longitude);
      
      if (placeId != null) {
        // Get full place details
        await getPlaceDetails(placeId);
        
        // Add marker with place details
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: selectedPlaceDetails['name'] ?? 'Current Location',
            snippet: selectedPlaceDetails['fullAddress'] ?? '',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            showPlaceDetails.value = true;
          },
        ));
      } else {
        // Fallback to simple marker
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  // Helper method to get proper location name (not Plus Code)
  String _getLocationName(Placemark place) {
    // Try to get a meaningful location name
    // Priority: subLocality > locality > administrativeArea > street
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
      // Check if it's not a Plus Code (Plus Codes contain '+')
      if (!place.street!.contains('+')) {
        return place.street!;
      }
    }
    // If all else fails, use a generic name
    return 'Selected Location';
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
  String getPhotoUrl(String photoReference, {int maxWidth = 800}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }
  
  // Get multiple photo URLs
  List<String> getPhotoUrls(List<dynamic> photos, {int maxCount = 5, int maxWidth = 800}) {
    List<String> urls = [];
    final count = photos.length > maxCount ? maxCount : photos.length;
    
    for (int i = 0; i < count; i++) {
      if (photos[i]['photo_reference'] != null) {
        urls.add(getPhotoUrl(photos[i]['photo_reference'], maxWidth: maxWidth));
      }
    }
    
    return urls;
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
      // Try to open in Google Maps app first (works on Android/iOS)
      final googleMapsUrl = Uri.parse('google.navigation:q=$lat,$lng');
      final googleMapsWebUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      
      // Try Google Maps app URL first
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(googleMapsWebUrl)) {
        // Fallback to web URL
        await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open Google Maps',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error opening Google Maps: $e');
      Get.snackbar(
        'Error',
        'Failed to open Google Maps',
        snackPosition: SnackPosition.BOTTOM,
      );
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