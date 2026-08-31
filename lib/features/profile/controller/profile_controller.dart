
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/splash_screen/screen/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null);
  var profileImageBytes = Rx<Uint8List?>(null);
  final RxnString profileImageFileName = RxnString();

  var userName = ''.obs;
  var userEmail = ''.obs;
  var phoneNumber = '+880 10-46-828200'.obs;
  var selectedPlan = RxnString();

  // AI Assistant options
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxList<String> voiceTypes = <String>[].obs;

  final int maxVoiceTypesSelections = 3;

  String? get selectedVoiceType {
    return voiceTypes.isNotEmpty
        ? voiceTypes.last
        : null;
  }

  String? _normalizeValue(String? value) {
    final normalizedValue =
        value?.trim().toLowerCase();

    if (normalizedValue == null ||
        normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  void _loadAiAssistantPreferences() {
    final storage = Get.find<StorageService>();

    gender.value = _normalizeValue(
      storage.getAiGender(),
    );

    voice.value = _normalizeValue(
      storage.getAiVoice(),
    );

    voiceTypes.assignAll(
      storage
          .getAiVoiceTypes()
          .map((item) => item.trim().toLowerCase())
          .where((item) => item.isNotEmpty)
          .toList(),
    );

    debugPrint('====================================');
    debugPrint(
      '📖 Loaded AI gender: ${gender.value}',
    );
    debugPrint(
      '📖 Loaded AI voice: ${voice.value}',
    );
    debugPrint(
      '📖 Loaded voice types: $voiceTypes',
    );
    debugPrint('====================================');
  }

  void selectGender(String? selectedGender) {
    final normalizedGender =
        _normalizeValue(selectedGender);

    gender.value = normalizedGender;

    persistAiAssistantPreferences();

    debugPrint(
      '✅ Selected AI gender: ${gender.value}',
    );
  }

  void selectVoice(String? selectedVoice) {
    final normalizedVoice =
        _normalizeValue(selectedVoice);

    voice.value = normalizedVoice;

    persistAiAssistantPreferences();

    debugPrint(
      '✅ Selected AI voice: ${voice.value}',
    );
  }

  bool toggleVoiceType(String selectedType) {
    final normalizedType =
        _normalizeValue(selectedType);

    if (normalizedType == null) {
      return false;
    }

    final existingIndex = voiceTypes.indexWhere(
      (item) =>
          item.trim().toLowerCase() ==
          normalizedType,
    );

    if (existingIndex != -1) {
      voiceTypes.removeAt(existingIndex);
      persistAiAssistantPreferences();

      debugPrint(
        '🗑️ Removed voice type: $normalizedType',
      );

      return true;
    }

    if (voiceTypes.length >=
        maxVoiceTypesSelections) {
      return false;
    }

    voiceTypes.add(normalizedType);
    persistAiAssistantPreferences();

    debugPrint(
      '✅ Added voice type: $normalizedType',
    );

    return true;
  }

  void persistAiAssistantPreferences() {
    final storage = Get.find<StorageService>();

    final selectedGender =
        _normalizeValue(gender.value);

    final selectedVoice =
        _normalizeValue(voice.value);

    final normalizedVoiceTypes = voiceTypes
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList();

    gender.value = selectedGender;
    voice.value = selectedVoice;

    voiceTypes.assignAll(
      normalizedVoiceTypes,
    );

    if (selectedGender == null) {
      storage.removeAiGender();
    } else {
      storage.saveAiGender(selectedGender);
    }

    if (selectedVoice == null) {
      storage.removeAiVoice();
    } else {
      storage.saveAiVoice(selectedVoice);
    }

    if (normalizedVoiceTypes.isEmpty) {
      storage.removeAiVoiceTypes();
    } else {
      storage.saveAiVoiceTypes(
        normalizedVoiceTypes,
      );
    }

    debugPrint('====================================');
    debugPrint(
      '💾 Persisted AI gender: $selectedGender',
    );
    debugPrint(
      '💾 Persisted AI voice: $selectedVoice',
    );
    debugPrint(
      '💾 Persisted voice types: '
      '$normalizedVoiceTypes',
    );
    debugPrint('====================================');
  }

  void resetAiAssistant() {
    gender.value = null;
    voice.value = null;
    voiceTypes.clear();

    final storage = Get.find<StorageService>();

    storage.removeAiGender();
    storage.removeAiVoice();
    storage.removeAiVoiceTypes();

    debugPrint(
      '✅ All AI assistant preferences reset',
    );
  }

  /// Selected AI preferences backend-এ update করবে।
  Future<bool> updateAiPreferences() async {
    final storage = Get.find<StorageService>();
    final token = storage.getAccessToken();

    if (token == null ||
        token.trim().isEmpty) {
      EasyLoading.showError(
        'Authentication required',
      );
      return false;
    }

    final selectedGender =
        _normalizeValue(gender.value);

    final selectedVoice =
        _normalizeValue(voice.value);

    final selectedType =
        _normalizeValue(selectedVoiceType);

    if (selectedGender == null ||
        selectedVoice == null ||
        selectedType == null) {
      EasyLoading.showError(
        'Please complete all selections',
      );
      return false;
    }

    final body = <String, dynamic>{
      'gender': selectedGender,
      'ai_voice': selectedVoice,
      'ai_voice_type': selectedType,
    };

    debugPrint('====================================');
    debugPrint(
      '📤 Updating profile preferences: '
      '${jsonEncode(body)}',
    );
    debugPrint('====================================');

    try {
      EasyLoading.show(
        status: 'Updating AI preferences...',
      );

      final response = await http.post(
        Uri.parse(Url.profilecreation),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.trim()}',
        },
        body: jsonEncode(body),
      );

      EasyLoading.dismiss();

      debugPrint(
        'Profile update status: '
        '${response.statusCode}',
      );

      debugPrint(
        'Profile update response: '
        '${response.body}',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        gender.value = selectedGender;
        voice.value = selectedVoice;

        persistAiAssistantPreferences();

        EasyLoading.showSuccess(
          'AI preferences updated',
        );

        return true;
      }

      String errorMessage =
          'Failed to update preferences';

      try {
        final decodedResponse =
            jsonDecode(response.body);

        if (decodedResponse is Map) {
          errorMessage =
              decodedResponse['message']
                      ?.toString() ??
                  decodedResponse['detail']
                      ?.toString() ??
                  errorMessage;
        }
      } catch (_) {
        // Default error message ব্যবহার হবে।
      }

      EasyLoading.showError(errorMessage);

      return false;
    } catch (error, stackTrace) {
      EasyLoading.dismiss();

      debugPrint(
        'AI preference update error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      EasyLoading.showError(
        'Something went wrong',
      );

      return false;
    }
  }

  // Quiz options
  var selectedQuantity = RxnInt();
  var selectedSubject = RxnString();

  bool get canStartQuiz {
    return selectedQuantity.value != null &&
        selectedSubject.value != null;
  }

  // Profile image
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }

    final bytes =
        await pickedFile.readAsBytes();

    profileImageBytes.value = bytes;
    profileImageFileName.value =
        pickedFile.name;

    if (!kIsWeb) {
      profileImage.value =
          File(pickedFile.path);
    }

    try {
      final base64Image =
          base64Encode(bytes);

      Get.find<StorageService>()
          .saveProfileImageBase64(
        base64Image,
      );
    } catch (error) {
      debugPrint(
        'Error saving profile image: $error',
      );
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      if (profileImage.value == null &&
          profileImageBytes.value == null) {
        EasyLoading.showError(
          'Please select an image first',
        );

        debugPrint('❌ No image selected');

        return;
      }

      EasyLoading.show(
        status: 'Uploading image...',
      );

      final token =
          Get.find<StorageService>()
              .getAccessToken();

      if (token == null ||
          token.isEmpty) {
        EasyLoading.dismiss();

        EasyLoading.showError(
          'Authentication required',
        );

        debugPrint(
          '❌ No access token found',
        );

        return;
      }

      debugPrint(
        'API URL: ${Url.profileImage}',
      );

      debugPrint(
        'Image Path/Bytes: '
        '${profileImage.value?.path ?? 'bytes'}',
      );

      final request =
          http.MultipartRequest(
        'POST',
        Uri.parse(Url.profileImage),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            profileImage.value!.path,
            filename:
                profileImageFileName.value,
          ),
        );
      } else {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            profileImageBytes.value!,
            filename:
                profileImageFileName.value ??
                'profile_image.png',
          ),
        );
      }

      debugPrint(
        'Sending profile image request...',
      );

      final streamedResponse =
          await request.send();

      final response =
          await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint(
        'Response status: '
        '${response.statusCode}',
      );

      debugPrint(
        'Response body: ${response.body}',
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        EasyLoading.showSuccess(
          'Profile image uploaded successfully!',
        );
      } else {
        EasyLoading.showError(
          'Upload failed: '
          '${response.statusCode}',
        );
      }
    } catch (error) {
      EasyLoading.dismiss();

      EasyLoading.showError(
        'Error uploading image',
      );

      debugPrint(
        '❌ Profile image upload error: '
        '$error',
      );
    }
  }

  // Subscription
  void selectSubscriptionPlan(
    String plan,
  ) {
    if (selectedPlan.value == plan) {
      selectedPlan.value = null;
    } else {
      selectedPlan.value = plan;
    }
  }

  void subscribeNow() {
    if (selectedPlan.value != null) {
      debugPrint(
        'Selected subscription: '
        '${selectedPlan.value}',
      );
    }
  }

  // Quiz selection methods
  void selectQuantity(int quantity) {
    if (selectedQuantity.value ==
        quantity) {
      selectedQuantity.value = null;
    } else {
      selectedQuantity.value =
          quantity;
    }
  }

  void selectSubject(String subject) {
    if (selectedSubject.value ==
        subject) {
      selectedSubject.value = null;
    } else {
      selectedSubject.value =
          subject;
    }
  }

  void resetQuizOptions() {
    selectedQuantity.value = null;
    selectedSubject.value = null;
  }

  // Q&A
  var qaAnswers =
      <int, String>{}.obs;

  final List<Map<String, dynamic>>
      qaQuestions = [
    {
      'question':
          'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes',
      ],
      'correctAnswer':
          'B) Hanging Gardens',
    },
    {
      'question':
          'Q1: Who was the first emperor of Rome?',
      'options': [
        'A) Julius Caesar',
        'B) Augustus',
        'C) Nero',
        'D) Constantine',
      ],
      'correctAnswer': 'B) Augustus',
    },
    {
      'question':
          'Q1: Which ancient wonder was located in Babylon?',
      'options': [
        'A) The Great Pyramid of Giza',
        'B) Hanging Gardens',
        'C) Temple of Artemis',
        'D) Colossus of Rhodes',
      ],
      'correctAnswer':
          'C) Temple of Artemis',
    },
  ];

  void selectAnswer(
    int questionIndex,
    String answer,
  ) {
    qaAnswers[questionIndex] =
        answer;
  }

  bool isAnswerSelected(
    int questionIndex,
    String answer,
  ) {
    return qaAnswers[questionIndex] ==
        answer;
  }

  bool get canSubmitQA {
    return qaAnswers.length ==
        qaQuestions.length;
  }

  void submitQA() {
    if (!canSubmitQA) {
      return;
    }

    int correctCount = 0;

    for (
      int index = 0;
      index < qaQuestions.length;
      index++
    ) {
      if (qaAnswers[index] ==
          qaQuestions[index]
              ['correctAnswer']) {
        correctCount++;
      }
    }

    Get.snackbar(
      'Quiz Completed',
      'You got $correctCount out of '
          '${qaQuestions.length} correct!',
      snackPosition:
          SnackPosition.BOTTOM,
    );
  }

  void resetQAAnswers() {
    qaAnswers.clear();
  }

  // Saved places
  var savedPlaces =
      <Map<String, dynamic>>[
    {
      'name': 'Great Wall of China',
      'description':
          'The Great Wall of China '
          '(traditional Chinese: 萬里長城; '
          'simplified Chine...',
      'rating': 4.3,
      'distance': '2.5km',
      'image':
          'https://images.unsplash.com/'
          'photo-1508804185872-d7badad00f7d?w=500',
    },
    {
      'name': 'Great Wall of China',
      'description':
          'The Great Wall of China '
          '(traditional Chinese: 萬里長城; '
          'simplified Chine...',
      'rating': 4.3,
      'distance': '2.5km',
      'image':
          'https://images.unsplash.com/'
          'photo-1508804185872-d7badad00f7d?w=500',
    },
    {
      'name': 'Taj Mahal',
      'description':
          'An ivory-white marble mausoleum '
          'on the right bank of the river '
          'Yamuna...',
      'rating': 4.8,
      'distance': '3.2km',
      'image':
          'https://images.unsplash.com/'
          'photo-1564507592333-c60657eea523?w=500',
    },
    {
      'name': 'Eiffel Tower',
      'description':
          'A wrought-iron lattice tower '
          'on the Champ de Mars in Paris, '
          'France...',
      'rating': 4.6,
      'distance': '1.8km',
      'image':
          'https://images.unsplash.com/'
          'photo-1511739001486-6bfe10ce785f?w=500',
    },
  ].obs;

  final RxBool hasLoadedSavedPlaces =
      false.obs;

  Future<void> fetchSavedPlaces() async {
    if (hasLoadedSavedPlaces.value) {
      return;
    }

    try {
      EasyLoading.show(
        status: 'Loading saved places...',
      );

      final token =
          Get.find<StorageService>()
              .getAccessToken();

      if (token == null ||
          token.isEmpty) {
        debugPrint(
          'No access token found',
        );

        hasLoadedSavedPlaces.value =
            true;

        return;
      }

      final response = await http.get(
        Uri.parse(Url.getSavePlace),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer $token',
        },
      );

      debugPrint(
        'Saved places response status: '
        '${response.statusCode}',
      );

      debugPrint(
        'Saved places response body: '
        '${response.body}',
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Failed to load saved places: '
          '${response.statusCode}',
        );

        return;
      }

      final decodedBody =
          jsonDecode(response.body);

      if (decodedBody is! Map) {
        debugPrint(
          'Invalid saved places response',
        );

        return;
      }

      final data =
          decodedBody['data'];

      if (data is! List) {
        savedPlaces.clear();
        return;
      }

      final places = data.map((item) {
        final map =
            Map<String, dynamic>.from(
          item,
        );

        final latitude =
            _parseCoordinate(
          map['latitude'],
        );

        final longitude =
            _parseCoordinate(
          map['longitude'],
        );

        return <String, dynamic>{
          'name':
              map['place_name'] ?? '',
          'description':
              map['place_description'] ??
              '',
          'rating': double.tryParse(
                (map['place_rating'] ?? '')
                    .toString(),
              ) ??
              0.0,
          'distance': _formatDistance(
            initialLat,
            initialLng,
            latitude,
            longitude,
          ),
          'image':
              map['place_image'] ?? '',
          'latitude': latitude,
          'longitude': longitude,
          'id': map['id'],
        };
      }).toList();

      savedPlaces.assignAll(places);
    } catch (error, stackTrace) {
      debugPrint(
        'Error fetching saved places: '
        '$error\n$stackTrace',
      );
    } finally {
      EasyLoading.dismiss();
      hasLoadedSavedPlaces.value =
          true;
    }
  }

  double _parseCoordinate(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  String _formatDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    try {
      const earthRadius = 6371.0;

      final dLat =
          _deg2rad(lat2 - lat1);

      final dLon =
          _deg2rad(lon2 - lon1);

      final a =
          sin(dLat / 2) *
                  sin(dLat / 2) +
              cos(_deg2rad(lat1)) *
                  cos(_deg2rad(lat2)) *
                  sin(dLon / 2) *
                  sin(dLon / 2);

      final c = 2 *
          atan2(
            sqrt(a),
            sqrt(1 - a),
          );

      final distance =
          earthRadius * c;

      if (distance >= 1) {
        return '${distance.toStringAsFixed(1)}km';
      }

      return '${(distance * 1000).toStringAsFixed(0)}m';
    } catch (_) {
      return '';
    }
  }

  double _deg2rad(double degree) {
    return degree * (pi / 180);
  }

  void unsavePlace(int index) {
    if (index < 0 ||
        index >= savedPlaces.length) {
      return;
    }

    final placeName =
        savedPlaces[index]['name'];

    savedPlaces.removeAt(index);

    Get.snackbar(
      'Removed',
      '$placeName has been removed '
          'from saved places',
      snackPosition:
          SnackPosition.BOTTOM,
      backgroundColor:
          Get.theme.colorScheme.error,
      colorText: Colors.white,
      duration:
          const Duration(seconds: 2),
      margin:
          const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void savePlace(
    Map<String, dynamic> place,
  ) {
    final alreadySaved =
        savedPlaces.any(
      (item) =>
          item['name'] == place['name'],
    );

    if (alreadySaved) {
      return;
    }

    savedPlaces.add(place);

    Get.snackbar(
      'Saved',
      '${place['name']} has been saved',
      snackPosition:
          SnackPosition.BOTTOM,
      backgroundColor:
          Get.theme.primaryColor,
      colorText: Colors.white,
      duration:
          const Duration(seconds: 2),
      margin:
          const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  bool isPlaceSaved(
    String placeName,
  ) {
    return savedPlaces.any(
      (place) =>
          place['name'] == placeName,
    );
  }

  // Downloaded maps
  var downloadedMaps =
      <Map<String, dynamic>>[].obs;

  void showRenameDialog(
    BuildContext context,
    int index,
  ) {
    final nameController =
        TextEditingController(
      text:
          downloadedMaps[index]['name'],
    );

    Get.dialog(
      AlertDialog(
        title:
            const Text('Rename Map'),
        content: TextField(
          controller: nameController,
          decoration:
              const InputDecoration(
            labelText: 'Name',
            border:
                OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child:
                const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName =
                  nameController.text
                      .trim();

              if (newName.isEmpty) {
                return;
              }

              Get.back();

              renameMap(
                index,
                newName,
              );
            },
            child:
                const Text('Save'),
          ),
        ],
      ),
    );
  }

  void renameMap(
    int index,
    String newName,
  ) {
    if (index < 0 ||
        index >=
            downloadedMaps.length) {
      return;
    }

    final updatedMap =
        Map<String, dynamic>.from(
      downloadedMaps[index],
    );

    updatedMap['name'] = newName;

    downloadedMaps[index] =
        updatedMap;

    downloadedMaps.refresh();
  }

  void deleteMap(int index) {
    if (index < 0 ||
        index >=
            downloadedMaps.length) {
      return;
    }

    final mapName =
        downloadedMaps[index]['name'];

    downloadedMaps.removeAt(index);

    Get.snackbar(
      'Deleted',
      '$mapName has been deleted',
      snackPosition:
          SnackPosition.BOTTOM,
      backgroundColor:
          Get.theme.colorScheme.error,
      colorText: Colors.white,
      duration:
          const Duration(seconds: 2),
      margin:
          const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void selectMap(int index) {
    if (index < 0 ||
        index >=
            downloadedMaps.length) {
      return;
    }

    final map =
        downloadedMaps[index];

    final mapName = map['name'];

    final latitude =
        (map['latitude'] as num?)
                ?.toDouble() ??
            initialLat;

    final longitude =
        (map['longitude'] as num?)
                ?.toDouble() ??
            initialLng;

    final zoom =
        (map['zoom'] as num?)
                ?.toDouble() ??
            15.0;

    moveCamera(
      latitude,
      longitude,
      zoom: zoom,
    );

    Get.back();

    Get.snackbar(
      'Map Loaded',
      '$mapName has been loaded',
      snackPosition:
          SnackPosition.BOTTOM,
      backgroundColor:
          Get.theme.primaryColor,
      colorText: Colors.white,
      duration:
          const Duration(seconds: 2),
      margin:
          const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  String downloadCurrentMap() {
    final currentPosition =
        cameraPosition.value;

    final mapNumber =
        downloadedMaps.length + 1;

    final now = DateTime.now();

    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    final newMap =
        <String, dynamic>{
      'id': mapNumber.toString(),
      'name':
          'Map ${mapNumber.toString().padLeft(2, '0')}',
      'lastDownloaded':
          formattedDate,
      'latitude':
          currentPosition
              .target.latitude,
      'longitude':
          currentPosition
              .target.longitude,
      'zoom':
          currentPosition.zoom,
    };

    downloadedMaps.add(newMap);

    return newMap['name'] as String;
  }

  // Offline map
  final double initialLat =
      23.7808875;

  final double initialLng =
      90.2792371;

  final Rx<CameraPosition>
      cameraPosition =
      const CameraPosition(
    target: LatLng(
      23.7808875,
      90.2792371,
    ),
    zoom: 15,
  ).obs;

  final RxSet<Marker> markers =
      <Marker>{}.obs;

  GoogleMapController?
      gMapController;

  @override
  void onInit() {
    super.onInit();

    _loadAiAssistantPreferences();

    const initialMarker = Marker(
      markerId:
          MarkerId('initial_marker'),
      position: LatLng(
        23.7808875,
        90.2792371,
      ),
      infoWindow: InfoWindow(
        title: 'You are here',
      ),
    );

    markers.add(initialMarker);
  }

  @override
  void onReady() {
    super.onReady();

    try {
      final storage =
          Get.find<StorageService>();

      final storedName =
          storage.getUserName();

      final storedEmail =
          storage.getUserEmail();

      if (storedName != null &&
          storedName.isNotEmpty) {
        userName.value = storedName;
      }

      if (storedEmail != null &&
          storedEmail.isNotEmpty) {
        userEmail.value =
            storedEmail;
      }

      final savedBase64 =
          storage
              .getProfileImageBase64();

      if (savedBase64 != null &&
          savedBase64.isNotEmpty) {
        profileImageBytes.value =
            base64Decode(
          savedBase64,
        );
      }
    } catch (error) {
      debugPrint(
        'Error loading profile info: '
        '$error',
      );
    }
  }

  void setUserName(String name) {
    userName.value = name;

    try {
      Get.find<StorageService>()
          .saveUserName(name);
    } catch (error) {
      debugPrint(
        'Error saving user name: '
        '$error',
      );
    }
  }

  void setUserEmail(String email) {
    userEmail.value = email;

    try {
      Get.find<StorageService>()
          .saveUserEmail(email);
    } catch (error) {
      debugPrint(
        'Error saving user email: '
        '$error',
      );
    }
  }

  void onMapCreated(
    GoogleMapController controller,
  ) {
    gMapController = controller;
  }

  Future<void> moveCamera(
    double latitude,
    double longitude, {
    double zoom = 15,
  }) async {
    final newPosition =
        CameraPosition(
      target: LatLng(
        latitude,
        longitude,
      ),
      zoom: zoom,
    );

    cameraPosition.value =
        newPosition;

    if (gMapController != null) {
      await gMapController!
          .animateCamera(
        CameraUpdate.newCameraPosition(
          newPosition,
        ),
      );
    }

    markers.clear();

    markers.add(
      Marker(
        markerId: MarkerId(
          'marker_${latitude}_$longitude',
        ),
        position: LatLng(
          latitude,
          longitude,
        ),
        infoWindow:
            const InfoWindow(
          title:
              'Selected location',
        ),
      ),
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      debugPrint(
        '🚪 Logout button clicked',
      );

      EasyLoading.show(
        status: 'Logging out...',
      );

      Get.find<StorageService>()
          .logout();

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      EasyLoading.showSuccess(
        'Logged out successfully',
      );

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      Get.offAll(
        () => SplashScreen(),
      );
    } catch (error) {
      debugPrint(
        '❌ Logout error: $error',
      );

      EasyLoading.showError(
        'Something went wrong',
      );
    }
  }

  @override
  void onClose() {
    profileImage.value = null;
    profileImageBytes.value = null;
    profileImageFileName.value =
        null;

    savedPlaces.clear();
    qaAnswers.clear();
    markers.clear();

    super.onClose();
  }
}