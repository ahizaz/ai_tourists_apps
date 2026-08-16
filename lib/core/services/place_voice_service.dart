// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:ai_powered_tourists_app/core/services/storage_service.dart';

// import '../urls/urls.dart';

// class PlaceVoiceService {
//   static final AudioPlayer _player = AudioPlayer();

//   /// Call the place-voice API and play the returned audio (if any).
//   ///
//   /// Parameters:
//   /// - `resolvedPlace`: the current/resolved place (e.g. from GPS)
//   /// - `selectedPlace`: the place selected by the user in the app
//   static Future<void> fetchAndPlay({
//     required String resolvedPlace,
//     String? selectedPlace,
//     String? userIdentifier,
//     String? aiVoice,
//     String? aiVoiceType,
//     String? gender,
//   }) async {
//     try {
//       EasyLoading.show(status: 'Generating voice...');

//       debugPrint('PlaceVoiceService: resolvedPlace="$resolvedPlace" selectedPlace="$selectedPlace" userIdentifier="$userIdentifier"');

//       final body = <String, dynamic>{
//         'resolved_place': resolvedPlace,
//       };

//       if (userIdentifier != null && userIdentifier.isNotEmpty) {
//         body['user_identifier'] = userIdentifier;
//       } else if (selectedPlace != null && selectedPlace.isNotEmpty) {
//         body['selected_place'] = selectedPlace;
//       }

//       // Include optional AI voice/gender parameters if provided
//       if (aiVoice != null && aiVoice.isNotEmpty) {
//         body['ai_voice'] = aiVoice.toLowerCase();
//       }
//       if (aiVoiceType != null && aiVoiceType.isNotEmpty) {
//         body['ai_voice_type'] = aiVoiceType.toLowerCase();
//       }
//       if (gender != null && gender.isNotEmpty) {
//         body['gender'] = gender.toLowerCase();
//       }

//       debugPrint('PlaceVoiceService: request body -> ${jsonEncode(body)}');

//       final accessToken = Get.find<StorageService>().getAccessToken();
//       final headers = <String, String>{'Content-Type': 'application/json'};
//       if (accessToken != null && accessToken.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $accessToken';
//       }

//       debugPrint('PlaceVoiceService: request headers -> $headers');
//       final resp = await http.post(
//         Uri.parse(Url.placeVoice),
//         headers: headers,
//         body: jsonEncode(body),
//       );

//       debugPrint('placeVoice response: ${resp.statusCode} ${resp.body}');
//       debugPrint('placeVoice headers: ${resp.headers}');

//       if (resp.statusCode != 200) {
//         EasyLoading.showError('Server error: ${resp.statusCode}');
//         return;
//       }

//       final Map<String, dynamic> data = jsonDecode(resp.body);

//       // If the API returns wiki_text, log it for debugging.
//       if (data.containsKey('wiki_text')) {
//         debugPrint('wiki_text: ${data['wiki_text']}');
//       }

//       String? audioPath;
//       if (data.containsKey('audio_url')) {
//         audioPath = data['audio_url'] as String?;
//       }

//       // If the server returned wiki_text but didn't provide audio_url,
//       // we MUST NOT resend wiki_text from the client. Return gracefully.
//       if ((audioPath == null || audioPath.isEmpty) && data.containsKey('wiki_text')) {
//         debugPrint('Server returned wiki_text but no audio_url; not resending wiki_text from client.');
//         EasyLoading.showError('Server needs wiki_text to generate audio (server-side).');
//         return;
//       }

//       if (audioPath == null || audioPath.isEmpty) {
//         EasyLoading.showError('No audio returned from server');
//         return;
//       }

//       // Resolve relative audio path against baseUrl
//       final audioUrl = Uri.parse(Url.baseUrl).resolve(audioPath).toString();
//       debugPrint('Resolved audio URL: $audioUrl');

//       // Quick HEAD check to verify the audio is reachable and content-type
//       try {
//         final headResp = await http.head(Uri.parse(audioUrl));
//         debugPrint('Audio HEAD: ${headResp.statusCode} headers=${headResp.headers}');
//         final ct = headResp.headers['content-type'] ?? 'unknown';
//         if (headResp.statusCode != 200) {
//           debugPrint('Audio HEAD returned ${headResp.statusCode}; attempting to GET and stream anyway');
//         } else if (!ct.startsWith('audio/') && !ct.contains('mpeg') && !ct.contains('mp3')) {
//           debugPrint('Audio content-type looks unexpected: $ct');
//         }
//       } catch (e) {
//         debugPrint('HEAD request failed for audio URL: $e');
//       }

