import 'package:ai_powered_tourists_app/core/localization/localization_service.dart';
import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';

class HomeController extends GetxController {
  // Basic profile & location info
  var userName = "Jak Nos".obs;
  var currentAddress = "4517 Washington Ave. Manchester, Kentucky 39495".obs;
  var currentWeather = "22°C".obs;

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
    
    // Listen to locale changes and reload data
    ever(Get.find<LocalizationService>().currentLocale, (_) {
      reloadPlacesData();
    });
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
      }
    });
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
    if (_mapController != null) {
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