import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SystemVolume {
  static const MethodChannel _channel = MethodChannel('app.channel.audio');

  /// Request Android to set media volume to maximum. Returns true on success.
  static Future<bool> setMaxVolume() async {
    try {
      final res = await _channel.invokeMethod<bool>('setMediaVolumeMax');
      debugPrint('SystemVolume.setMaxVolume result: $res');
      return res == true;
    } catch (e) {
      debugPrint('SystemVolume.setMaxVolume error: $e');
      return false;
    }
  }
}