//       await _player.setUrl(audioUrl);
//       // Ensure maximum player volume (0.0 - 1.0)
//       try {
//         await _player.setVolume(1.0);
//         debugPrint('PlaceVoiceService: set player volume to 1.0');
//       } catch (e) {
//         debugPrint('PlaceVoiceService: setVolume failed: $e');
//       }
//       EasyLoading.showSuccess('Playing audio');
//       await _player.play();
//       EasyLoading.dismiss();
//     } catch (e, st) {
//       debugPrint('Error in PlaceVoiceService.fetchAndPlay: $e\n$st');
//       EasyLoading.showError('Failed to generate/play voice');
//     }
//   }

//   /// Fetches the audio URL for the given place parameters without playing it.
//   /// Returns the full resolved audio URL (absolute) or `null` if none.
//   static Future<String?> fetchAudioUrl({
//     required String resolvedPlace,
//     String? selectedPlace,
//     String? userIdentifier,
//     String? aiVoice,
//     String? aiVoiceType,
//     String? gender,
//   }) async {
//     try {
//       EasyLoading.show(status: 'Generating voice...');

//       debugPrint('PlaceVoiceService.fetchAudioUrl: resolvedPlace="$resolvedPlace" selectedPlace="$selectedPlace" userIdentifier="$userIdentifier"');

//       final body = <String, dynamic>{
//         'resolved_place': resolvedPlace,
//       };
//       if (userIdentifier != null && userIdentifier.isNotEmpty) {
//         body['user_identifier'] = userIdentifier;
//       } else if (selectedPlace != null && selectedPlace.isNotEmpty) {
//         body['selected_place'] = selectedPlace;
//       }

//       // Include optional AI voice/gender parameters if provided
//       if (aiVoice != null && aiVoice.isNotEmpty) {
//         body['ai_voice'] = aiVoice.toLowerCase();
//       }
//       if (aiVoiceType != null && aiVoiceType.isNotEmpty) {
//         body['ai_voice_type'] = aiVoiceType.toLowerCase();
//       }
//       if (gender != null && gender.isNotEmpty) {
//         body['gender'] = gender.toLowerCase();
//       }

//       final accessToken = Get.find<StorageService>().getAccessToken();
//       final headers = <String, String>{'Content-Type': 'application/json'};
//       if (accessToken != null && accessToken.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $accessToken';
//       }

//       debugPrint('PlaceVoiceService: request headers -> $headers');
//       final resp = await http.post(
//         Uri.parse(Url.placeVoice),
//         headers: headers,
//         body: jsonEncode(body),
//       );

//       debugPrint('placeVoice response: ${resp.statusCode} ${resp.body}');
//       debugPrint('placeVoice headers: ${resp.headers}');

//       if (resp.statusCode != 200) {
//         EasyLoading.showError('Server error: ${resp.statusCode}');
//         return null;
//       }

//       final Map<String, dynamic> data = jsonDecode(resp.body);

//       if (data.containsKey('wiki_text')) {
//         debugPrint('wiki_text: ${data['wiki_text']}');
//       }

//       String? audioPath;
//       if (data.containsKey('audio_url')) audioPath = data['audio_url'] as String?;

//       // If the server returned wiki_text but no audio_url, do not resend wiki_text.
//       if ((audioPath == null || audioPath.isEmpty) && data.containsKey('wiki_text')) {
//         debugPrint('Server returned wiki_text but no audio_url; client will not send wiki_text.');
//         EasyLoading.showError('Server requires wiki_text to generate audio (server-side).');
//         return null;
//       }

//       if (audioPath == null || audioPath.isEmpty) {
//         EasyLoading.showError('No audio returned from server');
//         return null;
//       }

//       final audioUrl = Uri.parse(Url.baseUrl).resolve(audioPath).toString();
//       debugPrint('Resolved audio URL: $audioUrl');

//       // HEAD check
//       try {
//         final headResp = await http.head(Uri.parse(audioUrl));
//         debugPrint('Audio HEAD: ${headResp.statusCode} headers=${headResp.headers}');
//       } catch (e) {
//         debugPrint('HEAD request failed for audio URL: $e');
//       }

//       EasyLoading.dismiss();
//       return audioUrl;
//     } catch (e, st) {
//       debugPrint('Error in PlaceVoiceService.fetchAudioUrl: $e\n$st');
//       EasyLoading.showError('Failed to generate voice');
//       return null;
//     }
//   }

//   static Future<void> stop() async {
//     try {
//       await _player.stop();
//     } catch (e) {
//       debugPrint('Error stopping audio player: $e');
//     }
//   }
// }

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
