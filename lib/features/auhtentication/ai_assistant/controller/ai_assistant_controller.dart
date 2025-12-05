
import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/last_ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiAssistantController extends GetxController {
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxnString voiceType = RxnString();

  void selectGender(String? g) {
    gender.value = g;
    debugPrint("🔵 Gender Selected: $g");
  }

  void selectVoice(String? v) {
    voice.value = v;
    debugPrint("🔵 Voice Selected: $v");
  }

  void selectVoiceType(String? t) {
    voiceType.value = t;
    debugPrint("🔵 Voice Type Selected: $t");
  }

  Future<void> createProfile() async {
    debugPrint("🚀 Create Profile Started");
    debugPrint("📤 Gender: ${gender.value}");
    debugPrint("📤 Voice: ${voice.value}");
    debugPrint("📤 Voice Type: ${voiceType.value}");

    if (gender.value == null || voice.value == null || voiceType.value == null) {
      debugPrint("❌ Missing fields");
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
      debugPrint("❌ No access token found");
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
        debugPrint("🎉 Profile Created Successfully");
        EasyLoading.showSuccess("Profile Created!");
        Get.to(()=>LastAiAssistant());
        return;
      } else {
        final data = jsonDecode(response.body);
        debugPrint("❌ Profile Creation Failed: $data");
        EasyLoading.showError(data["message"] ?? "Failed to create profile");
      }
    } catch (e, s) {
      debugPrint("🔥 ERROR: $e");
      debugPrint("📛 STACK TRACE: $s");
      EasyLoading.showError("Something went wrong");
    }
  }

  void resetAll() {
    gender.value = null;
    voice.value = null;
    voiceType.value = null;
    debugPrint("🔄 All values reset");
  }
}