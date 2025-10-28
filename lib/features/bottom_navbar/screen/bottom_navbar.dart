import 'package:ai_powered_tourists_app/features/ai/screen/ai_screen.dart';
import 'package:ai_powered_tourists_app/features/booking/screen/booking.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/controller/bottom_navcontroller.dart';
import 'package:ai_powered_tourists_app/features/home/screen/home.dart';
import 'package:ai_powered_tourists_app/features/map/screen/map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_screen.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});
  final BottomNavcontroller controller = Get.put(BottomNavcontroller());

  final List<Widget> screens = [
    Home(),
    MapScreen(),
    AiScreen(),
    Booking(),
    ProfileScreen(),
  ];

  final List<String> activeIcons = [
    IconPath.activehomeicon,
    IconPath.mapactive,
    IconPath.aiactive,
    IconPath.bookingactive,
    IconPath.profileactive,
  ];

  final List<String> inactiveIcons = [
    IconPath.inactivehomeicon,
    IconPath.mapinactive,
    IconPath.aiinactive,
    IconPath.bookinginactive,
    IconPath.profileinactive,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      backgroundColor: const Color(0xffF5F5F5),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: const NavigationBarThemeData(
            overlayColor: WidgetStatePropertyAll(Color(0xffF5F5F5)),
          ),
          child: NavigationBar(
            indicatorColor: Colors.transparent,
            elevation: 9,
            height: 96.h,
            shadowColor: Colors.black,
            backgroundColor: const Color(0xffF5F5F5),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (int index) {
              controller.changeIndex(index);
            },
            // 🔹 শুধু আইকন, কোনো label নেই
            destinations: List.generate(5, (index) {
              return NavigationDestination(
                icon: Image.asset(
                  controller.selectedIndex.value == index
                      ? activeIcons[index]
                      : inactiveIcons[index],
                  width: 64.w,
                ),
                label: '', 
              );
            }),
          ),
        ),
      ),
    );
  }
}
