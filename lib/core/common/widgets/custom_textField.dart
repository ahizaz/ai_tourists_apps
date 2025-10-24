import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.borderRadius = 12.0,
    this.fillColor = Colors.white,
    this.borderColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color _border = borderColor ?? AppColors.border;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: _border, width: 1.5.w),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: Colors.black54),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}