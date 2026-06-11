import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../models/expense.dart';
import '../models/participant.dart';
import '../state/parties_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/participant_chips.dart';
import '../widgets/primary_button.dart';
import 'calculation_screen.dart';

/// Step 2: the party's expenses. The party name and participants are shown at
/// the top (tap the participants to go back and edit them); below is the
/// expense composer and the list of expenses.
class EditExpensesScreen extends ConsumerStatefulWidget {
  const EditExpensesScreen({super.key});

  @override
  ConsumerState<EditExpensesScreen> createState() =>
      _EditExpensesScreenState();
}

class _EditExpensesScreenState extends ConsumerState<EditExpensesScreen> {
  late final TextEditingController _nameController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  String? _payerId;
  List<String> _excludedIds = [];
  String? _editingExpenseId;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(partiesControllerProvider).draft;
    _nameController = TextEditingController(text: draft?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _titleFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  void _resetComposer() {
    _titleController.clear();
    _amountController.clear();
    setState(() {
      _editingExpenseId = null;
      _payerId = null;
      _excludedIds = [];
      _amountError = null;
    });
  }

  Future<void> _submit(List<Participant> participants) async {
    final l10n = AppLocalizations.of(context);
    final amount = _parseAmount(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _amountError = l10n.amountInvalid);
      return;
    }
    setState(() => _amountError = null);

    // No payer chosen yet: open the picker straight away instead of nagging
    // with an inline error, then finish saving once one is selected.
    var payerOk = _payerId != null && participants.any((p) => p.id == _payerId);
    if (!payerOk) {
      await _pickPayer(participants);
      if (!mounted) return;
      payerOk = _payerId != null && participants.any((p) => p.id == _payerId);
      if (!payerOk) return; // dismissed without choosing — stay on the composer
    }

    final title = _titleController.text.trim();
    ref.read(partiesControllerProvider.notifier).upsertExpense(
          Expense(
            id: _editingExpenseId ?? Expense.create(amount: 0, payerId: '').id,
            title: title.isEmpty ? null : title,
            amount: amount,
            payerId: _payerId!,
            excludedParticipantIds: _excludedIds,
          ),
        );
    _resetComposer();
  }

