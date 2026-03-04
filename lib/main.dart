import 'package:ai_powered_tourists_app/app.dart';
import 'package:ai_powered_tourists_app/core/services/storage_service.dart';
import 'package:ai_powered_tourists_app/features/ai/controller/ai_controller.dart';
import 'package:ai_powered_tourists_app/features/booking/controller/booking_controller.dart';
import 'package:ai_powered_tourists_app/features/bottom_navbar/controller/bottom_navcontroller.dart';
import 'package:ai_powered_tourists_app/features/home/controller/home_controller.dart';
import 'package:ai_powered_tourists_app/features/map/controller/map_controller.dart';
import 'package:ai_powered_tourists_app/features/profile/controller/profile_controller.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
   Get.lazyPut(() => BottomNavcontroller(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => MapController(), fenix: true);
  Get.lazyPut(() => AiController(), fenix: true);
  Get.lazyPut(() => BookingController(), fenix: true);
  Get.lazyPut(() => ProfileController(), fenix: true);
runApp(
  DevicePreview(
    enabled : !kReleaseMode,
    builder: (context)=>const AITourists(),

  )
);
}

