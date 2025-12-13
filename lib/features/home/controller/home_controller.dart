import 'dart:convert';
import 'package:ai_powered_tourists_app/core/config/api_keys.dart';
import 'package:ai_powered_tourists_app/core/localization/localization_service.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:ai_powered_tourists_app/features/map/screen/map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/play_ai_quize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  // Basic profile & location info
  var userName = "Jak Nos".obs;
  var currentAddress = "Loading location...".obs;
  var currentWeather = "Loading...".obs;
  
  // Current location coordinates
  var currentLat = 0.0.obs;
  var currentLng = 0.0.obs;
  var isLoadingLocation = true.obs;

  // UI state
  var selectedCategory = 'historical'.obs;
  var isNotificationRed =false.obs;
  void toggleNotificationColor(){
    isNotificationRed.value = !isNotificationRed.value;
  }

  // AI Tourist Guide state
  var showAIGuideSheet = false.obs;
  var isAIGuideStarted = false.obs;
  var isAudioPlaying = false.obs;
  var audioPosition = Duration.zero.obs;
  var audioDuration = Duration.zero.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Dynamic list of places
  final places = <Place>[].obs;

  // Map related properties
  GoogleMapController? _mapController;
  final mapMarkers = <Marker>[].obs;
  
  // Default location (Rome, Italy - matching the image)
  final double initialLat = 41.8902;
  final double initialLng = 12.4922;
  
  var mapCameraPosition = const CameraPosition(
    target: LatLng(41.8902, 12.4922),
    zoom: 14.0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
    _setupAudioListeners();
    
    // Get current location when app starts
    getCurrentLocation();
    
    // Listen to locale changes and reload data
    ever(Get.find<LocalizationService>().currentLocale, (_) {
      reloadPlacesData();
    });
  }
  
  // Get current location
  Future<void> getCurrentLocation({bool showLoading = true}) async {
    try {
      isLoadingLocation.value = true;
      
      // Always show loading when getting location
      EasyLoading.show(status: 'Getting your location...');
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        EasyLoading.dismiss();
        EasyLoading.showError('Location services disabled');
        currentAddress.value = "Location services disabled";
        currentWeather.value = "N/A";
        isLoadingLocation.value = false;
        return;
      }

      // Check location permission
      EasyLoading.show(status: 'Checking permissions...');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          EasyLoading.dismiss();
          EasyLoading.showError('Location permission denied');
          currentAddress.value = "Location permission denied";
          currentWeather.value = "N/A";
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        EasyLoading.dismiss();
        EasyLoading.showError('Location permission permanently denied');
        currentAddress.value = "Location permission permanently denied";
        currentWeather.value = "N/A";
        isLoadingLocation.value = false;
        return;
      }

      // Get current position
      EasyLoading.show(status: 'Fetching location...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Update coordinates
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      
      // Update map camera position
      mapCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );
      
      // Convert coordinates to address
      EasyLoading.show(status: 'Getting address...');
      await getAddressFromCoordinates(position.latitude, position.longitude);
      
      // Get weather for current location
      EasyLoading.show(status: 'Fetching weather...');
      await getWeatherForLocation(position.latitude, position.longitude);
      
      // Success
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Location updated');
      
      isLoadingLocation.value = false;
    } catch (e) {
      debugPrint('Error getting location: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Unable to get location');
      currentAddress.value = "Unable to get location";
      currentWeather.value = "N/A";
      isLoadingLocation.value = false;
    }
  }
  
  // Convert coordinates to address using Google Geocoding API (English only)
  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      // Use Google Geocoding API with language=en to ensure English address
      final apiKey = ApiKeys.googleMapsApiKey;
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&language=en&key=$apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Parse address components to build a readable street address
          final result = data['results'][0];
          final addressComponents = result['address_components'] as List<dynamic>?;
          
          if (addressComponents != null && addressComponents.isNotEmpty) {
            // Extract address components - prioritize specific locations
            String streetNumber = '';
            String route = '';
            String premise = ''; // Building name like "Agora Tower"
            String pointOfInterest = ''; // POI like landmarks
            String sublocality = '';
            String sublocalityLevel1 = '';
            String sublocalityLevel2 = '';
            String neighborhood = '';
            String locality = '';
            
            for (var component in addressComponents) {
              final types = component['types'] as List<dynamic>?;
              final longName = component['long_name'] as String? ?? '';
              
              if (types != null) {
                if (types.contains('premise')) {
                  premise = longName; // Building name
                } else if (types.contains('point_of_interest')) {
                  pointOfInterest = longName; // Landmarks
                } else if (types.contains('street_number')) {
                  streetNumber = longName;
                } else if (types.contains('route')) {
                  route = longName;
                } else if (types.contains('sublocality_level_2')) {
                  sublocalityLevel2 = longName;
                } else if (types.contains('sublocality_level_1')) {
                  sublocalityLevel1 = longName;
                } else if (types.contains('sublocality')) {
                  sublocality = longName;
                } else if (types.contains('neighborhood')) {
                  neighborhood = longName;
                } else if (types.contains('locality')) {
                  locality = longName;
                }
              }
            }
            
            // Build readable address with priority for specific locations
            List<String> addressParts = [];
            
            // Street address (most specific)
            if (streetNumber.isNotEmpty && route.isNotEmpty) {
              addressParts.add('$streetNumber $route');
            } else if (route.isNotEmpty) {
              addressParts.add(route);
            }
            
            // Building/Premise (very specific - like "Agora Tower")
            if (premise.isNotEmpty) {
              addressParts.add(premise);
            }
            
            // Point of Interest
            if (pointOfInterest.isNotEmpty && pointOfInterest != premise) {
              addressParts.add(pointOfInterest);
            }
            
            // Area/Neighborhood (specific area like "Mohakhali")
            // Priority: sublocality_level_2 > sublocality_level_1 > sublocality > neighborhood
            if (sublocalityLevel2.isNotEmpty) {
              addressParts.add(sublocalityLevel2);
            } else if (sublocalityLevel1.isNotEmpty) {
              addressParts.add(sublocalityLevel1);
            } else if (sublocality.isNotEmpty) {
              addressParts.add(sublocality);
            } else if (neighborhood.isNotEmpty) {
              addressParts.add(neighborhood);
            }
            
            // City (show only if we don't have more specific info, or if it's different from sublocality)
            if (locality.isNotEmpty) {
              // Only add city if sublocality is different or we don't have sublocality
              if (sublocalityLevel2.isEmpty && sublocalityLevel1.isEmpty && 
                  sublocality.isEmpty && neighborhood.isEmpty) {
                addressParts.add(locality);
              } else if (locality.toLowerCase() != sublocalityLevel2.toLowerCase() &&
                         locality.toLowerCase() != sublocalityLevel1.toLowerCase() &&
                         locality.toLowerCase() != sublocality.toLowerCase() &&
                         locality.toLowerCase() != neighborhood.toLowerCase()) {
                addressParts.add(locality);
              }
            }
            
            // State/Province (only if we have specific location, otherwise it's redundant)
            // Skip administrative area if we already have city/sublocality
            // Country (only add if different country or if address is very short)
            
            // Only use formatted address if we don't have street info and it's not a Plus Code
            if (addressParts.isNotEmpty) {
              final readableAddress = addressParts.join(', ');
              // Check if it contains Plus Code pattern (contains + and numbers/letters)
              if (!readableAddress.contains(RegExp(r'[A-Z0-9]+\+[A-Z0-9]+'))) {
                currentAddress.value = readableAddress;
                return;
              }
            }
            
            // Fallback: Use formatted_address if it's not a Plus Code
            final formattedAddress = result['formatted_address'] as String?;
            if (formattedAddress != null && 
                formattedAddress.isNotEmpty && 
                !formattedAddress.contains(RegExp(r'[A-Z0-9]+\+[A-Z0-9]+'))) {
              currentAddress.value = formattedAddress;
              return;
            }
          }
        }
      }
      
      // Fallback to geocoding package if API fails (may show in device locale)
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        // Format address, avoiding Plus Codes
        List<String> addressParts = [];
        
        // Check if street is not a Plus Code
        if (place.street != null && 
            place.street!.isNotEmpty && 
            !place.street!.contains(RegExp(r'[A-Z0-9]+\+[A-Z0-9]+'))) {
          addressParts.add(place.street!);
        }
        
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }
        
        if (addressParts.isNotEmpty) {
          currentAddress.value = addressParts.join(', ');
        } else {
          // Last resort: show coordinates
          currentAddress.value = "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
        }
      } else {
        currentAddress.value = "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      currentAddress.value = "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
    }
  }
  
  // Get weather for location using wttr.in API (free, no API key needed)
  Future<void> getWeatherForLocation(double lat, double lng) async {
    try {
      // Use wttr.in API with coordinates to get real weather data
      // Format: https://wttr.in/{lat},{lng}?format=j1
      final url = Uri.parse('https://wttr.in/$lat,$lng?format=j1');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'Mozilla/5.0'}, // Some APIs require user agent
      );
      
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          // wttr.in returns temperature in current_condition array
          final temp = data['current_condition']?[0]?['temp_C'];
          if (temp != null && temp.toString().isNotEmpty) {
            currentWeather.value = "${temp}°C";
            return;
          }
        } catch (e) {
          debugPrint('Error parsing weather response: $e');
        }
      }
      
      // Fallback: Try alternative weather API (Open-Meteo - free, no key needed)
      try {
        final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m&temperature_unit=celsius'
        );
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final temp = data['current']?['temperature_2m'];
          if (temp != null) {
            currentWeather.value = "${temp.toStringAsFixed(0)}°C";
            return;
          }
        }
      } catch (e) {
        debugPrint('Open-Meteo API error: $e');
      }
      
      // Final fallback: Use location-based estimation
      double estimatedTemp = 25.0; // Default
      if (lat > 60) {
        estimatedTemp = 5.0; // Cold regions
      } else if (lat > 40) {
        estimatedTemp = 15.0; // Temperate
      } else if (lat > 20) {
        estimatedTemp = 25.0; // Warm
      } else if (lat > -20) {
        estimatedTemp = 28.0; // Tropical
      } else {
        estimatedTemp = 10.0; // Southern regions
      }
      
      currentWeather.value = "${estimatedTemp.toStringAsFixed(0)}°C";
      
    } catch (e) {
      debugPrint('Error getting weather: $e');
      currentWeather.value = "N/A";
    }
  }
  
  // Reload places data when language changes
  void reloadPlacesData() {
    _loadSampleData();
  }

  void _setupAudioListeners() {
    _audioPlayer.positionStream.listen((position) {
      audioPosition.value = position;
    });

    _audioPlayer.durationStream.listen((duration) {
      audioDuration.value = duration ?? Duration.zero;
    });

    _audioPlayer.playerStateStream.listen((state) {
      isAudioPlaying.value = state.playing;
      
      // Auto close when audio completes
      if (state.processingState == ProcessingState.completed) {
        isAudioPlaying.value = false;
        audioPosition.value = Duration.zero;
        
        // Suggest quiz after visit completion
        _suggestQuizAfterVisit();
      }
    });
  }
  
  // Method to suggest quiz when visit is finished
  void _suggestQuizAfterVisit() {
    // Small delay to allow audio to fully stop
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.isDialogOpen == false) {
        _showQuizSuggestionDialog();
      }
    });
  }
  
  void _showQuizSuggestionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xffFF6B35).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz_outlined,
                  size: 40,
                  color: Color(0xffFF6B35),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                'visit_complete'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff252525),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Message
              Text(
                'quiz_suggestion_message'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff878787),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Start Quiz Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    closeAIGuideSheet(); // Close the bottom sheet
                    // Navigate to quiz - Import needed at top of file
                    Get.to(() => const PlayAiQuize());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'start_quiz'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Maybe Later Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffFF6B35), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'maybe_later'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFF6B35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _loadSampleData() {
    // Sample data — replace with real API data later
    places.assignAll([
      Place(
        id: 'gwc',
        title: 'great_wall_china'.tr,
        description: 'great_wall_desc'.tr,
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSxFPo2KM3TStgMefLyEKBR0vlVgPBmxqk0pLS59-sJXBcmW3xH7567GcvcE4ejvayAbYzJwISv_DLj-IRWjMp_fSl5jpG6_hL8H7d-vMMLHYP-dgdpljyhorPpkHgJnZQ40X7am=w270-h312-n-k-no',
        rating: 4.3,
        distanceKm: 2.5,
        category: 'historical'.tr,
      ),
      Place(
        id: 'museum1',
        title: 'national_museum'.tr,
        description: 'national_museum_desc'.tr,
        imageUrl:
            'https://images.unsplash.com/photo-1554907984-15263bfd63bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
        rating: 4.0,
        distanceKm: 1.2,
        category: 'museum'.tr,
      ),
      Place(
        id: 'tour1',
        title: 'city_park'.tr,
        description: 'city_park_desc'.tr,
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSzm7wFydyGdrpZB_1p2eYstikmI5NsQfXyZLfEbhRcOoGJ-eAHrsaCZTxtPNoRaJ4IPzj1anKiRs61q_nBnMFD5aj1Ohc6He_uKUkkRio-udSEMWzbTNciCdF_MNucfvIX7MM5p=s680-w680-h510-rw',
        rating: 4.1,
        distanceKm: 0.9,
        category: 'tourism'.tr,
      ),
      // duplicate to show list scrolling
      Place(
        id: 'gwc2',
        title: 'great_wall_scenic'.tr,
        description: 'great_wall_scenic_desc'.tr,
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        rating: 4.5,
        distanceKm: 3.1,
        category: 'historical'.tr,
      ),
    ]);
  }

  List<Place> filteredPlaces() {
    final cat = selectedCategory.value;
    if (cat == 'all') return places;
    
    // Get the translated category value for comparison
    final translatedCategory = cat.tr;
    return places.where((p) => p.category == translatedCategory).toList();
  }

  void selectCategory(String cat) => selectedCategory.value = cat;

  // Map methods
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _addInitialMarkers();
  }

  void _addInitialMarkers() {
    // Add some sample markers
    mapMarkers.add(
      Marker(
        markerId: const MarkerId('colosseum'),
        position: const LatLng(41.8902, 12.4922),
        infoWindow: const InfoWindow(title: 'Colosseum'),
      ),
    );
    
    // Add marker for Ashok Nagar (from the image)
    mapMarkers.add(
      Marker(
        markerId: const MarkerId('ashok_nagar'),
        position: const LatLng(41.8852, 12.4850),
        infoWindow: const InfoWindow(title: 'Ashok Nagar'),
      ),
    );
  }

  void moveToCurrentLocation() {
    if (_mapController != null && currentLat.value != 0.0 && currentLng.value != 0.0) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLat.value, currentLng.value),
            zoom: 14.0,
          ),
        ),
      );
    } else if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(initialLat, initialLng),
            zoom: 14.0,
          ),
        ),
      );
    }
  }
  
  // Navigate to map screen with current location
  void navigateToMapWithCurrentLocation() async {
    if (currentLat.value != 0.0 && currentLng.value != 0.0) {
      try {
        // Get or create MapController BEFORE navigation
        MapController mapController;
        if (Get.isRegistered<MapController>()) {
          mapController = Get.find<MapController>();
        } else {
          // Create and register it so it's available when screen loads
          mapController = Get.put(MapController());
        }
        
        // Set the location BEFORE navigating so map initializes with correct location
        mapController.userLat.value = currentLat.value;
        mapController.userLng.value = currentLng.value;
        mapController.hasUserLocation.value = true;
        mapController.cameraPosition.value = CameraPosition(
          target: LatLng(currentLat.value, currentLng.value),
          zoom: 16.0,
        );
        
        // Navigate to map screen
        Get.to(() => const MapScreen());
        
        // Wait for map to initialize and then update
        await Future.delayed(const Duration(milliseconds: 1200));
        
        try {
          // Update camera position again after map loads
          if (mapController.gMapController != null) {
            await mapController.gMapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(currentLat.value, currentLng.value),
                  zoom: 16.0,
                ),
              ),
            );
          }
          
          // Clear existing markers and add current location marker
          mapController.markers.clear();
          mapController.markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(currentLat.value, currentLng.value),
              infoWindow: InfoWindow(
                title: 'Current Location',
                snippet: currentAddress.value,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          );
        } catch (e) {
          debugPrint('Error updating map after load: $e');
        }
      } catch (e) {
        debugPrint('Error in navigateToMapWithCurrentLocation: $e');
        // Navigate anyway, map will try to get location itself
        Get.to(() => const MapScreen());
      }
    } else {
      // If location not available, get it first
      EasyLoading.show(status: 'Getting location...');
      await getCurrentLocation(showLoading: false);
      EasyLoading.dismiss();
      
      if (currentLat.value != 0.0 && currentLng.value != 0.0) {
        navigateToMapWithCurrentLocation();
      } else {
        EasyLoading.showError('Unable to get location');
      }
    }
  }

  void moveToPlace(double lat, double lng) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  // AI Tourist Guide Methods
  void openAIGuideSheet() {
    showAIGuideSheet.value = true;
    isAIGuideStarted.value = false;
  }

  void closeAIGuideSheet() {
    showAIGuideSheet.value = false;
    isAIGuideStarted.value = false;
    stopAudio();
  }

  void startAITouristGuide() {
    isAIGuideStarted.value = true;
    // In future, this will trigger AI to generate audio
    // For now, we'll use a placeholder audio URL or local asset
    playDemoAudio();
  }

  Future<void> playDemoAudio() async {
    try {
      // For demo purpose - in future, replace with AI-generated audio
      // Using a sample audio URL for demonstration
      await _audioPlayer.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      );
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void toggleAudioPlayback() {
    if (isAudioPlaying.value) {
      pauseAudio();
    } else {
      resumeAudio();
    }
  }

  void pauseAudio() {
    _audioPlayer.pause();
  }

  void resumeAudio() {
    _audioPlayer.play();
  }

  void stopAudio() {
    _audioPlayer.stop();
    audioPosition.value = Duration.zero;
  }

  void seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _mapController?.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}