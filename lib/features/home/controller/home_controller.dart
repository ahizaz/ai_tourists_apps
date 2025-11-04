import 'package:ai_powered_tourists_app/features/home/widget/place.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Basic profile & location info
  var userName = "Jak Nos".obs;
  var currentAddress = "4517 Washington Ave. Manchester, Kentucky 39495".obs;
  var currentWeather = "22°C".obs;

  // UI state
  var selectedCategory = 'Historical'.obs;
  var isNotificationRed =false.obs;
  void toggleNotificationColor(){
    isNotificationRed.value = !isNotificationRed.value;
  }

  // Dynamic list of places
  final places = <Place>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Sample data — replace with real API data later
    places.assignAll([
      Place(
        id: 'gwc',
        title: 'Great Wall of China',
        description:
            'The Great Wall of China is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.',
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSxFPo2KM3TStgMefLyEKBR0vlVgPBmxqk0pLS59-sJXBcmW3xH7567GcvcE4ejvayAbYzJwISv_DLj-IRWjMp_fSl5jpG6_hL8H7d-vMMLHYP-dgdpljyhorPpkHgJnZQ40X7am=w270-h312-n-k-no',
        rating: 4.3,
        distanceKm: 2.5,
        category: 'Historical',
      ),
      Place(
        id: 'museum1',
        title: 'National History Museum',
        description:
            'Explore ancient artifacts and natural history exhibitions from around the world.',
        imageUrl:
            'https://images.unsplash.com/photo-1554907984-15263bfd63bd?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
        rating: 4.0,
        distanceKm: 1.2,
        category: 'Museum',
      ),
      Place(
        id: 'tour1',
        title: 'City Park',
        description:
            'A big green area great for walking, cycling and family activities.',
        imageUrl:
            'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSzm7wFydyGdrpZB_1p2eYstikmI5NsQfXyZLfEbhRcOoGJ-eAHrsaCZTxtPNoRaJ4IPzj1anKiRs61q_nBnMFD5aj1Ohc6He_uKUkkRio-udSEMWzbTNciCdF_MNucfvIX7MM5p=s680-w680-h510-rw',
        rating: 4.1,
        distanceKm: 0.9,
        category: 'Tourism',
      ),
      // duplicate to show list scrolling
      Place(
        id: 'gwc2',
        title: 'Great Wall Scenic Spot',
        description:
            'Beautiful viewpoint with restored watchtowers and easy access trails.',
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        rating: 4.5,
        distanceKm: 3.1,
        category: 'Historical',
      ),
    ]);
  }

  List<Place> filteredPlaces() {
    final cat = selectedCategory.value;
    if (cat == 'All') return places;
    return places.where((p) => p.category == cat).toList();
  }

  void selectCategory(String cat) => selectedCategory.value = cat;
}