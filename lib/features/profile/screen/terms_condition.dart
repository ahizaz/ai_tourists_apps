import 'package:flutter/material.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle headingStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w700);
    final TextStyle bodyStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to MyTouristApp',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Please read these Terms and Conditions ("Terms") carefully before using our tourist-related mobile application (the "App"). By accessing or using the App, you agree to be bound by these Terms. If you do not agree with any part of the Terms, you must not use the App.',
                style: bodyStyle,
              ),
              const SizedBox(height: 20),

              Text('1. Use of the App', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'You must use the App in compliance with all applicable laws. The App is for personal, non-commercial use unless otherwise agreed in writing. You agree not to misuse the App or interfere with its normal operation.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('2. User Accounts & Information', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'Some features may require creating an account. You are responsible for keeping your account credentials secure and for all activity under your account. Provide accurate information and notify us if your information changes.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('3. Content & Third-Party Services', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'The App may display content from third-party providers (e.g., maps, booking services). We do not control these third parties and are not responsible for their content, policies, or actions. Use third-party services at your own risk.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('4. Bookings & Payments', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'If the App offers bookings or payment functionality, transactions are subject to the terms of the service provider. We may act only as an intermediary and are not responsible for the performance of suppliers (hotels, tour operators, transport, etc.). Fees, cancellations, and refunds follow supplier policies unless otherwise specified.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('5. Privacy', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'We collect and process personal data in accordance with our Privacy Policy. By using the App, you consent to such processing. For details, please review the Privacy Policy (link or separate page).',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('6. Limitation of Liability', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'To the fullest extent permitted by law, we are not liable for any indirect, incidental, or consequential damages arising from your use of the App. Our total liability for direct damages is limited to the amount you paid us (if any) in the last 12 months.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('7. Changes to Terms', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'We may update these Terms from time to time. When changes are significant, we will provide a prominent notice. Continued use of the App after changes indicates acceptance of the updated Terms.',
                style: bodyStyle,
              ),
              const SizedBox(height: 16),

              Text('8. Governing Law', style: headingStyle),
              const SizedBox(height: 8),
              Text(
                'These Terms are governed by the laws of the country where the app provider is established, unless otherwise required by law. Any disputes will be resolved in the competent courts of that jurisdiction.',
                style: bodyStyle,
              ),
              const SizedBox(height: 24),

              Text(
                'Contact Us',
                style: headingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'If you have questions about these Terms, please contact us at support@mytouristapp.example (replace with real contact).',
                style: bodyStyle,
              ),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Stateless widget: typically navigation or closing the page.
                    // For example, go back:
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Text('I Understand'),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Last updated: 2025-11-03',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}