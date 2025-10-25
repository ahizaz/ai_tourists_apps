import 'package:ai_powered_tourists_app/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiAssistant extends StatelessWidget {
  const AiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 135.h),
            Center(
                child: Image(
                  image: AssetImage(ImagePath.aiassistant),
                  height: 190.h,
                  width: 159.w,
                  fit: BoxFit.cover,
                ),
              ),
        ],
      ),
    );
  }
}