import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/last_ai_assistant.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiAssistantController extends GetxController {
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxnString voiceType = RxnString();

  void _syncToProfileController() {
    try {
      final profileController = Get.find<ProfileController>();
      profileController.gender.value = gender.value;
      profileController.voice.value = voice.value;
      profileController.persistAiAssistantPreferences();
    } catch (_) {
      debugPrint('ProfileController not available yet; skipping sync');
    }
  }

  void selectGender(String? g) {
    gender.value = g;
    if (g != null && g.isNotEmpty) {
      Get.find<StorageService>().saveAiGender(g);
    } else {
      Get.find<StorageService>().removeAiGender();
    }
    _syncToProfileController();
    debugPrint("🔵 Gender Selected: $g");
  }

  void selectVoice(String? v) {
    voice.value = v;
    if (v != null && v.isNotEmpty) {
      Get.find<StorageService>().saveAiVoice(v);
    } else {
      Get.find<StorageService>().removeAiVoice();
    }
    _syncToProfileController();
    debugPrint("🔵 Voice Selected: $v");
  }

  void selectVoiceType(String? t) {
    voiceType.value = t;
    try {
      final profileController = Get.find<ProfileController>();
      profileController.voiceTypes.clear();
      if (t != null && t.isNotEmpty) {
        profileController.voiceTypes.add(t);
      }
      profileController.persistAiAssistantPreferences();
    } catch (_) {
      debugPrint('ProfileController not available yet; skipping voice-type sync');
    }
    debugPrint(" Voice Type Selected: $t");
  }

  Future<void> createProfile() async {
    debugPrint(" Create Profile Started");
    debugPrint(" Gender: ${gender.value}");
    debugPrint(" Voice: ${voice.value}");
    debugPrint(" Voice Type: ${voiceType.value}");

    if (gender.value == null ||
        voice.value == null ||
        voiceType.value == null) {
      debugPrint(" Missing fields");
      EasyLoading.showError("Please complete all selections");
      return;
    }

    final body = {
      "gender": gender.value!.toLowerCase(),
      "ai_voice": voice.value!.toLowerCase(),
      "ai_voice_type": voiceType.value!.toLowerCase(),
    };

    debugPrint("📤 API BODY: ${jsonEncode(body)}");

    final accessToken = Get.find<StorageService>().getAccessToken();
    if (accessToken == null) {
      debugPrint(" No access token found");
      EasyLoading.showError("Authentication required");
      return;
    }
    debugPrint("🔑 Using Access Token: $accessToken");

    try {
      EasyLoading.show(status: "Creating Profile...");

      final response = await http.post(
        Uri.parse(Url.profilecreation),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );

      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("✅ Response Body: ${response.body}");

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Profile Created Successfully");

        // Remove temporary token after successful profile creation
        // Try to extract and save user identifier from response (if present)
        try {
          final respData = jsonDecode(response.body);
          if (respData is Map && respData['data'] != null) {
            final d = respData['data'];
            if (d is Map && d['user_identifier'] != null) {
              final userId = d['user_identifier'].toString();
              if (userId.isNotEmpty) {
                Get.find<StorageService>().saveUserIdentifier(userId);
                debugPrint(' Saved user_identifier from profile creation: $userId');
              }
            }
          }
        } catch (e) {
          debugPrint('Could not parse/save user_identifier from profile response: $e');
        }

        Get.find<StorageService>().removeAccessToken();
        debugPrint(
          "🗑️ Temporary token removed - User must login to get permanent token",
        );

        EasyLoading.showSuccess("Profile Created!");
        Get.to(() => LastAiAssistant());
        return;
      } else {
        final data = jsonDecode(response.body);
        debugPrint("❌ Profile Creation Failed: $data");
        EasyLoading.showError(data["message"] ?? "Failed to create profile");
      }
    } catch (e, s) {
      debugPrint(" ERROR: $e");
      debugPrint(" STACK TRACE: $s");
      EasyLoading.showError("Something went wrong");
    }
  }

  void resetAll() {
    gender.value = null;
    voice.value = null;
    voiceType.value = null;
    Get.find<StorageService>().removeAiGender();
    Get.find<StorageService>().removeAiVoice();
    Get.find<StorageService>().removeAiVoiceTypes();
    try {
      final profileController = Get.find<ProfileController>();
      profileController.gender.value = null;
      profileController.voice.value = null;
      profileController.voiceTypes.clear();
      profileController.persistAiAssistantPreferences();
    } catch (_) {
      debugPrint('ProfileController not available yet; skipping reset sync');
    }
    debugPrint("All values reset");
  }
}
