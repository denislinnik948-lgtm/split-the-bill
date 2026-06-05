import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/clipboard/clipboard_helper.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../logic/calculation.dart';
import '../models/party.dart';

/// Builds the plain-text summary copied to the clipboard.
///
/// Example:
///
///     SHASHLYKY 2026
///
///     Total: 12 450 ₴
///     Participants: 5
///     Per Person: 2 490 ₴
///
///     Olga → Igor: 2 500 ₴
///     Denis → Andrew: 500 ₴
String buildResultText(Party party, CalculationResult result, AppLocalizations l10n) {
  final names = {for (final p in party.participants) p.id: p.name};
  final buffer = StringBuffer()
    ..writeln(party.displayNameOr(l10n.untitledParty).toUpperCase())
    ..writeln()
    ..writeln('${l10n.shareTotal}: ${formatMoney(result.totalAmount)}')
    ..writeln('${l10n.participantsLabel}: ${result.participantCount}')
    ..writeln('${l10n.sharePerPerson}: ${formatMoney(result.amountPerPerson)}');

  if (result.transfers.isNotEmpty) {
    buffer.writeln();
    for (final t in result.transfers) {
      final from = names[t.fromParticipantId] ?? '?';
      final to = names[t.toParticipantId] ?? '?';
      buffer.writeln('$from → $to: ${formatMoney(t.amount)}');
    }
  }

  return buffer.toString().trimRight();
}

/// Copies [text] to the system clipboard and shows a brief, on-brand
/// confirmation.
///
/// The clipboard write is guarded: on some web environments it can throw
/// (e.g. "Document is not focused"), which must not prevent the user feedback.
void copyResultToClipboard(
  BuildContext context,
  String text,
  String confirmation,
) {
  // Confirm first so feedback is instant and independent of the (async,
  // occasionally-throwing on web) clipboard write.
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(confirmation, style: AppTextStyles.button),
        backgroundColor: AppColors.primaryAction,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration(seconds: 2),
      ),
    );
  // Fire-and-forget; errors here must not break the UX.
  copyTextToClipboard(text).catchError((_) {});
}
