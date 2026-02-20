import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Future<String> _loadPrivacyPolicy() async {
    try {
      return await rootBundle.loadString('privacy_policy.md');
    } catch (e) {
      return 'Failed to load privacy policy.\n\n$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgAlt,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.privacyPolicy ?? '隐私协议',
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: FutureBuilder<String>(
        future: _loadPrivacyPolicy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Failed to load content.',
                style: TextStyle(color: context.textPrimary),
              ),
            );
          }
          return Markdown(
            data: snapshot.data!,
            padding: const EdgeInsets.all(16.0),
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: context.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
              h1: TextStyle(
                color: context.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              h2: TextStyle(
                color: context.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              h3: TextStyle(
                color: context.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              listBullet: TextStyle(color: context.textPrimary),
              blockSpacing: 16.0,
            ),
          );
        },
      ),
    );
  }
}
