import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {

  
  var profileImage = Rx<File?>(null);
  var userName = "Brooklyn Simmons".obs;
  var userEmail = "brooklyn.sim@example.com".obs;
  var phoneNumber = "+880 10-46-828200".obs;
  var selectedPlan = RxnString();

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
    final TextEditingController nameController =
        TextEditingController(text: downloadedMaps[index]['name']);

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
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
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
  void downloadCurrentMap() {
    final currentPosition = cameraPosition.value;
    final mapNumber = downloadedMaps.length + 1;
    final now = DateTime.now();
    final formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    
    final newMap = {
      'id': mapNumber.toString(),
      'name': 'Map ${mapNumber.toString().padLeft(2, '0')}',
      'lastDownloaded': formattedDate,
      'latitude': currentPosition.target.latitude,
      'longitude': currentPosition.target.longitude,
      'zoom': currentPosition.zoom,
    };
    
    downloadedMaps.add(newMap);
    
    Get.snackbar(
      'Download Complete',
      '${newMap['name']} has been downloaded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xffFF7029),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
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
    void onMapCreated(GoogleMapController controller) {
    gMapController = controller;
  }
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
