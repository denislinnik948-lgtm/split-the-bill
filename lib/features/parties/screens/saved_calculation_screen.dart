import 'package:flutter/material.dart';
import 'package:splittrip/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../logic/calculation.dart';
import '../share/result_text.dart';
import '../state/parties_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/receipt_view.dart';

/// Read-only view of a completed party, with Share and Delete actions.
class SavedCalculationScreen extends ConsumerWidget {
  const SavedCalculationScreen({super.key, required this.partyId});

  final String partyId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteCalculationTitle,
      message: l10n.deleteCalculationMessage,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(partiesControllerProvider.notifier).deleteParty(partyId);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(partiesControllerProvider);
    final party = state.saved.where((p) => p.id == partyId).firstOrNull;

    if (party == null) {
      // Deleted — _delete pops explicitly, so just render nothing here.
      return const Scaffold();
    }

    final result = calculateParty(party);

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
                      buildResultText(party, result, l10n),
                      l10n.copied,
                    ),
                  ),
                  HeaderAction(
                    icon: LucideIcons.trash2,
                    onPressed: () => _delete(context, ref),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [ReceiptView(party: party, result: result)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
