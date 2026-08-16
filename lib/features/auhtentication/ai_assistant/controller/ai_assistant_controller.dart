// import 'dart:convert';

// import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
// import 'package:ai_powered_tourists_app/core/urls/urls.dart';
// import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/screen/last_ai_assistant.dart';
// import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class AiAssistantController extends GetxController {
//   final RxnString gender = RxnString();
//   final RxnString voice = RxnString();
//   final RxnString voiceType = RxnString();

//   void _syncToProfileController() {
//     try {
//       final profileController = Get.find<ProfileController>();
//       profileController.gender.value = gender.value;
//       profileController.voice.value = voice.value;
//       profileController.persistAiAssistantPreferences();
//     } catch (_) {
//       debugPrint('ProfileController not available yet; skipping sync');
//     }
//   }

//   void selectGender(String? g) {
//     gender.value = g;
//     if (g != null && g.isNotEmpty) {
//       Get.find<StorageService>().saveAiGender(g);
//     } else {
//       Get.find<StorageService>().removeAiGender();
//     }
//     _syncToProfileController();
//     debugPrint("🔵 Gender Selected: $g");
//   }

//   void selectVoice(String? v) {
//     voice.value = v;
//     if (v != null && v.isNotEmpty) {
//       Get.find<StorageService>().saveAiVoice(v);
//     } else {
//       Get.find<StorageService>().removeAiVoice();
//     }
//     _syncToProfileController();
//     debugPrint("🔵 Voice Selected: $v");
//   }

//   void selectVoiceType(String? t) {
//     voiceType.value = t;
//     try {
//       final profileController = Get.find<ProfileController>();
//       profileController.voiceTypes.clear();
//       if (t != null && t.isNotEmpty) {
//         profileController.voiceTypes.add(t);
//       }
//       profileController.persistAiAssistantPreferences();
//     } catch (_) {
//       debugPrint('ProfileController not available yet; skipping voice-type sync');
//     }
//     debugPrint(" Voice Type Selected: $t");
//   }

//   Future<void> createProfile() async {
//     debugPrint(" Create Profile Started");
//     debugPrint(" Gender: ${gender.value}");
//     debugPrint(" Voice: ${voice.value}");
//     debugPrint(" Voice Type: ${voiceType.value}");

//     if (gender.value == null ||
//         voice.value == null ||
//         voiceType.value == null) {
//       debugPrint(" Missing fields");
//       EasyLoading.showError("Please complete all selections");
//       return;
//     }

//     final body = {
//       "gender": gender.value!.toLowerCase(),
//       "ai_voice": voice.value!.toLowerCase(),
//       "ai_voice_type": voiceType.value!.toLowerCase(),
//     };

//     debugPrint("📤 API BODY: ${jsonEncode(body)}");

//     final accessToken = Get.find<StorageService>().getAccessToken();
//     if (accessToken == null) {
//       debugPrint(" No access token found");
//       EasyLoading.showError("Authentication required");
//       return;
//     }
//     debugPrint("🔑 Using Access Token: $accessToken");

//     try {
//       EasyLoading.show(status: "Creating Profile...");

//       final response = await http.post(
//         Uri.parse(Url.profilecreation),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $accessToken",
//         },
//         body: jsonEncode(body),
//       );

//       debugPrint("✅ Status Code: ${response.statusCode}");
//       debugPrint("✅ Response Body: ${response.body}");

//       EasyLoading.dismiss();

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         debugPrint("Profile Created Successfully");

//         // Remove temporary token after successful profile creation
//         // Try to extract and save user identifier from response (if present)
//         try {
//           final respData = jsonDecode(response.body);
//           if (respData is Map && respData['data'] != null) {
//             final d = respData['data'];
//             if (d is Map && d['user_identifier'] != null) {
//               final userId = d['user_identifier'].toString();
//               if (userId.isNotEmpty) {
//                 Get.find<StorageService>().saveUserIdentifier(userId);
//                 debugPrint(' Saved user_identifier from profile creation: $userId');
//               }
//             }
//           }
//         } catch (e) {
//           debugPrint('Could not parse/save user_identifier from profile response: $e');
//         }

