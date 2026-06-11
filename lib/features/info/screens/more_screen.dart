import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/app_info.dart';
import '../../../core/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../parties/widgets/app_header.dart';
import '../info_content.dart';
import 'info_detail_screen.dart';

/// Hub for app information, language and legal documents.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  void _open(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InfoDetailScreen(title: title, body: body),
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final current = ref.read(localeControllerProvider)?.languageCode;
    final options = <String?, String>{
      null: l10n.languageSystem,
      'uk': 'Українська',
      'en': 'English',
    };
    final picked = await showDialog<String?>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in options.entries)
                ListTile(
                  title: Text(entry.value, style: AppTextStyles.body),
                  trailing: entry.key == current
                      ? const Icon(LucideIcons.check,
                          size: 18, color: AppColors.primaryText)
                      : null,
                  onTap: () => Navigator.of(context).pop(entry.key ?? '__system'),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return; // dismissed
    final code = picked == '__system' ? null : picked;
    await ref
        .read(localeControllerProvider.notifier)
        .setLocale(code == null ? null : Locale(code));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final override = ref.watch(localeControllerProvider);
    final languageValue = override == null
        ? l10n.languageSystem
        : (override.languageCode == 'uk' ? 'Українська' : 'English');

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
                  Text(l10n.menuTitle, style: AppTextStyles.h1),
                  const SizedBox(height: 24),
                  _InfoRow(
                    label: l10n.languageItem,
                    value: languageValue,
                    onTap: () => _pickLanguage(context, ref),
                  ),
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
  const _InfoRow({required this.label, required this.onTap, this.value});
  final String label;
  final String? value;
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
            if (value != null) ...[
              Text(value!, style: AppTextStyles.bodyMuted),
              const SizedBox(width: 8),
            ],
            const Icon(LucideIcons.chevronRight,
                size: 18, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}
