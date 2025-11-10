import 'package:ai_powered_tourists_app/core/localization/localization_service.dart';
import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    return Obx(() => InkWell(
      onTap: () => _showLanguageBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xffE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 20.sp,
              color: AppColors.orangeEnd,
            ),
            SizedBox(width: 6.w),
            Text(
              localizationService.getCurrentLanguageName(),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff252525),
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.sp,
              color: const Color(0xff878787),
            ),
          ],
        ),
      ),
    ));
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'select_language'.tr,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff252525),
                ),
              ),
              SizedBox(height: 16.h),
              _buildLanguageOption(
                context: context,
                locale: LocalizationService.englishLocale,
                languageName: 'English',
                flag: '🇺🇸',
                localizationService: localizationService,
              ),
              SizedBox(height: 12.h),
              _buildLanguageOption(
                context: context,
                locale: LocalizationService.frenchLocale,
                languageName: 'Français',
                flag: '🇫🇷',
                localizationService: localizationService,
              ),
              SizedBox(height: 12.h),
              _buildLanguageOption(
                context: context,
                locale: LocalizationService.spanishLocale,
                languageName: 'Español',
                flag: '🇪🇸',
                localizationService: localizationService,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale locale,
    required String languageName,
    required String flag,
    required LocalizationService localizationService,
  }) {
    return Obx(() {
      final isSelected = localizationService.isCurrentLocale(locale);
      
      return InkWell(
        onTap: () {
          localizationService.changeLanguage(locale);
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangeEnd.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.orangeEnd : const Color(0xffE0E0E0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                flag,
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  languageName,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.orangeEnd : const Color(0xff252525),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.orangeEnd,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      );
    });
  }
}
