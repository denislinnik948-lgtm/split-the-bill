import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/participant.dart';

/// A pill-shaped selectable chip. Active = filled black; inactive = outlined.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primaryAction : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: active ? AppColors.primaryAction : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: active
                ? AppTextStyles.body.copyWith(color: AppColors.buttonText)
                : AppTextStyles.body.copyWith(color: AppColors.secondaryText),
          ),
        ),
      ),
    );
  }
}

/// Single-select: who paid. Returns the chosen participant id, or null if
/// dismissed.
Future<String?> showPayerPicker(
  BuildContext context, {
  required List<Participant> participants,
  required String selectedId,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<String>(
    context: context,
    builder: (context) => _PickerDialog(
      title: l10n.payerTitle,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final p in participants)
            SelectableChip(
              label: p.name,
              active: p.id == selectedId,
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    ),
  );
}

/// Multi-select: which participants share the expense. Returns the new list of
/// excluded ids, or null if dismissed. Always keeps at least one included.
Future<List<String>?> showSplitPicker(
  BuildContext context, {
  required List<Participant> participants,
  required List<String> excludedIds,
}) {
  final l10n = AppLocalizations.of(context);
  final excluded = {...excludedIds};
  return showDialog<List<String>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _PickerDialog(
            title: l10n.splitTitle,
            action: TextButton(
              onPressed: () => Navigator.of(context).pop(excluded.toList()),
              child: Text(l10n.doneAction, style: AppTextStyles.body),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in participants)
                  SelectableChip(
                    label: p.name,
                    active: !excluded.contains(p.id),
                    onTap: () {
                      final active = !excluded.contains(p.id);
                      final activeCount = participants
                          .where((x) => !excluded.contains(x.id))
                          .length;
                      // Keep at least one participant included.
                      if (active && activeCount <= 1) return;
                      setState(() {
                        if (active) {
                          excluded.add(p.id);
                        } else {
                          excluded.remove(p.id);
                        }
                      });
                    },
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _PickerDialog extends StatelessWidget {
  const _PickerDialog({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h2),
            const SizedBox(height: 20),
            child,
            if (action != null) ...[
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerRight, child: action!),
            ],
          ],
        ),
      ),
    );
  }
}
