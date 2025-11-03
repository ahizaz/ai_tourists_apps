import 'dart:io';
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
    // Add initial welcome message
    messages.add(ChatMessage(
      text: "Hello! I'm your AI travel assistant. Upload a photo of any historical place or ask me about famous landmarks, and I'll tell you its fascinating history!",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _handleImageSelected(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _handleImageSelected(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image from camera',
        snackPosition: SnackPosition.BOTTOM,
      );
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
    
    // Simulate AI processing
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    
    // Add AI response (you can integrate with actual AI API later)
    messages.add(ChatMessage(
      text: _getSimulatedResponse(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
    
    isLoading.value = false;
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
    
    // Simulate AI response
    _generateAIResponse(text);
  }

  Future<void> _generateAIResponse(String userMessage) async {
    isLoading.value = true;
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
    
    isLoading.value = false;
    _scrollToBottom();
  }

  String _getGreatWallResponse() {
    return "The Great Wall of China is one of the most iconic structures in human history. Built over centuries, with construction beginning as early as the 7th century BC, it stretches over 13,000 miles across northern China.\n\nOriginally built by various states for defense, it was unified and extended during the Ming Dynasty (1368-1644). The wall served to protect Chinese states from invasions and raids by nomadic groups from the Eurasian Steppe.\n\nFun fact: Contrary to popular belief, the Great Wall is NOT visible from space with the naked eye!";
  }

  String _getTajMahalResponse() {
    return "The Taj Mahal is a magnificent ivory-white marble mausoleum located in Agra, India. It was commissioned in 1631 by Mughal emperor Shah Jahan to house the tomb of his beloved wife, Mumtaz Mahal.\n\nIt took approximately 22 years and 20,000 artisans to complete this architectural masterpiece, which combines elements from Islamic, Persian, Ottoman Turkish, and Indian architectural styles.\n\nThe Taj Mahal is considered one of the greatest examples of Mughal architecture and was designated as a UNESCO World Heritage Site in 1983.";
  }

  String _getPyramidResponse() {
    return "The Great Pyramid of Giza is the oldest and largest of the three pyramids in the Giza pyramid complex. Built around 2560 BC during the reign of Pharaoh Khufu (Cheops), it stood as the tallest man-made structure in the world for over 3,800 years!\n\nThe pyramid was originally covered in white limestone casing stones that reflected the sun's light, making it shine like a jewel. It consists of approximately 2.3 million stone blocks, each weighing between 2.5 to 15 tons.\n\nIt's one of the Seven Wonders of the Ancient World and the only one still standing today!";
  }

  String _getSimulatedResponse() {
    return "This appears to be a historical landmark. Based on the image, I can see architectural elements that suggest significant cultural and historical importance.\n\nTo provide you with more detailed information, could you tell me:\n• Where is this located?\n• Do you know the name of this place?\n\nOr feel free to ask me about any famous historical sites like the Great Wall of China, Taj Mahal, Egyptian Pyramids, Eiffel Tower, Colosseum, or other world-famous landmarks!";
  }

  String _getGenericResponse() {
    return "I'd be happy to help you learn about historical places! Here are some topics I can tell you about:\n\n• The Great Wall of China\n• Taj Mahal in India\n• Egyptian Pyramids\n• Colosseum in Rome\n• Eiffel Tower in Paris\n• Machu Picchu in Peru\n• Petra in Jordan\n\nYou can also upload a photo of any historical site, and I'll do my best to identify it and share its fascinating history with you!";
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
    messageController.dispose();
    scrollController.dispose();
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