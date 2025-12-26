import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  Future<String> _loadTerms() async {
    return await rootBundle.loadString('assets/terms/TERMS_AND_CONDITIONS_DALIL.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: const Color(0xffFF6B35),
      ),
      body: FutureBuilder<String>(
        future: _loadTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading terms: ${snapshot.error}'));
          }

          final content = snapshot.data ?? 'No terms available.';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SelectableText(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          );
        },
      ),
    );
  }
}
