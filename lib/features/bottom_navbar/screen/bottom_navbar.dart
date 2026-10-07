import 'package:ai_powered_tourists_app/features/ai/screen/ai_screen.dart';
import 'package:ai_powered_tourists_app/features/booking/screen/booking.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/controller/bottom_navcontroller.dart';
import 'package:ai_powered_tourists_app/features/home/screen/home.dart';
import 'package:ai_powered_tourists_app/features/map/screen/map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/profile_screen.dart';
import 'package:ai_powered_tourists_app/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});
  final BottomNavcontroller controller = Get.find<BottomNavcontroller>();

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
    IconPath.aiactive,
    IconPath.bookinginactive,
    IconPath.profileinactive,
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return;
        }

        if (controller.tabHistory.length > 1) {
          controller.handleBack();
          return;
        }

        final confirmed = await Get.defaultDialog<bool>(
          title: 'exit_app'.tr,
          middleText: 'tap_back_again_to_exit'.tr,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
          textConfirm: 'exit'.tr,
          textCancel: 'cancel'.tr,
        );

        if (confirmed == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: screens,
          ),
        ),
        backgroundColor: const Color(0xffF5F5F5),
        bottomNavigationBar: Obx(
          () => SafeArea(
            top: false,
            bottom: true,
            child: SizedBox(
              height: 96.h,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
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
                    final icon = SvgPicture.asset(
                      isSelected ? activeIcons[index] : inactiveIcons[index],
                      width: 64.w,
                      height: 64.h,
                      fit: BoxFit.contain,
                    );
                    final renderedIcon = index == 3 && !isSelected
                        ? Transform.translate(
                            offset: Offset(0, -5.h),
                            child: Transform.scale(scale: 1.12, child: icon),
                          )
                        : icon;

                    return Expanded(
                      child: InkWell(
                        onTap: () => controller.changeIndex(index),
                        child: Center(child: renderedIcon),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
