import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/booking_controller.dart';

class Booking extends StatelessWidget {
  const Booking({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
    
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Booking.com',
              style: TextStyle(
                color: Color(0xFF003580),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Search hotels',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003580),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'From cozy country homes to funky city apartments',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B5D00),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Destination name field
                const Text(
                  'Destination name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003580),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.destinationController,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'e.g. city, region, district or specific hotel',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Check-in date
                const Text(
                  'Check-in date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003580),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => InkWell(
                  onTap: () => controller.selectCheckInDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formatDate(controller.checkInDate.value),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF0071C2),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                
                // Check-out date
                const Text(
                  'Check-out date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003580),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => InkWell(
                  onTap: () => controller.selectCheckOutDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formatDate(controller.checkOutDate.value),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF0071C2),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 30),
                
                // Search button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value 
                        ? null 
                        : controller.searchHotels,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0071C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
                
                // Additional info
                Obx(() {
                  final nights = controller.numberOfNights;
                  return nights > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Center(
                            child: Text(
                              '$nights night${nights > 1 ? 's' : ''} stay',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF003580),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}