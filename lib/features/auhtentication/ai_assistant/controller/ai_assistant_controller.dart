
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AiAssistantController extends GetxController {
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxnString voiceType = RxnString();

  void selectGender(String? g) {
    gender.value = g;
  }

  void selectVoice(String? v) {
    voice.value = v;
  }

  void selectVoiceType(String? t) {
    voiceType.value = t;
  }

  void resetAll() {
    gender.value = null;
    voice.value = null;
    voiceType.value = null;
  }
}