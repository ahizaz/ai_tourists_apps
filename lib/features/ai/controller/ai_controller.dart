import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AiController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        await _handleImageSelected(File(image.path));
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image from gallery');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        await _handleImageSelected(File(image.path));
      }
    } catch (e) {
      EasyLoading.showError('Failed to capture image from camera');
    }
  }

  Future<void> _handleImageSelected(File imageFile) async {
    // Add user's image message
    messages.add(ChatMessage(
      text: "Can you tell me about this place?",
      isUser: true,
      timestamp: DateTime.now(),
      imageFile: imageFile,
    ));
    
    _scrollToBottom();
    
    EasyLoading.show(status: 'Thinking...');
    await Future.delayed(const Duration(seconds: 2));
    
    messages.add(ChatMessage(
      text: _getSimulatedResponse(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
    
    EasyLoading.dismiss();
    _scrollToBottom();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    
    messageController.clear();
    _scrollToBottom();
    
    // Call real AI API
    _callAiApi(text);
  }

  Future<void> _generateAIResponse(String userMessage) async {
    EasyLoading.show(status: 'Thinking...');
    await Future.delayed(const Duration(seconds: 2));
    
    String response;
    
    // Simple keyword-based responses (replace with actual AI API)
    if (userMessage.toLowerCase().contains('great wall') || 
        userMessage.toLowerCase().contains('china')) {
      response = _getGreatWallResponse();
    } else if (userMessage.toLowerCase().contains('taj mahal') || 
               userMessage.toLowerCase().contains('india')) {
      response = _getTajMahalResponse();
    } else if (userMessage.toLowerCase().contains('pyramid') || 
               userMessage.toLowerCase().contains('egypt')) {
      response = _getPyramidResponse();
    } else {
      response = _getGenericResponse();
    }
    
    messages.add(ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    
    EasyLoading.dismiss();
    _scrollToBottom();
  }

  Future<void> _callAiApi(String userMessage) async {
    try {
      // Get token
      final token = Get.find<StorageService>().getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.showError('Authentication required');
        return;
      }

      // Get current position and resolved place
      String resolvedPlace = 'Selected Location';
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            resolvedPlace = _getLocationNameFromPlacemark(place);
          }
        }
      } catch (e) {
        debugPrint('Failed to resolve location: $e');
      }

      final body = {
        'resolved_place': resolvedPlace,
        'question': userMessage,
      };

      EasyLoading.show(status: 'Thinking...');

      debugPrint('AI API: ${Url.chat}');
      debugPrint('AI Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(Url.chat),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('AI response status: ${response.statusCode}');
      debugPrint('AI response body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final answer = data['answer']?.toString() ?? 'No answer available';

        messages.add(ChatMessage(
          text: answer,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else {
        EasyLoading.showError('Failed to get response');
        messages.add(ChatMessage(
          text: 'Sorry, I could not get an answer right now.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }

      _scrollToBottom();
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Exception calling AI API: $e');
      EasyLoading.showError('Request failed');
      messages.add(ChatMessage(
        text: 'Something went wrong. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    }
  }

  String _getLocationNameFromPlacemark(Placemark place) {
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

  String _getGreatWallResponse() {
    String userName = "friend"; // Default name
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.userName.value.split(' ')[0];
    } catch (e) {
      // If ProfileController not found, use default
    }

    return "Excellent choice, $userName! \n\nThe Great Wall of China is one of the most iconic structures in human history. Built over centuries, with construction beginning as early as the 7th century BC, it stretches over 13,000 miles (21,000 km) across northern China!\n\n📜 Historical Context:\nOriginally built by various states for defense, it was unified and extended during the Ming Dynasty (1368-1644). The wall served to protect Chinese states from invasions and raids by nomadic groups from the Eurasian Steppe.\n\n🎯 Fun Fact:\nContrary to popular belief, the Great Wall is NOT visible from space with the naked eye! This is a common myth.\n\n✨ Today, it stands as a UNESCO World Heritage Site and receives millions of visitors each year.\n\nWould you like to know more about any other landmark?";
  }

  String _getTajMahalResponse() {
    String userName = "friend"; // Default name
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.userName.value.split(' ')[0];
    } catch (e) {
      // If ProfileController not found, use default
    }

    return "Wonderful, $userName! \n\nThe Taj Mahal is a magnificent ivory-white marble mausoleum located in Agra, India. It's truly one of the world's most romantic monuments!\n\n💕 Love Story:\nIt was commissioned in 1631 by Mughal emperor Shah Jahan to house the tomb of his beloved wife, Mumtaz Mahal, who died during childbirth.\n\n🏗️ Construction:\nIt took approximately 22 years and 20,000 artisans to complete this architectural masterpiece, which combines elements from Islamic, Persian, Ottoman Turkish, and Indian architectural styles.\n\n🌟 Recognition:\nThe Taj Mahal is considered one of the greatest examples of Mughal architecture and was designated as a UNESCO World Heritage Site in 1983. It's also one of the New Seven Wonders of the World!\n\nWhat else would you like to explore?";
  }

  String _getPyramidResponse() {
    String userName = "friend"; // Default name
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.userName.value.split(' ')[0];
    } catch (e) {
      // If ProfileController not found, use default
    }

    return "Amazing, $userName! \n\nThe Great Pyramid of Giza is the oldest and largest of the three pyramids in the Giza pyramid complex. It's an absolute marvel of ancient engineering!\n\n👑 Royal Legacy:\nBuilt around 2560 BC during the reign of Pharaoh Khufu (Cheops), it stood as the tallest man-made structure in the world for over 3,800 years!\n\n✨ Original Appearance:\nThe pyramid was originally covered in white limestone casing stones that reflected the sun's light, making it shine like a jewel in the desert.\n\n🔢 By the Numbers:\nIt consists of approximately 2.3 million stone blocks, each weighing between 2.5 to 15 tons. The precision of its construction still amazes engineers today!\n\n🏆 Eternal Wonder:\nIt's one of the Seven Wonders of the Ancient World and the only one still standing today!\n\nCurious about other wonders?";
  }

  String _getSimulatedResponse() {
    String userName = "friend"; // Default name
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.userName.value.split(' ')[0];
    } catch (e) {
      // If ProfileController not found, use default
    }

    return "Thanks for sharing this photo, $userName! 📸\n\nI can see this appears to be a historical landmark with fascinating architectural elements that suggest significant cultural and historical importance.\n\nTo give you the most accurate and detailed story, could you help me with:\n• 📍 Where is this located?\n• 🏛️ Do you know the name of this place?\n\nOr feel free to ask me about any famous historical sites like:\n🇨🇳 Great Wall of China\n🇮🇳 Taj Mahal\n🇪🇬 Egyptian Pyramids\n🇫🇷 Eiffel Tower\n🇮🇹 Colosseum\n\nI'm here to make your journey more enriching! ✨";
  }

  String _getGenericResponse() {
    String userName = "friend"; // Default name
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.userName.value.split(' ')[0];
    } catch (e) {
      // If ProfileController not found, use default
    }

    return "That's a great question, $userName! \n\nI'd love to help you discover the world's most amazing historical places! Here are some iconic sites I can tell you about:\n\n🇨🇳 The Great Wall of China\n🇮🇳 Taj Mahal in India\n🇪🇬 Egyptian Pyramids\n🇮🇹 Colosseum in Rome\n🇫🇷 Eiffel Tower in Paris\n🇵🇪 Machu Picchu in Peru\n🇯🇴 Petra in Jordan\n\nYou can ask me about any of these, or better yet - snap a photo of any historical site and I'll share its fascinating story with you! 📸✨\n\nWhat interests you most?";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
void onClose() {
  // Dispose controllers to free memory
  messageController.dispose();
  scrollController.dispose();
  
 
  messages.clear();
  
  super.onClose();
  
}
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final File? imageFile;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageFile,
  });
}