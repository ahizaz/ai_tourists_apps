import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerFeedbackOverlay extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onComplete;

  const AnswerFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.onComplete,
  });

  @override
  State<AnswerFeedbackOverlay> createState() => _AnswerFeedbackOverlayState();
}

class _AnswerFeedbackOverlayState extends State<AnswerFeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: (widget.isCorrect
                  ? const Color(0xff28A745)
                  : const Color(0xffDC3545))
              .withOpacity(_opacityAnimation.value * 0.1),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.isCorrect
                  ? _buildSuccessAnimation()
                  : _buildErrorAnimation(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessAnimation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: const Color(0xff28A745),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff28A745).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 60,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Correct! 🎉',
          style: GoogleFonts.inter(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff28A745),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorAnimation() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        // Shake effect
        final offset = (value < 0.5 ? value : 1 - value) * 20;
        return Transform.translate(
          offset: Offset(offset - 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: const Color(0xffDC3545),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffDC3545).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Oops! 😅',
                style: GoogleFonts.inter(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffDC3545),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
