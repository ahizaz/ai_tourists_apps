import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';

import '../urls/urls.dart';

class PlaceVoiceService {
  static final AudioPlayer _player = AudioPlayer();

  /// Call the place-voice API and play the returned audio (if any).
  ///
  /// Parameters:
  /// - `resolvedPlace`: the current/resolved place (e.g. from GPS)
  /// - `selectedPlace`: the place selected by the user in the app
  static Future<void> fetchAndPlay({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
  }) async {
    try {
      EasyLoading.show(status: 'Generating voice...');

      debugPrint('PlaceVoiceService: resolvedPlace="$resolvedPlace" selectedPlace="$selectedPlace" userIdentifier="$userIdentifier"');

      final body = <String, dynamic>{
        'resolved_place': resolvedPlace,
      };

      if (userIdentifier != null && userIdentifier.isNotEmpty) {
        body['user_identifier'] = userIdentifier;
      } else if (selectedPlace != null && selectedPlace.isNotEmpty) {
        body['selected_place'] = selectedPlace;
      }

      debugPrint('PlaceVoiceService: request body -> ${jsonEncode(body)}');

      final accessToken = Get.find<StorageService>().getAccessToken();
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      debugPrint('PlaceVoiceService: request headers -> $headers');
      final resp = await http.post(
        Uri.parse(Url.placeVoice),
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint('placeVoice response: ${resp.statusCode} ${resp.body}');
      debugPrint('placeVoice headers: ${resp.headers}');

      if (resp.statusCode != 200) {
        EasyLoading.showError('Server error: ${resp.statusCode}');
        return;
      }

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // If the API returns wiki_text, log it for debugging.
      if (data.containsKey('wiki_text')) {
        debugPrint('wiki_text: ${data['wiki_text']}');
      }

      String? audioPath;
      if (data.containsKey('audio_url')) {
        audioPath = data['audio_url'] as String?;
      }

      // If the server returned wiki_text but didn't provide audio_url,
      // we MUST NOT resend wiki_text from the client. Return gracefully.
      if ((audioPath == null || audioPath.isEmpty) && data.containsKey('wiki_text')) {
        debugPrint('Server returned wiki_text but no audio_url; not resending wiki_text from client.');
        EasyLoading.showError('Server needs wiki_text to generate audio (server-side).');
        return;
      }

      if (audioPath == null || audioPath.isEmpty) {
        EasyLoading.showError('No audio returned from server');
        return;
      }

      // Resolve relative audio path against baseUrl
      final audioUrl = Uri.parse(Url.baseUrl).resolve(audioPath).toString();
      debugPrint('Resolved audio URL: $audioUrl');

      // Quick HEAD check to verify the audio is reachable and content-type
      try {
        final headResp = await http.head(Uri.parse(audioUrl));
        debugPrint('Audio HEAD: ${headResp.statusCode} headers=${headResp.headers}');
        final ct = headResp.headers['content-type'] ?? 'unknown';
        if (headResp.statusCode != 200) {
          debugPrint('Audio HEAD returned ${headResp.statusCode}; attempting to GET and stream anyway');
        } else if (!ct.startsWith('audio/') && !ct.contains('mpeg') && !ct.contains('mp3')) {
          debugPrint('Audio content-type looks unexpected: $ct');
        }
      } catch (e) {
        debugPrint('HEAD request failed for audio URL: $e');
      }

      await _player.setUrl(audioUrl);
      // Ensure maximum player volume (0.0 - 1.0)
      try {
        await _player.setVolume(1.0);
        debugPrint('PlaceVoiceService: set player volume to 1.0');
      } catch (e) {
        debugPrint('PlaceVoiceService: setVolume failed: $e');
      }
      EasyLoading.showSuccess('Playing audio');
      await _player.play();
      EasyLoading.dismiss();
    } catch (e, st) {
      debugPrint('Error in PlaceVoiceService.fetchAndPlay: $e\n$st');
      EasyLoading.showError('Failed to generate/play voice');
    }
  }

  /// Fetches the audio URL for the given place parameters without playing it.
  /// Returns the full resolved audio URL (absolute) or `null` if none.
  static Future<String?> fetchAudioUrl({
    required String resolvedPlace,
    String? selectedPlace,
    String? userIdentifier,
  }) async {
    try {
      EasyLoading.show(status: 'Generating voice...');

      debugPrint('PlaceVoiceService.fetchAudioUrl: resolvedPlace="$resolvedPlace" selectedPlace="$selectedPlace" userIdentifier="$userIdentifier"');

      final body = <String, dynamic>{
        'resolved_place': resolvedPlace,
      };
      if (userIdentifier != null && userIdentifier.isNotEmpty) {
        body['user_identifier'] = userIdentifier;
      } else if (selectedPlace != null && selectedPlace.isNotEmpty) {
        body['selected_place'] = selectedPlace;
      }

      final accessToken = Get.find<StorageService>().getAccessToken();
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      debugPrint('PlaceVoiceService: request headers -> $headers');
      final resp = await http.post(
        Uri.parse(Url.placeVoice),
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint('placeVoice response: ${resp.statusCode} ${resp.body}');
      debugPrint('placeVoice headers: ${resp.headers}');

      if (resp.statusCode != 200) {
        EasyLoading.showError('Server error: ${resp.statusCode}');
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (data.containsKey('wiki_text')) {
        debugPrint('wiki_text: ${data['wiki_text']}');
      }

      String? audioPath;
      if (data.containsKey('audio_url')) audioPath = data['audio_url'] as String?;

      // If the server returned wiki_text but no audio_url, do not resend wiki_text.
      if ((audioPath == null || audioPath.isEmpty) && data.containsKey('wiki_text')) {
        debugPrint('Server returned wiki_text but no audio_url; client will not send wiki_text.');
        EasyLoading.showError('Server requires wiki_text to generate audio (server-side).');
        return null;
      }

      if (audioPath == null || audioPath.isEmpty) {
        EasyLoading.showError('No audio returned from server');
        return null;
      }

      final audioUrl = Uri.parse(Url.baseUrl).resolve(audioPath).toString();
      debugPrint('Resolved audio URL: $audioUrl');

      // HEAD check
      try {
        final headResp = await http.head(Uri.parse(audioUrl));
        debugPrint('Audio HEAD: ${headResp.statusCode} headers=${headResp.headers}');
      } catch (e) {
        debugPrint('HEAD request failed for audio URL: $e');
      }

      EasyLoading.dismiss();
      return audioUrl;
    } catch (e, st) {
      debugPrint('Error in PlaceVoiceService.fetchAudioUrl: $e\n$st');
      EasyLoading.showError('Failed to generate voice');
      return null;
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping audio player: $e');
    }
  }
}
