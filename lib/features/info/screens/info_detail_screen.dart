import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../parties/widgets/app_header.dart';

/// A simple document screen: back button, a heading and scrollable body text.
/// Used for About, Privacy Policy and Terms of Use.
class InfoDetailScreen extends StatelessWidget {
  const InfoDetailScreen({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppHeader(onBack: () => Navigator.of(context).pop()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Text(title, style: AppTextStyles.h1),
                  const SizedBox(height: 20),
                  Text(
                    body,
                    style: AppTextStyles.body.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
