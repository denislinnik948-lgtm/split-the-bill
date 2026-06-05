import 'package:flutter/material.dart';
import 'package:splittrip/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/app_info.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/party.dart';
import '../../info/screens/more_screen.dart';
import '../state/parties_controller.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/primary_button.dart';
import 'edit_participants_screen.dart';
import 'saved_calculation_screen.dart';

/// The app home: the current draft (if any), a New Party action and the saved
/// history.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _newParty(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(partiesControllerProvider.notifier);
    final hasDraft = ref.read(partiesControllerProvider).hasDraft;

    if (hasDraft) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.newPartyDialogTitle,
        message: l10n.newPartyDialogMessage,
        cancelLabel: l10n.cancel,
        confirmLabel: l10n.create,
      );
      if (!confirmed) return;
    }

    await controller.startNewDraft();
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditParticipantsScreen()),
    );
  }

  void _openDraft(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditParticipantsScreen()),
    );
  }

  void _openSaved(BuildContext context, String partyId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SavedCalculationScreen(partyId: partyId)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(partiesControllerProvider);
    final draft = state.draft;
    final saved = state.saved;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fixed header: title, current draft and the New Party action.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            kAppName,
                            style: AppTextStyles.display,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MoreScreen()),
                        ),
                        icon: const Icon(LucideIcons.info,
                            size: 24, color: AppColors.secondaryText),
                        splashRadius: 22,
                        tooltip: l10n.infoTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (draft != null) ...[
                    _SectionLabel(l10n.homeCurrentParty),
                    const SizedBox(height: 12),
                    _DraftRow(party: draft, onTap: () => _openDraft(context)),
                    const SizedBox(height: 32),
                  ],
                  PrimaryButton(
                    label: l10n.homeNewParty,
                    icon: LucideIcons.plus,
                    onPressed: () => _newParty(context, ref),
                  ),
                  const SizedBox(height: 32),
                  _SectionLabel(l10n.homeSavedParties),
                ],
              ),
            ),

            // Only the saved list scrolls; its edges fade so rows slip away
            // softly under the fixed header instead of being hard-cut.
            Expanded(
              child: saved.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _EmptySaved(),
                    )
                  : _FadingEdges(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: saved.length,
                        itemBuilder: (context, i) => _SavedRow(
                          party: saved[i],
                          onTap: () => _openSaved(context, saved[i].id),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Softly fades the top and bottom edges of a scrollable child into the
/// background, so scrolled rows fade out rather than clipping abruptly.
class _FadingEdges extends StatelessWidget {
  const _FadingEdges({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black,
          Colors.black,
          Colors.transparent,
        ],
        stops: [0.0, 0.035, 0.95, 1.0],
      ).createShader(rect),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.caption);
  }
}

class _DraftRow extends StatelessWidget {
  const _DraftRow({required this.party, required this.onTap});
  final Party party;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(party.displayNameOr(l10n.untitledParty),
                      style: AppTextStyles.h2),
                  const SizedBox(height: 6),
                  Text(
                    l10n.participantsCount(party.participants.length),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(formatMoney(party.total), style: AppTextStyles.h2),
          ],
        ),
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const _SavedRow({required this.party, required this.onTap});
  final Party party;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(party.createdAt);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(party.displayNameOr(l10n.untitledParty),
                      style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  Text(date, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(formatMoney(party.total), style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

class _EmptySaved extends StatelessWidget {
  const _EmptySaved();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        AppLocalizations.of(context).homeSavedEmpty,
        style: AppTextStyles.bodyMuted,
      ),
    );
  }
}
