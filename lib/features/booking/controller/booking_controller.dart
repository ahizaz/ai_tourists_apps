import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BookingController extends GetxController {
  // Text editing controllers
  final destinationController = TextEditingController();
  
  // Observable variables
  final Rx<DateTime> checkInDate = DateTime.now().obs;
  final Rx<DateTime> checkOutDate = DateTime.now().add(const Duration(days: 5)).obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize default dates
    checkInDate.value = DateTime.now();
    checkOutDate.value = DateTime.now().add(const Duration(days: 5));
  }

  @override
  void onClose() {
    destinationController.dispose();
    super.onClose();
  }

  // Select check-in date
  Future<void> selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003580), // Booking.com blue
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != checkInDate.value) {
      checkInDate.value = picked;
      
      // Auto-adjust check-out date if it's before check-in
      if (checkOutDate.value.isBefore(picked)) {
        checkOutDate.value = picked.add(const Duration(days: 1));
      }
    }
  }

  // Select check-out date
  Future<void> selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate.value.isAfter(checkInDate.value) 
          ? checkOutDate.value 
          : checkInDate.value.add(const Duration(days: 1)),
      firstDate: checkInDate.value.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003580), // Booking.com blue
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != checkOutDate.value) {
      checkOutDate.value = picked;
    }
  }

  // Format date to display
  String formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    
    return '${date.day} ${months[date.month - 1]}, ${days[date.weekday % 7]}';
  }

  // Search hotels
  void searchHotels() {
    if (destinationController.text.trim().isEmpty) {
      Get.snackbar(
        'destination_required'.tr,
        'enter_destination'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      Get.snackbar(
        'search_complete'.tr,
        '${'searching_hotels_in'.tr} ${destinationController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      
     
    });
  }

  // Calculate number of nights
  int get numberOfNights {
    return checkOutDate.value.difference(checkInDate.value).inDays;
  }
}
