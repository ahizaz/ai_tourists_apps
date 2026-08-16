// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class StorageService extends GetxService {
//   late GetStorage _box;
//   static const String _profileImageBase64Key = 'profile_image_base64';
//   static const String _nearbyPlacesCacheKey = 'nearby_places_cache';
//   static const String _aiGenderKey = 'ai_gender';
//   static const String _aiVoiceKey = 'ai_voice';
//   static const String _aiVoiceTypesKey = 'ai_voice_types';

//   Future<StorageService> init() async {
//     await GetStorage.init();
//     _box = GetStorage();
//     return this;
//   }

//   void saveAccessToken(String token) {
//     _box.write('access_token', token);
//     debugPrint("💾 Access Token saved to SharedPreferences");
//   }

//   String? getAccessToken() {
//     final token = _box.read('access_token');
//     if (token != null) {
//       debugPrint("📖 Access Token retrieved from SharedPreferences: $token");
//     }
//     return token;
//   }

//   void removeAccessToken() {
//     _box.remove('access_token');
//     debugPrint("🗑️ Access Token removed from SharedPreferences");
//   }

//   // Refresh Token
//   void saveRefreshToken(String token) {
//     _box.write('refresh_token', token);
//     debugPrint("💾 Refresh Token saved to SharedPreferences");
//   }

//   String? getRefreshToken() {
//     return _box.read('refresh_token');
//   }

//   void removeRefreshToken() {
//     _box.remove('refresh_token');
//     debugPrint("🗑️ Refresh Token removed from SharedPreferences");
//   }

//   // User name storage
//   void saveUserName(String name) {
//     _box.write('user_name', name);
//     debugPrint("💾 User name saved to SharedPreferences: $name");
//   }

//   String? getUserName() {
//     final name = _box.read('user_name');
//     if (name != null) {
//       debugPrint("📖 User name retrieved from SharedPreferences: $name");
//     }
//     return name;
//   }

//   void removeUserName() {
//     _box.remove('user_name');
//     debugPrint("🗑️ User name removed from SharedPreferences");
//   }

//   // User email storage
//   void saveUserEmail(String email) {
//     _box.write('user_email', email);
//     debugPrint("💾 User email saved to SharedPreferences: $email");
//   }

//   String? getUserEmail() {
//     final email = _box.read('user_email');
//     if (email != null) {
//       debugPrint("📖 User email retrieved from SharedPreferences: $email");
//     }
//     return email;
//   }

//   void removeUserEmail() {
//     _box.remove('user_email');
//     debugPrint("🗑️ User email removed from SharedPreferences");
//   }

//   // User identifier (UUID or server-side id)
//   void saveUserIdentifier(String id) {
//     _box.write('user_identifier', id);
//     debugPrint("💾 User identifier saved to SharedPreferences: $id");
//   }

//   String? getUserIdentifier() {
//     final id = _box.read('user_identifier');
//     if (id != null) {
//       debugPrint("📖 User identifier retrieved from SharedPreferences: $id");
//     }
//     return id;
//   }

//   void removeUserIdentifier() {
//     _box.remove('user_identifier');
//     debugPrint("🗑️ User identifier removed from SharedPreferences");
//   }

//   // User Login Status
//   bool isLoggedIn() {
//     final token = getAccessToken();
//     return token != null && token.isNotEmpty;
//   }

//   // Logout - Clear all authentication data
//   void logout() {
//     debugPrint("🚪 Logout called - Removing all tokens");
//     removeAccessToken();
//     removeRefreshToken();
//     debugPrint("✅ Logout complete - User logged out");
//   }

//   void clearAll() {
//     _box.erase();
//   }

//   // Profile image persistence (web: localStorage via get_storage)
//   void saveProfileImageBase64(String base64) {
//     _box.write(_profileImageBase64Key, base64);
//     debugPrint("💾 Profile image saved to SharedPreferences");
//   }

