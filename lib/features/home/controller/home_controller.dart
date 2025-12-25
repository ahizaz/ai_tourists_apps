import 'dart:convert';
import 'package:ai_powered_tourists_app/core/config/api_keys.dart';
import 'package:ai_powered_tourists_app/core/localization/localization_service.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/home/model/nearby_place.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:ai_powered_tourists_app/features/map/screen/map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/play_ai_quize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ai_powered_tourists_app/core/services/place_voice_service.dart';
import 'package:ai_powered_tourists_app/core/services/system_volume.dart';
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
  var isNotificationRed = false.obs;
  void toggleNotificationColor() {
    isNotificationRed.value = !isNotificationRed.value;
  }

  // Update user name in-memory and persist to storage
  void setUserName(String name) {
    userName.value = name;
    Get.find<StorageService>().saveUserName(name);
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

  // Nearby places from API
  final nearbyPlaces = <NearbyPlace>[].obs;
  var isLoadingNearbyPlaces = false.obs;

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

    // Load saved user name from storage (if available)
    try {
      final storedName = Get.find<StorageService>().getUserName();
      if (storedName != null && storedName.isNotEmpty) {
        userName.value = storedName;
      }
    } catch (e) {
      debugPrint('Error loading stored user name: $e');
    }

    _loadSampleData();
    _setupAudioListeners();

    // Get current location when app starts (after first frame so UI is ready)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });

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
        // Prompt user to open device Location settings
        if (Get.isDialogOpen == false) {
          Get.defaultDialog(
            title: 'location_services_disabled'.tr,
            middleText: 'please_enable_location_services'.tr,
            onConfirm: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              // Give user a moment to enable then retry
              await Future.delayed(const Duration(seconds: 1));
              getCurrentLocation();
            },
            textConfirm: 'open_settings'.tr,
            onCancel: () {
              Get.back();
            },
            textCancel: 'cancel'.tr,
          );
        }

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
          // Show dialog offering retry or open app settings
          if (Get.isDialogOpen == false) {
            Get.defaultDialog(
              title: 'permission_denied'.tr,
              middleText: 'please_allow_location_access'.tr,
              onConfirm: () {
                Get.back();
                // Retry requesting permission
                getCurrentLocation();
              },
              textConfirm: 'retry'.tr,
              onCancel: () async {
                Get.back();
                await Geolocator.openAppSettings();
              },
              textCancel: 'open_settings'.tr,
            );
          }

          currentAddress.value = "Location permission denied";
          currentWeather.value = "N/A";
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        EasyLoading.dismiss();
        // Permission permanently denied — prompt user to open app settings
        if (Get.isDialogOpen == false) {
          Get.defaultDialog(
            title: 'permission_permanently_denied'.tr,
            middleText: 'open_app_settings_to_enable_location'.tr,
            onConfirm: () async {
              Get.back();
              await Geolocator.openAppSettings();
            },
            textConfirm: 'open_settings'.tr,
            onCancel: () {
              Get.back();
            },
            textCancel: 'cancel'.tr,
          );
        }

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

      // Debug print: Show actual device location coordinates
      debugPrint('========================================');
      debugPrint('📍 DEVICE CURRENT LOCATION:');
      debugPrint('Latitude: ${position.latitude}');
      debugPrint('Longitude: ${position.longitude}');
      debugPrint('Accuracy: ${position.accuracy} meters');
      debugPrint('========================================');

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

      // Send location to backend API
      EasyLoading.show(status: 'Sending location to server...');
      await sendLocationToBackend(position.latitude, position.longitude);

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

  // Get building name from Google Places API Nearby Search
  Future<String?> _getBuildingNameFromPlacesAPI(double lat, double lng) async {
    try {
      final apiKey = ApiKeys.googleMapsApiKey;
      // Use Nearby Search to find the exact place at these coordinates
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=50&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            (data['results'] as List).isNotEmpty) {
          // Get the first result (closest place)
          final firstResult = (data['results'] as List)[0];
          final placeName = firstResult['name'] as String?;
          final types = firstResult['types'] as List<dynamic>?;

          // Check if it's a building, establishment, or point of interest
          if (placeName != null && placeName.isNotEmpty && types != null) {
            // Prioritize buildings, establishments, and specific places
            bool isRelevantPlace = types.any(
              (type) => [
                'establishment',
                'point_of_interest',
                'premise',
                'building',
              ].contains(type),
            );

            if (isRelevantPlace) {
              debugPrint('🏢 Places API found: $placeName (types: $types)');
              return placeName;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error getting building name from Places API: $e');
    }
    return null;
  }

  // Extract building name from formatted address string
  String? _extractBuildingFromFormattedAddress(String formattedAddress) {
    try {
      // Common building name patterns
      final buildingPatterns = [
        RegExp(
          r'([A-Z][a-zA-Z\s]*\s*(?:Tower|Building|Plaza|Mall|Complex|Center|Centre|Towers))',
          caseSensitive: false,
        ),
        RegExp(r'(Aqua\s+Tower)', caseSensitive: false),
        RegExp(
          r'([A-Z][a-zA-Z\s]*\s*(?:Hotel|Apartment|Residence|Residency))',
          caseSensitive: false,
        ),
      ];

      for (var pattern in buildingPatterns) {
        final match = pattern.firstMatch(formattedAddress);
        if (match != null && match.group(1) != null) {
          String buildingName = match.group(1)!.trim();
          // Make sure it's not too long (likely not a building name)
          if (buildingName.length <= 50) {
            return buildingName;
          }
        }
      }

      // Also check if first part before comma looks like a building name
      final parts = formattedAddress.split(',');
      if (parts.isNotEmpty) {
        final firstPart = parts[0].trim();
        // Check if it contains building indicators
        if (firstPart.contains(
              RegExp(
                r'(Tower|Building|Plaza|Mall|Complex|Center|Centre)',
                caseSensitive: false,
              ),
            ) &&
            !firstPart.contains(
              RegExp(
                r'\d+\s+\w+\s+(?:Road|Street|Avenue|Lane)',
                caseSensitive: false,
              ),
            )) {
          return firstPart;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error extracting building from formatted address: $e');
    }
    return null;
  }

  // Extract building name from all geocoding results
  String? _extractBuildingFromAllResults(List<dynamic> results) {
    for (var result in results) {
      final addressComponents = result['address_components'] as List<dynamic>?;
      if (addressComponents != null) {
        for (var component in addressComponents) {
          final types = component['types'] as List<dynamic>?;
          final longName = component['long_name'] as String? ?? '';

          if (types != null &&
              types.contains('premise') &&
              longName.isNotEmpty) {
            return longName;
          }
        }
      }

      // Also check formatted_address for building names
      final formattedAddress = result['formatted_address'] as String?;
      if (formattedAddress != null) {
        // Look for common building indicators in formatted address
        final buildingPatterns = [
          'Tower',
          'Building',
          'Plaza',
          'Mall',
          'Complex',
          'Center',
          'Centre',
        ];

        for (var pattern in buildingPatterns) {
          if (formattedAddress.contains(pattern)) {
            // Try to extract building name (usually before the first comma or street)
            final parts = formattedAddress.split(',');
            for (var part in parts) {
              if (part.contains(pattern)) {
                return part.trim();
              }
            }
          }
        }
      }
    }
    return null;
  }

  // Convert coordinates to address using Google Geocoding API (English only)
  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      // Debug print coordinates being used
      debugPrint('🔍 Fetching address for coordinates: $lat, $lng');

      // Use Google Geocoding API with language=en to ensure English address
      final apiKey = ApiKeys.googleMapsApiKey;
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&language=en&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // First, try to get building name from Google Places API Nearby Search
          String? buildingName = await _getBuildingNameFromPlacesAPI(lat, lng);
          if (buildingName != null && buildingName.isNotEmpty) {
            debugPrint('🏢 Found building name from Places API: $buildingName');
          }

          // Parse address components to build a readable street address
          final result = data['results'][0];
          final addressComponents =
              result['address_components'] as List<dynamic>?;

          // Also check all results for building names
          String? buildingFromResults = _extractBuildingFromAllResults(
            data['results'] as List,
          );
          if (buildingFromResults != null && buildingFromResults.isNotEmpty) {
            buildingName = buildingName ?? buildingFromResults;
            debugPrint('🏢 Found building name from results: $buildingName');
          }

          // Debug: Print all address components
          debugPrint('📍 Address components received:');
          if (addressComponents != null) {
            for (var component in addressComponents) {
              debugPrint(
                '  - ${component['long_name']} (${component['types']})',
              );
            }
          }

          if (addressComponents != null && addressComponents.isNotEmpty) {
            // Extract address components - prioritize specific locations
            String streetNumber = '';
            String route = '';
            String premise =
                buildingName ?? ''; // Use building name from Places API first
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
                if (types.contains('premise') && premise.isEmpty) {
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

            // PRIORITY 1: Building/Premise (very specific - like "Aqua Tower", "Mohakhali Aqua Tower")
            // Show building name FIRST if available, as it's the most specific location
            if (premise.isNotEmpty) {
              addressParts.add(premise);
            }

            // PRIORITY 2: Point of Interest (landmarks, specific places)
            if (pointOfInterest.isNotEmpty && pointOfInterest != premise) {
              addressParts.add(pointOfInterest);
            }

            // PRIORITY 3: Street address (specific street location)
            if (streetNumber.isNotEmpty && route.isNotEmpty) {
              addressParts.add('$streetNumber $route');
            } else if (route.isNotEmpty) {
              addressParts.add(route);
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
              if (sublocalityLevel2.isEmpty &&
                  sublocalityLevel1.isEmpty &&
                  sublocality.isEmpty &&
                  neighborhood.isEmpty) {
                addressParts.add(locality);
              } else if (locality.toLowerCase() !=
                      sublocalityLevel2.toLowerCase() &&
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
                debugPrint('✅ Using parsed address: $readableAddress');
                return;
              }
            }

            // Try to extract building name from formatted_address if we still don't have one
            if (premise.isEmpty) {
              final formattedAddress = result['formatted_address'] as String?;
              if (formattedAddress != null && formattedAddress.isNotEmpty) {
                // Look for building names in formatted address (before first comma usually)
                final buildingFromFormatted =
                    _extractBuildingFromFormattedAddress(formattedAddress);
                if (buildingFromFormatted != null &&
                    buildingFromFormatted.isNotEmpty) {
                  premise = buildingFromFormatted;
                  // Rebuild address with building name
                  addressParts.clear();
                  addressParts.add(premise);
                  if (pointOfInterest.isNotEmpty &&
                      pointOfInterest != premise) {
                    addressParts.add(pointOfInterest);
                  }
                  if (streetNumber.isNotEmpty && route.isNotEmpty) {
                    addressParts.add('$streetNumber $route');
                  } else if (route.isNotEmpty) {
                    addressParts.add(route);
                  }
                  if (sublocalityLevel2.isNotEmpty) {
                    addressParts.add(sublocalityLevel2);
                  } else if (sublocalityLevel1.isNotEmpty) {
                    addressParts.add(sublocalityLevel1);
                  } else if (sublocality.isNotEmpty) {
                    addressParts.add(sublocality);
                  } else if (neighborhood.isNotEmpty) {
                    addressParts.add(neighborhood);
                  }
                  if (locality.isNotEmpty) {
                    if (sublocalityLevel2.isEmpty &&
                        sublocalityLevel1.isEmpty &&
                        sublocality.isEmpty &&
                        neighborhood.isEmpty) {
                      addressParts.add(locality);
                    } else if (locality.toLowerCase() !=
                            sublocalityLevel2.toLowerCase() &&
                        locality.toLowerCase() !=
                            sublocalityLevel1.toLowerCase() &&
                        locality.toLowerCase() != sublocality.toLowerCase() &&
                        locality.toLowerCase() != neighborhood.toLowerCase()) {
                      addressParts.add(locality);
                    }
                  }

                  if (addressParts.isNotEmpty) {
                    final readableAddress = addressParts.join(', ');
                    if (!readableAddress.contains(
                      RegExp(r'[A-Z0-9]+\+[A-Z0-9]+'),
                    )) {
                      currentAddress.value = readableAddress;
                      debugPrint(
                        '✅ Using address with extracted building: $readableAddress',
                      );
                      return;
                    }
                  }
                }
              }
            }

            // Fallback: Use formatted_address if it's not a Plus Code
            final formattedAddress = result['formatted_address'] as String?;
            if (formattedAddress != null &&
                formattedAddress.isNotEmpty &&
                !formattedAddress.contains(RegExp(r'[A-Z0-9]+\+[A-Z0-9]+'))) {
              currentAddress.value = formattedAddress;
              debugPrint('✅ Using formatted address: $formattedAddress');
              return;
            }
          }
        }
      }

      // Fallback to geocoding package if API fails (may show in device locale)
      debugPrint('⚠️ Google API failed, using geocoding package fallback');
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
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
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
          debugPrint(
            '✅ Using geocoding package address: ${currentAddress.value}',
          );
        } else {
          // Last resort: show coordinates
          currentAddress.value =
              "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
          debugPrint('⚠️ Using coordinates as address');
        }
      } else {
        currentAddress.value =
            "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
        debugPrint('⚠️ No placemarks found, using coordinates');
      }
    } catch (e) {
      debugPrint('❌ Error getting address: $e');
      currentAddress.value =
          "Near ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
      debugPrint('📍 Final address set to: ${currentAddress.value}');
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
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m&temperature_unit=celsius',
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

  // Send location to backend API and fetch nearby places
  Future<void> sendLocationToBackend(double lat, double lng) async {
    try {
      // Get access token from storage
      final token = Get.find<StorageService>().getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('❌ No access token found');
        EasyLoading.showError('Authentication required');
        return;
      }

      isLoadingNearbyPlaces.value = true;

      debugPrint('========================================');
      debugPrint('📤 SENDING LOCATION TO BACKEND:');
      debugPrint('API URL: ${Url.shownNearby}');
      debugPrint('Latitude: $lat');
      debugPrint('Longitude: $lng');
      debugPrint('Token: Bearer $token');
      debugPrint('========================================');

      final response = await http.post(
        Uri.parse(Url.shownNearby),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'latitude': lat,
          'longitude': lng,
          // 'radius': 5000, // Optional
        }),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Location sent successfully');
        final data = jsonDecode(response.body);

        // Parse nearby places response
        try {
          final nearbyResponse = NearbyPlacesResponse.fromJson(data);
          nearbyPlaces.value = nearbyResponse.data;

          debugPrint('✅ Found ${nearbyPlaces.length} nearby places');
          for (var place in nearbyPlaces) {
            debugPrint('  - ${place.placeName} (${place.placeRating} ⭐)');
          }
        } catch (e) {
          debugPrint('❌ Error parsing nearby places: $e');
        }
      } else {
        debugPrint('❌ Failed to send location: ${response.statusCode}');
        debugPrint('Error: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error sending location to backend: $e');
    } finally {
      isLoadingNearbyPlaces.value = false;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    if (_mapController != null &&
        currentLat.value != 0.0 &&
        currentLng.value != 0.0) {
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
          CameraPosition(target: LatLng(initialLat, initialLng), zoom: 14.0),
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
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
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
          CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
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

  Future<void> startAITouristGuide({required Place place}) async {
    isAIGuideStarted.value = true;

    try {
      // Use current resolved address if available, otherwise fallback to place title
      final resolved = (currentAddress.value.isNotEmpty && currentAddress.value != 'Loading location...')
          ? currentAddress.value
          : place.title;

      debugPrint('Starting AI guide for selected place: ${place.title} (resolved: $resolved)');

      // Fetch audio URL from service (does not play)
      final audioUrl = await PlaceVoiceService.fetchAudioUrl(
        resolvedPlace: resolved,
        selectedPlace: place.title,
      );

      if (audioUrl == null) {
        debugPrint('No audio URL returned from service');
        isAIGuideStarted.value = false;
        return;
      }

      // Try to raise device media volume to maximum (Android)
      try {
        final ok = await SystemVolume.setMaxVolume();
        debugPrint('SystemVolume.setMaxVolume returned: $ok');
      } catch (e) {
        debugPrint('SystemVolume.setMaxVolume exception: $e');
      }

      // Set URL on controller's audio player so UI/listeners stay in sync
      await _audioPlayer.setUrl(audioUrl);
      // Ensure maximum player volume (0.0 - 1.0)
      try {
        await _audioPlayer.setVolume(1.0);
        debugPrint('HomeController: set audio player volume to 1.0');
      } catch (e) {
        debugPrint('HomeController: setVolume failed: $e');
      }
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error starting AI guide: $e');
      EasyLoading.showError('Unable to start AI guide');
      isAIGuideStarted.value = false;
    }
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
