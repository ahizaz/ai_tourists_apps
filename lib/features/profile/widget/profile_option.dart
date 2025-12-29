import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileOptionItem extends StatelessWidget {
  final dynamic iconPath; // Can be String or IconData
  final String title;
  final VoidCallback? onTap;

  const ProfileOptionItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              // Support both String (asset path) and IconData
              iconPath is IconData
                  ? Icon(iconPath, size: 30.w, color: const Color(0xff505050))
                  : Image(
                      image: AssetImage(iconPath),
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff505050),
                    fontSize: 18.sp,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