//   String? getProfileImageBase64() {
//     return _box.read(_profileImageBase64Key);
//   }

//   void removeProfileImageBase64() {
//     _box.remove(_profileImageBase64Key);
//   }

//   void saveNearbyPlacesCache(String jsonString) {
//     _box.write(_nearbyPlacesCacheKey, jsonString);
//     debugPrint('💾 Nearby places cache saved');
//   }

//   String? getNearbyPlacesCache() {
//     return _box.read(_nearbyPlacesCacheKey);
//   }

//   void removeNearbyPlacesCache() {
//     _box.remove(_nearbyPlacesCacheKey);
//   }

//   void saveAiGender(String gender) {
//     _box.write(_aiGenderKey, gender);
//     debugPrint('💾 AI gender saved to SharedPreferences: $gender');
//   }

//   String? getAiGender() {
//     return _box.read(_aiGenderKey);
//   }

//   void removeAiGender() {
//     _box.remove(_aiGenderKey);
//   }

//   void saveAiVoice(String voice) {
//     _box.write(_aiVoiceKey, voice);
//     debugPrint('💾 AI voice saved to SharedPreferences: $voice');
//   }

//   String? getAiVoice() {
//     return _box.read(_aiVoiceKey);
//   }

//   void removeAiVoice() {
//     _box.remove(_aiVoiceKey);
//   }

//   void saveAiVoiceTypes(List<String> voiceTypes) {
//     _box.write(_aiVoiceTypesKey, voiceTypes);
//     debugPrint('💾 AI voice types saved to SharedPreferences: $voiceTypes');
//   }

//   List<String> getAiVoiceTypes() {
//     final stored = _box.read(_aiVoiceTypesKey);
//     if (stored is List) {
//       return stored.whereType<String>().toList();
//     }
//     return <String>[];
//   }

