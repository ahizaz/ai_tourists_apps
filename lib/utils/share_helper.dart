import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility helpers for sharing quiz results and opening social intent links.
class ShareHelper {
  /// Shares a simple text result via platform share sheet.
  static Future<void> shareQuizResult({
    required String quizTitle,
    required int score,
    required int total,
    String? appLink,
  }) async {
    final headline = 'I scored $score/$total on "$quizTitle"';
    final body = appLink == null
        ? '$headline\nTry this quiz on AI Tourist App!'
        : '$headline\nTry this quiz on AI Tourist App: $appLink';

    await Share.share(body, subject: 'My Quiz Result');
  }

  /// Open Twitter compose with pre-filled text (in browser or app if available).
  static Future<void> shareToTwitter({
    required String text,
    String? url,
  }) async {
    final encodedText = Uri.encodeComponent(text);
    final encodedUrl = url != null ? '&url=${Uri.encodeComponent(url)}' : '';
    final uri = Uri.parse('https://twitter.com/intent/tweet?text=$encodedText$encodedUrl');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Open Facebook share dialog via web (note: Facebook may limit prefilled text).
  static Future<void> shareToFacebook({
    String? url,
  }) async {
    if (url == null) return;
    final encodedUrl = Uri.encodeComponent(url);
    final uri = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$encodedUrl');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
