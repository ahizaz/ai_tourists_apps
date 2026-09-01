import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/controller/ai_assistant_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';

class _MockPathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    PathProviderPlatform.instance = _MockPathProviderPlatform();
    Get.reset();
    await GetStorage.init();
    await Get.putAsync(() => StorageService().init());
    Get.find<StorageService>().clearAll();
  });

  test(
    'selecting AI gender and voice persists to storage and profile controller',
    () async {
      final profileController = Get.put(ProfileController());
      final aiController = Get.put(AiAssistantController());

      aiController.selectGender('Male');
      aiController.selectVoice('Friendly');

      expect(Get.find<StorageService>().getAiGender(), 'male');
      expect(Get.find<StorageService>().getAiVoice(), 'friendly');
      expect(profileController.gender.value, 'male');
      expect(profileController.voice.value, 'friendly');
    },
  );

  test('voice type values are normalized to backend accepted choices', () {
    final profileController = Get.put(ProfileController());

    expect(profileController.toggleVoiceType('historical_focus'), isTrue);
    expect(profileController.toggleVoiceType('artistic_focus'), isTrue);
    expect(profileController.toggleVoiceType('fun_facts'), isTrue);

    expect(profileController.voiceTypes, [
      'historical',
      'artistic',
      'fun_facts',
    ]);
    expect(profileController.selectedVoiceType, 'fun_facts');
  });
}
