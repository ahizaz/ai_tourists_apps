import 'dart:convert';

import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/core/urls/urls.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PlayQuizeService {
  static const String _endpoint = Url.playQuize;

  static Future<List<Map<String, dynamic>>> fetchLocationQuiz({
    required double latitude,
    required double longitude,
    required int count,
    List<String>? topics,
  }) async {
    EasyLoading.show(status: 'Preparing quiz...');
    try {
      // Resolve human readable place from coordinates
      String resolvedPlace = '$latitude,$longitude';
      try {
        final placemarks = await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[];
          if ((p.locality ?? '').isNotEmpty) parts.add(p.locality!);
          if ((p.subAdministrativeArea ?? '').isNotEmpty)
            parts.add(p.subAdministrativeArea!);
          if ((p.administrativeArea ?? '').isNotEmpty &&
              !parts.contains(p.administrativeArea))
            parts.add(p.administrativeArea!);
          if (parts.isNotEmpty) {
            resolvedPlace = parts.join(', ');
          } else if ((p.name ?? '').isNotEmpty) {
            resolvedPlace = p.name!;
          }
        }
      } catch (e) {
        debugPrint('Reverse geocoding failed: $e');
      }

      final token = Get.find<StorageService>().getAccessToken();
      debugPrint(
        'Calling PlayQuiz API for place: $resolvedPlace, count: $count',
      );

      final uri = Uri.parse(_endpoint);
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'resolved_place': resolvedPlace,
          'count': count,
          'topics': topics ?? ['food'],
        }),
      );

      debugPrint('PlayQuiz response status: ${response.statusCode}');
      debugPrint('PlayQuiz response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> quizData = body['quiz'] ?? [];

        final List<Map<String, dynamic>> parsed = quizData
            .map<Map<String, dynamic>>((q) {
              final List<dynamic> opts = q['options'] ?? [];
              final int correctIndex = (q['correct_index'] is int)
                  ? q['correct_index'] as int
                  : int.tryParse(q['correct_index']?.toString() ?? '') ?? 0;
              final correctAnswer =
                  (opts.isNotEmpty &&
                      correctIndex >= 0 &&
                      correctIndex < opts.length)
                  ? opts[correctIndex]
                  : (opts.isNotEmpty ? opts.first : '');

              return {
                'question': q['question']?.toString() ?? '',
                'options': opts.map((o) => o.toString()).toList(),
                'correctAnswer': correctAnswer.toString(),
              };
            })
            .toList();

        return parsed;
      } else {
        debugPrint('PlayQuiz API error: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      debugPrint('Error in fetchLocationQuiz: $e\n$st');
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }
}
