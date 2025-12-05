import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  void saveAccessToken(String token) {
    _box.write('access_token', token);
    debugPrint("💾 Access Token saved to SharedPreferences");
  }

  String? getAccessToken() {
    final token = _box.read('access_token');
    if (token != null) {
      debugPrint("📖 Access Token retrieved from SharedPreferences: $token");
    }
    return token;
  }

  void removeAccessToken() {
    _box.remove('access_token');
    debugPrint("🗑️ Access Token removed from SharedPreferences");
  }

  // Refresh Token
  void saveRefreshToken(String token) {
    _box.write('refresh_token', token);
    debugPrint("💾 Refresh Token saved to SharedPreferences");
  }

  String? getRefreshToken() {
    return _box.read('refresh_token');
  }

  void removeRefreshToken() {
    _box.remove('refresh_token');
    debugPrint("🗑️ Refresh Token removed from SharedPreferences");
  }

  // User Login Status
  bool isLoggedIn() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Logout - Clear all authentication data
  void logout() {
    debugPrint("🚪 Logout called - Removing all tokens");
    removeAccessToken();
    removeRefreshToken();
    debugPrint("✅ Logout complete - User logged out");
  }

  void clearAll() {
    _box.erase();
  }
}