  void _startEdit(Expense e, {required bool focusAmount}) {
    _titleController.text = e.title ?? '';
    _amountController.text = _formatInput(e.amount);
    setState(() {
      _editingExpenseId = e.id;
      _payerId = e.payerId;
      _excludedIds = [...e.excludedParticipantIds];
      _amountError = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusAmount) {
        _amountController.selection =
            TextSelection.collapsed(offset: _amountController.text.length);
        _amountFocus.requestFocus();
      } else {
        _titleController.selection =
            TextSelection.collapsed(offset: _titleController.text.length);
        _titleFocus.requestFocus();
      }
    });
  }

  Future<void> _pickPayer(List<Participant> participants) async {
    final picked = await showPayerPicker(
      context,
      participants: participants,
      selectedId: _payerId ?? '',
    );
    if (picked != null) {
      setState(() => _payerId = picked);
    }
  }

  Future<void> _pickSplit(List<Participant> participants) async {
    final result = await showSplitPicker(
      context,
      participants: participants,
      excludedIds: _excludedIds,
    );
    if (result != null) setState(() => _excludedIds = result);
  }

  void _calculate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CalculationScreen()),
    );
  }

  static double? _parseAmount(String text) {
    final t = text.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t.replaceAll(',', '.'));
  }

  static String _formatInput(double amount) {
    if (amount == amount.roundToDouble()) return amount.toInt().toString();
    return amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(partiesControllerProvider).draft;
    if (draft == null) return const Scaffold();

    final participants = draft.participants;
    final expenses = draft.expenses;
    final canCalculate = participants.length >= 2 && draft.total > 0;
    final payerName = _payerId == null
        ? null
        : participants
            .where((p) => p.id == _payerId)
            .map((p) => p.name)
            .firstOrNull;
    final includedCount =
        participants.where((p) => !_excludedIds.contains(p.id)).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppHeader(
                // Back goes straight Home; the draft is auto-saved.
                onBack: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  // Editable party name (tap to change).
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.h1,
                    cursorColor: AppColors.primaryText,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (v) => ref
                        .read(partiesControllerProvider.notifier)
                        .renameDraft(v),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: l10n.partyNameHint,
                      hintStyle: AppTextStyles.h1
                          .copyWith(color: AppColors.secondaryText),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Participants — plain list, tap to go back and edit.
                  _ParticipantsList(
                    label: l10n.participantsSection,
                    participants: participants,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 28),

                  Text(l10n.expensesSection, style: AppTextStyles.caption),
                  const SizedBox(height: 12),
                  _Composer(
                    titleController: _titleController,
                    amountController: _amountController,
                    titleFocus: _titleFocus,
                    amountFocus: _amountFocus,
                    titleHint: l10n.expenseTitleHint,
                    amountError: _amountError,
                    payerText: payerName ?? l10n.payerLabel,
                    splitText: _excludedIds.isEmpty
                        ? l10n.splitForAll
                        : l10n.splitForSome(includedCount),
                    onPickPayer: () => _pickPayer(participants),
                    onPickSplit: () => _pickSplit(participants),
                    editing: _editingExpenseId != null,
                    onSubmit: () => _submit(participants),
                    saveLabel: l10n.save,
                  ),

                  const SizedBox(height: 8),
                  ...expenses.map((e) {
                    final inc = participants
                        .where((p) => !e.excludedParticipantIds.contains(p.id))
                        .length;
                    final payer = participants
                        .where((p) => p.id == e.payerId)
                        .map((p) => p.name)
                        .firstOrNull;
                    final splitText = e.excludedParticipantIds.isEmpty
                        ? l10n.splitForAll
                        : l10n.splitForSome(inc);
                    final hasTitle = e.title?.trim().isNotEmpty ?? false;
                    return _ExpenseRow(
                      title: hasTitle ? e.title!.trim() : l10n.expenseTitleHint,
                      subtitle:
                          payer == null ? splitText : '$payer · $splitText',
                      amount: e.amount,
                      muted: !hasTitle,
                      onTapTitle: () => _startEdit(e, focusAmount: false),
                      onTapAmount: () => _startEdit(e, focusAmount: true),
                      onDelete: () {
                        if (_editingExpenseId == e.id) _resetComposer();
                        ref
                            .read(partiesControllerProvider.notifier)
                            .deleteExpense(e.id);
                      },
                    );
                  }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: PrimaryButton(
                label: l10n.calculate,
                onPressed: canCalculate ? () => _calculate(context) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plain (unframed) list of participant names; tapping returns to step 1.
class _ParticipantsList extends StatelessWidget {
  const _ParticipantsList({
    required this.label,
    required this.participants,
    required this.onTap,
  });

  final String label;
  final List<Participant> participants;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in participants)
                  SelectableChip(label: p.name, active: false, onTap: onTap),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.titleController,
    required this.amountController,
    required this.titleFocus,
    required this.amountFocus,
    required this.titleHint,
    required this.amountError,
    required this.payerText,
    required this.splitText,
    required this.onPickPayer,
    required this.onPickSplit,
    required this.editing,
    required this.onSubmit,
    required this.saveLabel,
  });

  final TextEditingController titleController;
  final TextEditingController amountController;
  final FocusNode titleFocus;
  final FocusNode amountFocus;
  final String titleHint;
  final String? amountError;
  final String payerText;
  final String splitText;
  final VoidCallback onPickPayer;
  final VoidCallback onPickSplit;
  final bool editing;
  final VoidCallback onSubmit;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: titleController,
                focusNode: titleFocus,
                style: AppTextStyles.body,
                cursorColor: AppColors.primaryText,
                textCapitalization: TextCapitalization.sentences,
                decoration: _underline(titleHint),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 110,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      focusNode: amountFocus,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.right,
                      cursorColor: AppColors.primaryText,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      decoration: _underline('0'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(kCurrencySign, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
          ],
        ),
        if (amountError != null) ...[
          const SizedBox(height: 8),
          Text(amountError!, style: AppTextStyles.caption),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _GhostButton(
                icon: LucideIcons.user,
                label: payerText,
                onTap: onPickPayer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GhostButton(label: splitText, onTap: onPickSplit),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SecondaryButton(
          label: saveLabel,
          icon: editing ? LucideIcons.check : LucideIcons.plus,
          onPressed: onSubmit,
        ),
      ],
    );
  }

  static InputDecoration _underline(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMuted,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryText),
        ),
      );
}

/// Low-emphasis pill button used for the payer and split selectors.
class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: const Border.fromBorderSide(AppTheme.hairline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: AppColors.secondaryText),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.muted,
    required this.onTapTitle,
    required this.onTapAmount,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final double amount;
  final bool muted;
  final VoidCallback onTapTitle;
  final VoidCallback onTapAmount;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTapTitle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: muted
                          ? AppTextStyles.body
                              .copyWith(color: AppColors.secondaryText)
                          : AppTextStyles.body,
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onTapAmount,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Text(formatMoney(amount), style: AppTextStyles.body),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(LucideIcons.trash2,
                size: 18, color: AppColors.secondaryText),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
