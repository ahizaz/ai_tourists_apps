import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  Future<String> _loadTerms() async {
    return await rootBundle.loadString('assets/terms/TERMS_AND_CONDITIONS_DALIL.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffFF6B35),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<String>(
        future: _loadTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffFF6B35)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xffFF6B35), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Error loading terms',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          final rawContent = snapshot.data ?? '';
          final sections = _parseSections(rawContent);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffFF6B35), Color(0xffFF8C5A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFF6B35).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.description_outlined, color: Colors.white, size: 28),
                            SizedBox(width: 10),
                            Text(
                              'DALIL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Terms & Conditions + Privacy Policy',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Last Updated: December 9th, 2025',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Introduction box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF6B35).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffFF6B35).withOpacity(0.2)),
                    ),
                    child: const Text(
                      'This document combines the Terms & Conditions ("Terms") and the Privacy Policy ("Policy") governing the use of the Dalil mobile application. By using Dalil, you accept all provisions herein.',
                      style: TextStyle(fontSize: 13.5, color: Color(0xFF555555), height: 1.6),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sections
                  ...sections.map((section) => _buildSectionCard(section)),

                  const SizedBox(height: 30),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.verified_outlined, color: Color(0xffFF6B35), size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'DALIL CORPORATION',
                          style: TextStyle(
                            color: Color(0xffFF6B35),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dalil.services@gmail.com',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<_TermsSection> _parseSections(String content) {
    final List<_TermsSection> sections = [];
    final lines = content.split('\n');
    String? currentTitle;
    final List<String> currentBody = [];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty ||
          trimmed.startsWith('TERMS & CONDITIONS') ||
          trimmed.startsWith('Last Updated') ||
          trimmed.startsWith('— INTRODUCTION —') ||
          trimmed.startsWith('DALIL CORPORATION') ||
          trimmed.startsWith('PRIVACY POLICY') ||
          trimmed == '=====================') {
        continue;
      }
      final isSectionTitle = RegExp(r'^\d+\.\s+.+').hasMatch(trimmed);
      if (isSectionTitle) {
        if (currentTitle != null && currentBody.isNotEmpty) {
          sections.add(_TermsSection(title: currentTitle, body: currentBody.join('\n').trim()));
          currentBody.clear();
        }
        currentTitle = trimmed;
      } else if (currentTitle != null) {
        currentBody.add(line);
      }
    }
    if (currentTitle != null && currentBody.isNotEmpty) {
      sections.add(_TermsSection(title: currentTitle, body: currentBody.join('\n').trim()));
    }
    return sections;
  }

  Widget _buildSectionCard(_TermsSection section) {
    final sectionNum = int.tryParse(section.title.split('.').first) ?? 0;
    final isPrivacy = sectionNum >= 12;
    final accentColor = isPrivacy ? const Color(0xFF2C3E50) : const Color(0xffFF6B35);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getSectionIcon(sectionNum), color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: accentColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              section.body,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF555555), height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSectionIcon(int num) {
    switch (num) {
      case 1: return Icons.explore_outlined;
      case 2: return Icons.person_outline;
      case 3: return Icons.app_registration_outlined;
      case 4: return Icons.smart_toy_outlined;
      case 5: return Icons.location_on_outlined;
      case 6: return Icons.payment_outlined;
      case 7: return Icons.copyright_outlined;
      case 8: return Icons.hub_outlined;
      case 9: return Icons.shield_outlined;
      case 10: return Icons.block_outlined;
      case 11: return Icons.update_outlined;
      case 12: return Icons.data_usage_outlined;
      case 13: return Icons.gavel_outlined;
      case 14: return Icons.tune_outlined;
      case 15: return Icons.share_outlined;
      case 16: return Icons.public_outlined;
      case 17: return Icons.manage_accounts_outlined;
      case 18: return Icons.storage_outlined;
      case 19: return Icons.lock_outline;
      case 20: return Icons.child_care_outlined;
      case 21: return Icons.mail_outline;
      default: return Icons.article_outlined;
    }
  }
}

class _TermsSection {
  final String title;
  final String body;
  const _TermsSection({required this.title, required this.body});
}