//   void removeAiVoiceTypes() {
//     _box.remove(_aiVoiceTypesKey);
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class StorageService extends GetxService {
//   late GetStorage _box;

//   static const String _accessTokenKey = 'access_token';
//   static const String _refreshTokenKey = 'refresh_token';
//   static const String _userNameKey = 'user_name';
//   static const String _userEmailKey = 'user_email';
//   static const String _userIdentifierKey = 'user_identifier';
//   static const String _profileImageBase64Key = 'profile_image_base64';
//   static const String _nearbyPlacesCacheKey = 'nearby_places_cache';
//   static const String _aiGenderKey = 'ai_gender';
//   static const String _aiVoiceKey = 'ai_voice';
//   static const String _aiVoiceTypesKey = 'ai_voice_types';

//   Future<StorageService> init() async {
//     await GetStorage.init();
//     _box = GetStorage();
//     return this;
//   }

//   // Access token
//   void saveAccessToken(String token) {
//     _box.write(_accessTokenKey, token);
//     debugPrint('💾 Access token saved');
//   }

//   String? getAccessToken() {
//     return _box.read<String>(_accessTokenKey);
//   }

//   void removeAccessToken() {
//     _box.remove(_accessTokenKey);
//     debugPrint('🗑️ Access token removed');
//   }

//   // Refresh token
//   void saveRefreshToken(String token) {
//     _box.write(_refreshTokenKey, token);
//     debugPrint('💾 Refresh token saved');
//   }

//   String? getRefreshToken() {
//     return _box.read<String>(_refreshTokenKey);
//   }

//   void removeRefreshToken() {
//     _box.remove(_refreshTokenKey);
//     debugPrint('🗑️ Refresh token removed');
//   }

//   // User name
//   void saveUserName(String name) {
//     _box.write(_userNameKey, name);
//     debugPrint('💾 User name saved: $name');
//   }

//   String? getUserName() {
//     return _box.read<String>(_userNameKey);
//   }

//   void removeUserName() {
//     _box.remove(_userNameKey);
//   }

//   // User email
//   void saveUserEmail(String email) {
//     _box.write(_userEmailKey, email);
//     debugPrint('💾 User email saved: $email');
//   }

//   String? getUserEmail() {
//     return _box.read<String>(_userEmailKey);
//   }

//   void removeUserEmail() {
//     _box.remove(_userEmailKey);
//   }

//   // User identifier
//   void saveUserIdentifier(String id) {
//     _box.write(_userIdentifierKey, id);
//     debugPrint('💾 User identifier saved: $id');
//   }

//   String? getUserIdentifier() {
//     return _box.read<String>(_userIdentifierKey);
//   }

//   void removeUserIdentifier() {
//     _box.remove(_userIdentifierKey);
//   }

//   // Login status
//   bool isLoggedIn() {
//     final token = getAccessToken();
//     return token != null && token.trim().isNotEmpty;
//   }

//   // Logout
//   void logout() {
//     debugPrint('🚪 Logout called');

//     removeAccessToken();
//     removeRefreshToken();

//     debugPrint('✅ Logout complete');
//   }

//   void clearAll() {
//     _box.erase();
//     debugPrint('🗑️ All local data cleared');
//   }

//   // Profile image
//   void saveProfileImageBase64(String base64) {
//     _box.write(_profileImageBase64Key, base64);
//     debugPrint('💾 Profile image saved');
//   }

//   String? getProfileImageBase64() {
//     return _box.read<String>(_profileImageBase64Key);
//   }

//   void removeProfileImageBase64() {
//     _box.remove(_profileImageBase64Key);
//   }

//   // Nearby places cache
//   void saveNearbyPlacesCache(String jsonString) {
//     _box.write(_nearbyPlacesCacheKey, jsonString);
//     debugPrint('💾 Nearby places cache saved');
//   }

//   String? getNearbyPlacesCache() {
//     return _box.read<String>(_nearbyPlacesCacheKey);
//   }

//   void removeNearbyPlacesCache() {
//     _box.remove(_nearbyPlacesCacheKey);
//   }

//   // AI gender
//   void saveAiGender(String gender) {
//     final normalizedGender = gender.trim().toLowerCase();

//     _box.write(_aiGenderKey, normalizedGender);
//     debugPrint('💾 AI gender saved: $normalizedGender');
//   }

//   String? getAiGender() {
//     return _box.read<String>(_aiGenderKey);
//   }

//   void removeAiGender() {
//     _box.remove(_aiGenderKey);
//     debugPrint('🗑️ AI gender removed');
//   }

//   // AI voice
//   void saveAiVoice(String voice) {
//     final normalizedVoice = voice.trim().toLowerCase();

//     _box.write(_aiVoiceKey, normalizedVoice);
//     debugPrint('💾 AI voice saved: $normalizedVoice');
//   }

//   String? getAiVoice() {
//     return _box.read<String>(_aiVoiceKey);
//   }

//   void removeAiVoice() {
//     _box.remove(_aiVoiceKey);
//     debugPrint('🗑️ AI voice removed');
//   }

//   // AI voice types
//   void saveAiVoiceTypes(List<String> voiceTypes) {
//     final normalizedVoiceTypes = voiceTypes
//         .map((voiceType) => voiceType.trim().toLowerCase())
//         .where((voiceType) => voiceType.isNotEmpty)
//         .toList();

//     _box.write(_aiVoiceTypesKey, normalizedVoiceTypes);

//     debugPrint('💾 AI voice types saved: $normalizedVoiceTypes');
//   }

//   List<String> getAiVoiceTypes() {
//     final storedData = _box.read(_aiVoiceTypesKey);

//     if (storedData is List) {
//       return storedData
//           .whereType<String>()
//           .map((voiceType) => voiceType.trim().toLowerCase())
//           .where((voiceType) => voiceType.isNotEmpty)
//           .toList();
//     }

//     return <String>[];
//   }

//   void removeAiVoiceTypes() {
//     _box.remove(_aiVoiceTypesKey);
//     debugPrint('🗑️ AI voice types removed');
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userIdentifierKey = 'user_identifier';
  static const String _profileImageBase64Key =
      'profile_image_base64';
  static const String _nearbyPlacesCacheKey =
      'nearby_places_cache';
  static const String _aiGenderKey = 'ai_gender';
  static const String _aiVoiceKey = 'ai_voice';
  static const String _aiVoiceTypesKey = 'ai_voice_types';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  void saveAccessToken(String token) {
    _box.write(_accessTokenKey, token);
    debugPrint('💾 Access token saved');
  }

  String? getAccessToken() {
    return _box.read<String>(_accessTokenKey);
  }

  void removeAccessToken() {
    _box.remove(_accessTokenKey);
  }

  void saveRefreshToken(String token) {
    _box.write(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _box.read<String>(_refreshTokenKey);
  }

  void removeRefreshToken() {
    _box.remove(_refreshTokenKey);
  }

  void saveUserName(String name) {
    _box.write(_userNameKey, name);
  }

  String? getUserName() {
    return _box.read<String>(_userNameKey);
  }

  void removeUserName() {
    _box.remove(_userNameKey);
  }

  void saveUserEmail(String email) {
    _box.write(_userEmailKey, email);
  }

  String? getUserEmail() {
    return _box.read<String>(_userEmailKey);
  }

  void removeUserEmail() {
    _box.remove(_userEmailKey);
  }

  void saveUserIdentifier(String id) {
    _box.write(_userIdentifierKey, id);
  }

  String? getUserIdentifier() {
    return _box.read<String>(_userIdentifierKey);
  }

  void removeUserIdentifier() {
    _box.remove(_userIdentifierKey);
  }

  bool isLoggedIn() {
    final token = getAccessToken();
    return token != null && token.trim().isNotEmpty;
  }

  void logout() {
    removeAccessToken();
    removeRefreshToken();
  }

  void clearAll() {
    _box.erase();
  }

  void saveProfileImageBase64(String base64) {
    _box.write(_profileImageBase64Key, base64);
  }

  String? getProfileImageBase64() {
    return _box.read<String>(_profileImageBase64Key);
  }

  void removeProfileImageBase64() {
    _box.remove(_profileImageBase64Key);
  }

  void saveNearbyPlacesCache(String jsonString) {
    _box.write(_nearbyPlacesCacheKey, jsonString);
  }

  String? getNearbyPlacesCache() {
    return _box.read<String>(_nearbyPlacesCacheKey);
  }

  void removeNearbyPlacesCache() {
    _box.remove(_nearbyPlacesCacheKey);
  }

  void saveAiGender(String gender) {
    final value = gender.trim().toLowerCase();

    _box.write(_aiGenderKey, value);
    debugPrint('💾 AI gender saved: $value');
  }

  String? getAiGender() {
    final value = _box.read<String>(_aiGenderKey);
    return value?.trim().toLowerCase();
  }

  void removeAiGender() {
    _box.remove(_aiGenderKey);
  }

  void saveAiVoice(String voice) {
    final value = voice.trim().toLowerCase();

    _box.write(_aiVoiceKey, value);
    debugPrint('💾 AI voice saved: $value');
  }

  String? getAiVoice() {
    final value = _box.read<String>(_aiVoiceKey);
    return value?.trim().toLowerCase();
  }

  void removeAiVoice() {
    _box.remove(_aiVoiceKey);
  }

  void saveAiVoiceTypes(List<String> voiceTypes) {
    final values = voiceTypes
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toList();

    _box.write(_aiVoiceTypesKey, values);
    debugPrint('💾 AI voice types saved: $values');
  }

  List<String> getAiVoiceTypes() {
    final storedData = _box.read(_aiVoiceTypesKey);

    if (storedData is List) {
      return storedData
          .whereType<String>()
          .map((item) => item.trim().toLowerCase())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return <String>[];
  }

  void removeAiVoiceTypes() {
    _box.remove(_aiVoiceTypesKey);
  }
}