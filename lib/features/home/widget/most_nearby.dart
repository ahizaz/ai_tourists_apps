import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import 'place_card.dart';

class MostNearbySection extends StatelessWidget {
  const MostNearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    final categories = ['Historical', 'Tourism', 'Museum', 'All'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        Row(
          children: [
            Text(
              'Most Nearby',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
           
           
          ],
        ),
        SizedBox(height: 12.h),

        // category pills
        Obx(
          () => Row(
            children: categories.map((cat) {
              final selected = controller.selectedCategory.value == cat;
              return GestureDetector(
                onTap: () => controller.selectCategory(cat),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: selected ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24.r),
                    border: selected
                        ? Border.all(color: Colors.green.shade400, width: 1.4)
                        : null,
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.dmSans(
                      fontSize: 13.sp,
                      color: selected ? Colors.green[800] : Colors.grey[700],
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 12.h),

        // places list
        Obx(
          () {
            final items = controller.filteredPlaces();
            if (items.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text('No nearby places found.',
                      style: GoogleFonts.dmSans(fontSize: 14.sp)),
                ),
              );
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final place = items[index];
                return PlaceCard(
                  place: place,
                  onTap: () {
                    // navigate to details page (implement later)
                    debugPrint('Tapped ${place.title}');
                  },
                  onBookmark: () {
                    // handle bookmark (implement favorite toggling)
                    debugPrint('Bookmark ${place.title}');
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}