import 'package:flutter/material.dart';
import 'package:splittrip/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../logic/calculation.dart';
import '../share/result_text.dart';
import '../state/parties_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/receipt_view.dart';

/// Live calculation for the current draft, with Share and Save actions.
class CalculationScreen extends ConsumerWidget {
  const CalculationScreen({super.key});

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    // Capture the navigator before awaiting/popping: popUntil deactivates this
    // screen's element, after which Navigator.of(context) would be unsafe.
    final navigator = Navigator.of(context);
    await ref.read(partiesControllerProvider.notifier).completeDraft();
    // The completed party now lives in history — return straight to Home.
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(partiesControllerProvider).draft;

    if (draft == null) {
      // Transient (e.g. just after Save completes the draft); navigation is
      // driven explicitly by _save, so just render nothing for this frame.
      return const Scaffold();
    }

    final result = calculateParty(draft);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppHeader(
                onBack: () => Navigator.of(context).pop(),
                trailing: [
                  HeaderAction(
                    icon: LucideIcons.copy,
                    onPressed: () => copyResultToClipboard(
                      context,
                      buildResultText(draft, result, l10n),
                      l10n.copied,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [ReceiptView(party: draft, result: result)],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: PrimaryButton(
                label: l10n.save,
                onPressed: () => _save(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
