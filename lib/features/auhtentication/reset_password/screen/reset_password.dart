import 'package:ai_powered_tourists_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(child: Padding(padding:  EdgeInsets.symmetric(horizontal: 12.w),)
          
    )
    );
  }
}