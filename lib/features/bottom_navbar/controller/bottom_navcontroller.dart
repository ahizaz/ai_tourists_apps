import 'package:get/get.dart';

class BottomNavcontroller extends GetxController {
  RxInt selectedIndex = 0.obs;
  final RxList<int> tabHistory = <int>[0].obs;

  void changeIndex(int index) {
    if (index == selectedIndex.value) {
      return;
    }

    selectedIndex.value = index;

    if (tabHistory.isEmpty || tabHistory.last != index) {
      tabHistory.add(index);
    }
  }

  void handleBack() {
    if (tabHistory.length > 1) {
      tabHistory.removeLast();
      selectedIndex.value = tabHistory.last;
      return;
    }

    selectedIndex.value = 0;
  }
}