import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionTile extends StatelessWidget {
  final bool selected;
  final bool isCheckbox;
  final String label;
  final VoidCallback? onTap;

  const OptionTile({
    Key? key,
    required this.label,
    this.selected = false,
    this.isCheckbox = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFE6550D) : const Color(0xFFdcdcdc);
    final radius = 14.0;

    Widget leading;
    if (isCheckbox) {
      leading = Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6550D) : Colors.white,
          border: Border.all(color: selected ? const Color(0xFFE6550D) : const Color(0xFFcfcfcf), width: 1.6),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
      );
    } else {
      leading = Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selected ? const Color(0xFFE6550D) : const Color(0xFFcfcfcf), width: 2),
        ),
        child: selected
            ? Container(
                margin: EdgeInsets.all(5.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE6550D),
                ),
              )
            : null,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: selected ? 2 : 1.3),
        ),
        child: Row(
          children: [
            leading,
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.inter(
                color: selected ? const Color(0xFFE6550D) : const Color(0xFF808080),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}