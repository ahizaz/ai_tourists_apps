import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:http/http.dart' as http;

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null);
  var userName = "Brooklyn Simmons".obs;
  var userEmail = "brooklyn.sim@example.com".obs;
  var phoneNumber = "+880 10-46-828200".obs;
  var selectedPlan = RxnString();

  // AI Assistant options
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxList<String> voiceTypes = <String>[].obs;
  final int maxVoiceTypesSelections = 3;

  // Quiz options
  var selectedQuantity = RxnInt();
  var selectedSubject = RxnString();

  // Computed property to check if quiz can start
  bool get canStartQuiz =>
      selectedQuantity.value != null && selectedSubject.value != null;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  void selectSubscriptionPlan(String plan) {
    if (selectedPlan.value == plan) {
      selectedPlan.value = null; // Unselect if same plan clicked again
    } else {
      selectedPlan.value = plan;
    }
  }

  void subscribeNow() {
    if (selectedPlan.value != null) {}
  }

  // AI Assistant methods
  void selectGender(String? g) {
    gender.value = g;
  }

  void selectVoice(String? v) {
    voice.value = v;
  }

  bool toggleVoiceType(String t) {
    if (voiceTypes.contains(t)) {
      voiceTypes.remove(t);
      return true;
    }
    if (voiceTypes.length < maxVoiceTypesSelections) {
      voiceTypes.add(t);
      return true;
    }
    return false;
  }

  void resetAiAssistant() {
    gender.value = null;
    voice.value = null;
    voiceTypes.clear();
  }

  // Quiz selection methods
  void selectQuantity(int quantity) {
    if (selectedQuantity.value == quantity) {
      selectedQuantity.value = null; // Unselect if same quantity clicked again
    } else {
      selectedQuantity.value = quantity;
    }
  }

  void selectSubject(String subject) {
    if (selectedSubject.value == subject) {
      selectedSubject.value = null; // Unselect if same subject clicked again
    } else {
      selectedSubject.value = subject;
    }
  }

  void resetQuizOptions() {
    selectedQuantity.value = null;
    selectedSubject.value = null;
  }

  // Q&A List functionality
  var qaAnswers =
      <int, String>{}.obs; // Map of question index to selected answer

  final List<Map<String, dynamic>> qaQuestions = [
    {
      'question': 'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes',
      ],
      'correctAnswer': 'B) Hanging Gardens',
    },
    {
      'question': 'Q1: Who was the first emperor of Rome?',
      'options': [
        'A) Julius Caesar',
        'B) Augustus',
        'C) Nero',
        'D) Constantine',
      ],
      'correctAnswer': 'B) Augustus',
    },
    {
      'question': 'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes',
      ],
      'correctAnswer': 'C) Temple of Artemis',
    },
  ];

  void selectAnswer(int questionIndex, String answer) {
    qaAnswers[questionIndex] = answer;
  }

  bool isAnswerSelected(int questionIndex, String answer) {
    return qaAnswers[questionIndex] == answer;
  }

  bool get canSubmitQA => qaAnswers.length == qaQuestions.length;

  void submitQA() {
    if (canSubmitQA) {
      // Calculate score
      int correctCount = 0;
      for (int i = 0; i < qaQuestions.length; i++) {
        if (qaAnswers[i] == qaQuestions[i]['correctAnswer']) {
          correctCount++;
        }
      }
      // Handle submission (navigate to results, etc.)
      Get.snackbar(
        'Quiz Completed',
        'You got $correctCount out of ${qaQuestions.length} correct!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetQAAnswers() {
    qaAnswers.clear();
  }

  // Saved Places functionality
  var savedPlaces = <Map<String, dynamic>>[
    {
      'name': 'Great Wall of China',
      'description':
          'The Great Wall of China (traditional Chinese: 萬里長城; simplified Chine...',
      'rating': 4.3,
      'distance': '2.5km',
      'image':
          'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=500',
    },
    {
      'name': 'Great Wall of China',
      'description':
          'The Great Wall of China (traditional Chinese: 萬里長城; simplified Chine...',
      'rating': 4.3,
      'distance': '2.5km',
      'image':
          'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=500',
    },
    {
      'name': 'Taj Mahal',
      'description':
          'An ivory-white marble mausoleum on the right bank of the river Yamuna...',
      'rating': 4.8,
      'distance': '3.2km',
      'image':
          'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=500',
    },
    {
      'name': 'Eiffel Tower',
      'description':
          'A wrought-iron lattice tower on the Champ de Mars in Paris, France...',
      'rating': 4.6,
      'distance': '1.8km',
      'image':
          'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=500',
    },
  ].obs;

  // Track whether saved places have been loaded from API
  final RxBool hasLoadedSavedPlaces = false.obs;

  /// Fetch saved places from backend API using bearer token
  Future<void> fetchSavedPlaces() async {
    if (hasLoadedSavedPlaces.value) return;
    try {
      EasyLoading.show(status: 'Loading saved places...');
      final token = Get.find<StorageService>().getAccessToken();
      debugPrint('Fetching saved places. Token: $token');

      if (token == null || token.isEmpty) {
        debugPrint('No access token found. Aborting fetchSavedPlaces.');
        EasyLoading.dismiss();
        hasLoadedSavedPlaces.value = true;
        return;
      }

      final uri = Uri.parse(Url.getSavePlace);
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Saved places response status: ${response.statusCode}');
      debugPrint('Saved places response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['data'] ?? [];

        final List<Map<String, dynamic>> places = data.map((item) {
          final lat = (item['latitude'] is num) ? (item['latitude'] as num).toDouble() : (item['latitude'] != null ? double.tryParse(item['latitude'].toString()) ?? 0.0 : 0.0);
          final lng = (item['longitude'] is num) ? (item['longitude'] as num).toDouble() : (item['longitude'] != null ? double.tryParse(item['longitude'].toString()) ?? 0.0 : 0.0);

          return {
            'name': item['place_name'] ?? '',
            'description': item['place_description'] ?? '',
            'rating': double.tryParse((item['place_rating'] ?? '').toString()) ?? 0.0,
            'distance': _formatDistance(initialLat, initialLng, lat, lng),
            'image': item['place_image'] ?? '',
            'latitude': lat,
            'longitude': lng,
            'id': item['id'],
          };
        }).toList();

        savedPlaces.assignAll(places);
      } else {
        debugPrint('Failed to load saved places: ${response.statusCode}');
      }
    } catch (e, st) {
      debugPrint('Error fetching saved places: $e\n$st');
    } finally {
      EasyLoading.dismiss();
      hasLoadedSavedPlaces.value = true;
    }
  }

  String _formatDistance(double lat1, double lon1, double lat2, double lon2) {
    try {
      const double earthRadius = 6371; // km
      double dLat = _deg2rad(lat2 - lat1);
      double dLon = _deg2rad(lon2 - lon1);
      double a = (sin(dLat / 2) * sin(dLat / 2)) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * (sin(dLon / 2) * sin(dLon / 2));
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double distance = earthRadius * c;
      if (distance >= 1) {
        return '${distance.toStringAsFixed(1)}km';
      } else {
        return '${(distance * 1000).toStringAsFixed(0)}m';
      }
    } catch (_) {
      return '';
    }
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  // Remove place from saved list
  void unsavePlace(int index) {
    if (index >= 0 && index < savedPlaces.length) {
      final placeName = savedPlaces[index]['name'];
      savedPlaces.removeAt(index);
      Get.snackbar(
        'Removed',
        '$placeName has been removed from saved places',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Add place to saved list
  void savePlace(Map<String, dynamic> place) {
    if (!savedPlaces.any((p) => p['name'] == place['name'])) {
      savedPlaces.add(place);
      Get.snackbar(
        'Saved',
        '${place['name']} has been saved',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Check if place is saved
  bool isPlaceSaved(String placeName) {
    return savedPlaces.any((place) => place['name'] == placeName);
  }

  // Downloaded Maps functionality
  var downloadedMaps = <Map<String, dynamic>>[].obs;

  // Show rename dialog
  void showRenameDialog(BuildContext context, int index) {
    final TextEditingController nameController = TextEditingController(
      text: downloadedMaps[index]['name'],
    );

    Get.dialog(
      AlertDialog(
        title: Text('Rename Map'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Get.back(); // Close dialog first
                renameMap(index, nameController.text); // Then rename
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Rename map
  void renameMap(int index, String newName) {
    if (index >= 0 && index < downloadedMaps.length) {
      // Create a new map with updated name to trigger reactivity
      final updatedMap = Map<String, dynamic>.from(downloadedMaps[index]);
      updatedMap['name'] = newName;
      downloadedMaps[index] = updatedMap;
      downloadedMaps.refresh(); // Force update the observable list
    }
  }

  // Delete map
  void deleteMap(int index) {
    if (index >= 0 && index < downloadedMaps.length) {
      final mapName = downloadedMaps[index]['name'];
      downloadedMaps.removeAt(index);
      Get.snackbar(
        'Deleted',
        '$mapName has been deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Select map and navigate to view it
  void selectMap(int index) {
    if (index >= 0 && index < downloadedMaps.length) {
      final map = downloadedMaps[index];
      final mapName = map['name'];
      final lat = map['latitude'] ?? initialLat;
      final lng = map['longitude'] ?? initialLng;
      final zoom = map['zoom'] ?? 15.0;

      // Move camera to saved location
      moveCamera(lat, lng, zoom: zoom);

      Get.back(); // Go back to previous screen
      Get.snackbar(
        'Map Loaded',
        '$mapName has been loaded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Download current map view
  String downloadCurrentMap() {
    final currentPosition = cameraPosition.value;
    final mapNumber = downloadedMaps.length + 1;
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final newMap = {
      'id': mapNumber.toString(),
      'name': 'Map ${mapNumber.toString().padLeft(2, '0')}',
      'lastDownloaded': formattedDate,
      'latitude': currentPosition.target.latitude,
      'longitude': currentPosition.target.longitude,
      'zoom': currentPosition.zoom,
    };

    downloadedMaps.add(newMap);

    // Return the map name instead of showing snackbar here
    return newMap['name'] as String;
  }

  ///offline map
  final double initialLat = 23.7808875;
  final double initialLng = 90.2792371;

  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(23.7808875, 90.2792371),
    zoom: 15,
  ).obs;

  final RxSet<Marker> markers = <Marker>{}.obs;
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

  @override
  void onReady() {
    super.onReady();
    // Load persisted name/email from storage (if available)
    try {
      final storage = Get.find<StorageService>();
      final storedName = storage.getUserName();
      final storedEmail = storage.getUserEmail();
      if (storedName != null && storedName.isNotEmpty) {
        userName.value = storedName;
      }
      if (storedEmail != null && storedEmail.isNotEmpty) {
        userEmail.value = storedEmail;
      }
    } catch (e) {
      debugPrint('Error loading profile info from storage: $e');
    }
  }

  // Persist name and email when updated
  void setUserName(String name) {
    userName.value = name;
    try {
      Get.find<StorageService>().saveUserName(name);
    } catch (e) {
      debugPrint('Error saving user name: $e');
    }
  }

  void setUserEmail(String email) {
    userEmail.value = email;
    try {
      Get.find<StorageService>().saveUserEmail(email);
    } catch (e) {
      debugPrint('Error saving user email: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    gMapController = controller;
  }

  Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
    final newPos = CameraPosition(target: LatLng(lat, lng), zoom: zoom);
    cameraPosition.value = newPos;
    if (gMapController != null) {
      await gMapController!.animateCamera(
        CameraUpdate.newCameraPosition(newPos),
      );
    }
    // update marker
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('marker_${lat}_$lng'),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'Selected location'),
      ),
    );
  }

  // Logout method
  Future<void> logout() async {
    try {
      debugPrint("🚪 Logout button clicked");
      EasyLoading.show(status: "Logging out...");

      // Clear all tokens and user data
      Get.find<StorageService>().logout();

      await Future.delayed(const Duration(milliseconds: 500));
      EasyLoading.showSuccess("Logged out successfully");

      debugPrint("✅ Logout successful - Navigating to Splash Screen");

      // Navigate to splash screen
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => SplashScreen());
    } catch (e) {
      debugPrint("❌ Logout Error: $e");
      EasyLoading.showError("Something went wrong");
    }
  }
}
