import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../logic/calculation.dart';
import '../models/party.dart';
import '../quips.dart';

/// Receipt-style presentation of a calculation: totals at the top, a dotted
/// divider, then the transfer list. Shared by the live and saved screens.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.party, required this.result});

  final Party party;
  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final names = {for (final p in party.participants) p.id: p.name};
    final quip =
        quipForParty(party.id, Localizations.localeOf(context).languageCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.calculationTitle, style: AppTextStyles.h1),
        const SizedBox(height: 8),
        Text(party.displayNameOr(l10n.untitledParty).toUpperCase(),
            style: AppTextStyles.caption),
        const SizedBox(height: 28),

        _SummaryLine(label: l10n.total, value: formatMoney(result.totalAmount)),
        _SummaryLine(
          label: l10n.participantsLabel,
          value: '${result.participantCount}',
        ),
        _SummaryLine(
          label: l10n.perPerson,
          value: formatMoney(result.amountPerPerson),
        ),

        const SizedBox(height: 20),
        const _DottedDivider(),
        const SizedBox(height: 20),

        if (result.transfers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              l10n.settledUp,
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
          )
        else
          ...result.transfers.map(
            (t) => _TransferTile(
              from: names[t.fromParticipantId] ?? '?',
              to: names[t.toParticipantId] ?? '?',
              amount: t.amount,
            ),
          ),

        if (quip.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(
            quip,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(fontSize: 14, height: 1.4),
          ),
        ],
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMuted),
          const Spacer(),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

class _TransferTile extends StatelessWidget {
  const _TransferTile({
    required this.from,
    required this.to,
    required this.amount,
  });

  final String from;
  final String to;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(from, style: AppTextStyles.h2),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(LucideIcons.arrowRight,
                        size: 16, color: AppColors.secondaryText),
                    const SizedBox(width: 6),
                    Text(to, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(formatMoney(amount), style: AppTextStyles.h2),
        ],
      ),
    );
  }
}

/// A thin dashed rule, reminiscent of a torn receipt.
class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: AppColors.border,
            ),
          ),
        );
      },
    );
  }
}
