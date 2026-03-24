import 'package:flutter/material.dart';
import '../../../utils/share_helper.dart';

/// Reusable share button for quiz result screens.
class QuizShareButton extends StatelessWidget {
  final String quizTitle;
  final int score;
  final int total;
  final String? appLink;
  final double? size;

  const QuizShareButton({
    Key? key,
    required this.quizTitle,
    required this.score,
    required this.total,
    this.appLink,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share, size: size ?? 24),
      onPressed: () async {
        await ShareHelper.shareQuizResult(
          quizTitle: quizTitle,
          score: score,
          total: total,
          appLink: appLink,
        );
      },
    );
  }
}