//         Get.find<StorageService>().removeAccessToken();
//         debugPrint(
//           "🗑️ Temporary token removed - User must login to get permanent token",
//         );

//         EasyLoading.showSuccess("Profile Created!");
//         Get.to(() => LastAiAssistant());
//         return;
//       } else {
//         final data = jsonDecode(response.body);
//         debugPrint("❌ Profile Creation Failed: $data");
//         EasyLoading.showError(data["message"] ?? "Failed to create profile");
//       }
//     } catch (e, s) {
//       debugPrint(" ERROR: $e");
//       debugPrint(" STACK TRACE: $s");
//       EasyLoading.showError("Something went wrong");
//     }
//   }

//   void resetAll() {
//     gender.value = null;
//     voice.value = null;
//     voiceType.value = null;
//     Get.find<StorageService>().removeAiGender();
//     Get.find<StorageService>().removeAiVoice();
//     Get.find<StorageService>().removeAiVoiceTypes();
//     try {
//       final profileController = Get.find<ProfileController>();
//       profileController.gender.value = null;
//       profileController.voice.value = null;
//       profileController.voiceTypes.clear();
//       profileController.persistAiAssistantPreferences();
//     } catch (_) {
//       debugPrint('ProfileController not available yet; skipping reset sync');
//     }
//     debugPrint("All values reset");
//   }
// }
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

  StorageService get _storage => Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _loadSavedPreferences();
  }

  void _loadSavedPreferences() {
    gender.value = _storage.getAiGender();
    voice.value = _storage.getAiVoice();

    final savedVoiceTypes = _storage.getAiVoiceTypes();

    if (savedVoiceTypes.isNotEmpty) {
      voiceType.value = savedVoiceTypes.last;
    }

    debugPrint('📖 Saved gender loaded: ${gender.value}');
    debugPrint('📖 Saved voice loaded: ${voice.value}');
    debugPrint('📖 Saved voice type loaded: ${voiceType.value}');
  }

  void _syncToProfileController() {
    if (!Get.isRegistered<ProfileController>()) {
      debugPrint(
        'ProfileController is not registered; preference remains in storage',
      );
      return;
    }

    final profileController = Get.find<ProfileController>();

    profileController.gender.value = gender.value;
    profileController.voice.value = voice.value;

    profileController.voiceTypes.clear();

    final selectedType = voiceType.value;

    if (selectedType != null && selectedType.isNotEmpty) {
      profileController.voiceTypes.add(selectedType);
    }

    profileController.persistAiAssistantPreferences();

    debugPrint('✅ AI preferences synchronized with ProfileController');
  }

  void selectGender(String? selectedGender) {
    final normalizedGender = selectedGender?.trim().toLowerCase();

    gender.value = normalizedGender;

    if (normalizedGender == null || normalizedGender.isEmpty) {
      _storage.removeAiGender();
    } else {
      _storage.saveAiGender(normalizedGender);
    }

    _syncToProfileController();

    debugPrint('🔵 Gender selected: ${gender.value}');
  }

  void selectVoice(String? selectedVoice) {
    final normalizedVoice = selectedVoice?.trim().toLowerCase();

    voice.value = normalizedVoice;

    if (normalizedVoice == null || normalizedVoice.isEmpty) {
      _storage.removeAiVoice();
    } else {
      _storage.saveAiVoice(normalizedVoice);
    }

    _syncToProfileController();

    debugPrint('🔵 AI voice selected: ${voice.value}');
  }

  void selectVoiceType(String? selectedVoiceType) {
    final normalizedVoiceType = selectedVoiceType?.trim().toLowerCase();

    voiceType.value = normalizedVoiceType;

    if (normalizedVoiceType == null || normalizedVoiceType.isEmpty) {
      _storage.removeAiVoiceTypes();
    } else {
      _storage.saveAiVoiceTypes([normalizedVoiceType]);
    }

    _syncToProfileController();

    debugPrint('🔵 Voice type selected: ${voiceType.value}');
  }

  Future<void> createProfile() async {
    final selectedGender = gender.value?.trim().toLowerCase();
    final selectedVoice = voice.value?.trim().toLowerCase();
    final selectedVoiceType = voiceType.value?.trim().toLowerCase();

    debugPrint('🚀 Create profile started');
    debugPrint('Gender: $selectedGender');
    debugPrint('AI Voice: $selectedVoice');
    debugPrint('AI Voice Type: $selectedVoiceType');

    if (selectedGender == null ||
        selectedGender.isEmpty ||
        selectedVoice == null ||
        selectedVoice.isEmpty ||
        selectedVoiceType == null ||
        selectedVoiceType.isEmpty) {
      EasyLoading.showError('Please complete all selections');
      return;
    }

    final accessToken = _storage.getAccessToken();

    if (accessToken == null || accessToken.trim().isEmpty) {
      EasyLoading.showError('Authentication required');
      return;
    }

    final Map<String, dynamic> body = {
      'gender': selectedGender,
      'ai_voice': selectedVoice,
      'ai_voice_type': selectedVoiceType,
    };

    debugPrint('📤 Profile API body: ${jsonEncode(body)}');

    try {
      EasyLoading.show(status: 'Creating Profile...');

      final response = await http.post(
        Uri.parse(Url.profilecreation),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _handleProfileCreationSuccess(response);
        return;
      }

      final errorMessage = _getErrorMessage(response.body);

      EasyLoading.showError(errorMessage);
    } catch (error, stackTrace) {
      debugPrint('❌ Profile creation error: $error');
      debugPrint('Stack trace: $stackTrace');

      EasyLoading.showError('Something went wrong');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _handleProfileCreationSuccess(
    http.Response response,
  ) async {
    try {
      if (response.body.isNotEmpty) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          final responseData = decodedResponse['data'];

          if (responseData is Map) {
            final identifier = responseData['user_identifier']?.toString();

            if (identifier != null && identifier.isNotEmpty) {
              _storage.saveUserIdentifier(identifier);

              debugPrint(
                '✅ User identifier saved: $identifier',
              );
            }
          }
        }
      }
    } catch (error) {
      debugPrint(
        'Could not extract user identifier from response: $error',
      );
    }

    // Selections are already saved locally.
    _storage.saveAiGender(gender.value!);
    _storage.saveAiVoice(voice.value!);
    _storage.saveAiVoiceTypes([voiceType.value!]);

    // Keep this only if the registration flow requires login again.
    _storage.removeAccessToken();

    EasyLoading.showSuccess('Profile Created!');

    Get.to(() => LastAiAssistant());
  }

  String _getErrorMessage(String responseBody) {
    try {
      if (responseBody.isEmpty) {
        return 'Failed to create profile';
      }

      final decodedResponse = jsonDecode(responseBody);

      if (decodedResponse is Map) {
        return decodedResponse['message']?.toString() ??
            decodedResponse['detail']?.toString() ??
            'Failed to create profile';
      }

      return 'Failed to create profile';
    } catch (_) {
      return 'Failed to create profile';
    }
  }

  void resetAll() {
    gender.value = null;
    voice.value = null;
    voiceType.value = null;

    _storage.removeAiGender();
    _storage.removeAiVoice();
    _storage.removeAiVoiceTypes();

    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();

      profileController.gender.value = null;
      profileController.voice.value = null;
      profileController.voiceTypes.clear();
      profileController.persistAiAssistantPreferences();
    }

    debugPrint('✅ All AI assistant selections reset');
  }
}
