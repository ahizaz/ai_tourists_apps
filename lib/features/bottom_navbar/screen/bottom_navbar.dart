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
        () => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(5, (index) {
              final isSelected = controller.selectedIndex.value == index;
              return Expanded(
                child: InkWell(
                  onTap: () => controller.changeIndex(index),
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      isSelected ? activeIcons[index] : inactiveIcons[index],
                      width: 56.w,
                      height: 56.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
