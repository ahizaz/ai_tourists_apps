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

    final categories = [
      {'key': 'historical', 'label': 'historical'.tr},
      {'key': 'tourism', 'label': 'tourism'.tr},
      {'key': 'museum', 'label': 'museum'.tr},
      {'key': 'all', 'label': 'all'.tr},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header
        Row(
          children: [
            Text(
              'most_nearby'.tr,
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
              final selected = controller.selectedCategory.value == cat['key'];
              return GestureDetector(
                onTap: () => controller.selectCategory(cat['key']!),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: selected ? Color(0xffBDE446): Colors.grey[100],
                    borderRadius: BorderRadius.circular(24.r),
                    border: selected
                        ? Border.all(color: Color(0xffE5F5B4), width: 1.4)
                        : null,
                  ),
                  child: Text(
                    cat['label']!,
                    style: GoogleFonts.dmSans(
                      fontSize: 13.sp,
                      color: selected ? Color(0xff252525) : Colors.grey[700],
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
                  child: Text('no_places_found'.tr,
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
             
                  },
                  onBookmark: () {
                 
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