
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AiAssistantController extends GetxController {
  final RxnString gender = RxnString();
  final RxnString voice = RxnString();
  final RxList<String> voiceTypes = <String>[].obs;
  final int maxVoiceTypesSelections;

  AiAssistantController({this.maxVoiceTypesSelections = 3});

  void selectGender(String? g) {
    gender.value = g;
  }

  void selectVoice(String? v) {
    voice.value = v;
  }

  bool toggleVoiceType(String t) {
    if (voiceTypes.contains(t)) {
      voiceTypes.remove(t);
      return true;
    }
    if (voiceTypes.length < maxVoiceTypesSelections) {
      voiceTypes.add(t);
      return true;
    }
    return false;
  }

  void resetAll() {
    gender.value = null;
    voice.value = null;
    voiceTypes.clear();
  }
}