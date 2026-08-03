import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/auhtentication/ai_assistant/controller/ai_assistant_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';

class _MockPathProviderPlatform extends PathProviderPlatform with MockPlatformInterfaceMixin {
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
  });

  test('selecting AI gender and voice persists to storage and profile controller', () async {
    final profileController = Get.put(ProfileController());
    final aiController = Get.put(AiAssistantController());

    aiController.selectGender('Male');
    aiController.selectVoice('Friendly');

    expect(Get.find<StorageService>().getAiGender(), 'Male');
    expect(Get.find<StorageService>().getAiVoice(), 'Friendly');
    expect(profileController.gender.value, 'Male');
    expect(profileController.voice.value, 'Friendly');
  });
}
