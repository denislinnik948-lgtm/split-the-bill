import 'package:flutter/material.dart';
import 'package:splittrip/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/app_info.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../parties/widgets/app_header.dart';
import '../info_content.dart';
import 'info_detail_screen.dart';

/// Hub for app information and legal documents, reached from the home header.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _open(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InfoDetailScreen(title: title, body: body),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppHeader(onBack: () => Navigator.of(context).pop()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(l10n.infoTitle, style: AppTextStyles.h1),
                  const SizedBox(height: 24),
                  _InfoRow(
                    label: l10n.aboutItem,
                    onTap: () =>
                        _open(context, l10n.aboutItem, aboutBody(lang)),
                  ),
                  _InfoRow(
                    label: l10n.privacyItem,
                    onTap: () =>
                        _open(context, l10n.privacyItem, privacyBody(lang)),
                  ),
                  _InfoRow(
                    label: l10n.termsItem,
                    onTap: () =>
                        _open(context, l10n.termsItem, termsBody(lang)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.versionLabel(kAppVersion),
                    style: AppTextStyles.caption,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.body)),
            const Icon(LucideIcons.chevronRight,
                size: 18, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
