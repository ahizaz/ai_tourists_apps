

import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class PlaceVoiceService {
  static final AudioPlayer _player = AudioPlayer();

  static StorageService get _storage {
    return Get.find<StorageService>();
  }

  static String? _normalize(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static Map<String, dynamic> _createBody({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
    String? aiVoice,
    String? aiVoiceType,
    String? gender,
  }) {
    final storedGender = _normalize(_storage.getAiGender());

    final storedVoice = _normalize(_storage.getAiVoice());

    final storedVoiceTypes = _storage.getAiVoiceTypes();

    // Storage-এর latest selection priority পাবে।
    final effectiveGender = storedGender ?? _normalize(gender) ?? 'female';

    final effectiveVoice = storedVoice ?? _normalize(aiVoice);

    final effectiveVoiceType = storedVoiceTypes.isNotEmpty
        ? _normalize(storedVoiceTypes.last)
        : _normalize(aiVoiceType);

    final body = <String, dynamic>{
      'resolved_place': resolvedPlace.trim(),
      'gender': effectiveGender,
    };

    final identifier = userIdentifier?.trim();

    final place = selectedPlace?.trim();

    if (identifier != null && identifier.isNotEmpty) {
      body['user_identifier'] = identifier;
    } else if (place != null && place.isNotEmpty) {
      body['selected_place'] = place;
    }

    if (effectiveVoice != null) {
      body['ai_voice'] = effectiveVoice;
    }

    if (effectiveVoiceType != null) {
      body['ai_voice_type'] = effectiveVoiceType;
    }

    debugPrint('============================');
    debugPrint('🎙️ Effective gender: $effectiveGender');
    debugPrint('🎙️ Effective voice: $effectiveVoice');
    debugPrint('🎙️ Effective type: $effectiveVoiceType');
    debugPrint('📤 Request body: ${jsonEncode(body)}');
    debugPrint('============================');

    return body;
  }

  static Map<String, String> _createHeaders() {
    final token = _storage.getAccessToken();

    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    return headers;
  }

  static String? _getAudioPath(Map<String, dynamic> data) {
    final value = data['audio_url'];

    if (value == null) {
      return null;
    }

    final audioPath = value.toString().trim();

    return audioPath.isEmpty ? null : audioPath;
  }

  static String _resolveAudioUrl(String audioPath) {
    return Uri.parse(Url.baseUrl).resolve(audioPath).toString();
  }

  static Future<void> _checkAudio(String audioUrl) async {
    if (kIsWeb) {
      return;
    }

    try {
      final response = await http.head(Uri.parse(audioUrl));

      debugPrint('Audio HEAD status: ${response.statusCode}');

      debugPrint(
        'Audio content type: '
        '${response.headers['content-type']}',
      );
    } catch (error) {
      debugPrint('Audio HEAD failed: $error');
    }
  }

  static Future<String?> _requestAudioUrl({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
    String? aiVoice,
    String? aiVoiceType,
    String? gender,
  }) async {
    final body = _createBody(
      resolvedPlace: resolvedPlace,
      selectedPlace: selectedPlace,
      userIdentifier: userIdentifier,
      aiVoice: aiVoice,
      aiVoiceType: aiVoiceType,
      gender: gender,
    );

    final response = await http.post(
      Uri.parse(Url.placeVoice),
      headers: _createHeaders(),
      body: jsonEncode(body),
    );

    debugPrint('Place voice status: ${response.statusCode}');

    debugPrint('Place voice response: ${response.body}');

    if (response.statusCode != 200) {
      EasyLoading.showError('Server error: ${response.statusCode}');
      return null;
    }

    final decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map) {
      EasyLoading.showError('Invalid server response');
      return null;
    }

    final data = Map<String, dynamic>.from(decodedResponse);

    if (data.containsKey('wiki_text')) {
      debugPrint('Wiki text: ${data['wiki_text']}');
    }

    final audioPath = _getAudioPath(data);

    if (audioPath == null || audioPath.isEmpty) {
      EasyLoading.showError('No audio returned from server');
      return null;
    }

    final audioUrl = _resolveAudioUrl(audioPath);

    debugPrint('🔊 Resolved audio URL: $audioUrl');

    await _checkAudio(audioUrl);

    return audioUrl;
  }

  static Future<void> fetchAndPlay({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
    String? aiVoice,
    String? aiVoiceType,
    String? gender,
  }) async {
    try {
      EasyLoading.show(status: 'Generating voice...');

      final audioUrl = await _requestAudioUrl(
        resolvedPlace: resolvedPlace,
        selectedPlace: selectedPlace,
        userIdentifier: userIdentifier,
        aiVoice: aiVoice,
        aiVoiceType: aiVoiceType,
        gender: gender,
      );

      if (audioUrl == null) {
        return;
      }

      await _player.stop();
      await _player.setUrl(audioUrl);
      await _player.setVolume(1.0);

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Playing audio');

      await _player.play();
    } catch (error, stackTrace) {
      debugPrint(
        'PlaceVoiceService.fetchAndPlay '
        'error: $error',
      );

      debugPrint('Stack trace: $stackTrace');

      EasyLoading.showError('Failed to generate/play voice');
    }
  }

  static Future<String?> fetchAudioUrl({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
    String? aiVoice,
    String? aiVoiceType,
    String? gender,
  }) async {
    try {
      EasyLoading.show(status: 'Generating voice...');

      final audioUrl = await _requestAudioUrl(
        resolvedPlace: resolvedPlace,
        selectedPlace: selectedPlace,
        userIdentifier: userIdentifier,
        aiVoice: aiVoice,
        aiVoiceType: aiVoiceType,
        gender: gender,
      );

      EasyLoading.dismiss();

      return audioUrl;
    } catch (error, stackTrace) {
      debugPrint(
        'PlaceVoiceService.fetchAudioUrl '
        'error: $error',
      );

      debugPrint('Stack trace: $stackTrace');

      EasyLoading.showError('Failed to generate voice');

      return null;
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (error) {
      debugPrint('Error stopping audio: $error');
    }
  }

  static Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (error) {
      debugPrint('Error disposing audio player: $error');
    }
  }
}
