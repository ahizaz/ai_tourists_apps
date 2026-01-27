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

  // User name storage
  void saveUserName(String name) {
    _box.write('user_name', name);
    debugPrint("💾 User name saved to SharedPreferences: $name");
  }

  String? getUserName() {
    final name = _box.read('user_name');
    if (name != null) {
      debugPrint("📖 User name retrieved from SharedPreferences: $name");
    }
    return name;
  }

  void removeUserName() {
    _box.remove('user_name');
    debugPrint("🗑️ User name removed from SharedPreferences");
  }

  // User email storage
  void saveUserEmail(String email) {
    _box.write('user_email', email);
    debugPrint("💾 User email saved to SharedPreferences: $email");
  }

  String? getUserEmail() {
    final email = _box.read('user_email');
    if (email != null) {
      debugPrint("📖 User email retrieved from SharedPreferences: $email");
    }
    return email;
  }

  void removeUserEmail() {
    _box.remove('user_email');
    debugPrint("🗑️ User email removed from SharedPreferences");
  }

  // User identifier (UUID or server-side id)
  void saveUserIdentifier(String id) {
    _box.write('user_identifier', id);
    debugPrint("💾 User identifier saved to SharedPreferences: $id");
  }

  String? getUserIdentifier() {
    final id = _box.read('user_identifier');
    if (id != null) {
      debugPrint("📖 User identifier retrieved from SharedPreferences: $id");
    }
    return id;
  }

  void removeUserIdentifier() {
    _box.remove('user_identifier');
    debugPrint("🗑️ User identifier removed from SharedPreferences");
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
