import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../state/parties_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'edit_expenses_screen.dart';

/// Step 1 of building a party: its name and the list of participants.
class EditParticipantsScreen extends ConsumerStatefulWidget {
  const EditParticipantsScreen({super.key});

  @override
  ConsumerState<EditParticipantsScreen> createState() =>
      _EditParticipantsScreenState();
}

class _EditParticipantsScreenState
    extends ConsumerState<EditParticipantsScreen> {
  late final TextEditingController _nameController;
  final TextEditingController _participantController = TextEditingController();
  final FocusNode _participantFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(partiesControllerProvider).draft;
    _nameController = TextEditingController(text: draft?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _participantController.dispose();
    _participantFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _submitParticipant() {
    final name = _participantController.text.trim();
    if (name.isEmpty) return;
    final controller = ref.read(partiesControllerProvider.notifier);
    if (_editingId != null) {
      controller.renameParticipant(_editingId!, name);
    } else {
      controller.addParticipant(name);
    }
    _participantController.clear();
    setState(() => _editingId = null);
    _participantFocus.requestFocus();
  }

  void _startEdit(String id, String name) {
    setState(() => _editingId = id);
    _participantController.text = name;
    _participantController.selection = TextSelection.collapsed(offset: name.length);
    _participantFocus.requestFocus();
  }

  void _next(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditExpensesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Keep the name field in sync if the name was changed elsewhere
    // (e.g. on the expenses screen) and this field isn't being edited.
    ref.listen(partiesControllerProvider, (_, next) {
      final name = next.draft?.name ?? '';
      if (!_nameFocus.hasFocus && _nameController.text != name) {
        _nameController.text = name;
      }
    });

    final draft = ref.watch(partiesControllerProvider).draft;
    if (draft == null) return const Scaffold();

    final canProceed = draft.participants.length >= 2;

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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(l10n.editPartyTitle, style: AppTextStyles.h1),
                  const SizedBox(height: 24),
                  _UnderlineField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    hint: l10n.partyNameHint,
                    style: AppTextStyles.h2,
                    onChanged: (v) => ref
                        .read(partiesControllerProvider.notifier)
                        .renameDraft(v),
                  ),
                  const SizedBox(height: 32),
                  Text(l10n.participantsSection, style: AppTextStyles.caption),
                  const SizedBox(height: 12),
                  _AddRow(
                    controller: _participantController,
                    focusNode: _participantFocus,
                    hint: l10n.participantNameHint,
                    editing: _editingId != null,
                    onSubmit: _submitParticipant,
                  ),
                  const SizedBox(height: 4),
                  ...draft.participants.map(
                    (p) => _ParticipantRow(
                      name: p.name,
                      editing: _editingId == p.id,
                      onTap: () => _startEdit(p.id, p.name),
                      onDelete: () {
                        if (_editingId == p.id) {
                          _participantController.clear();
                          setState(() => _editingId = null);
                        }
                        ref
                            .read(partiesControllerProvider.notifier)
                            .deleteParticipant(p.id);
                      },
                    ),
                  ),
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
                label: l10n.nextAction,
                onPressed: canProceed ? () => _next(context) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Name input + add/confirm button used for adding and renaming participants.
class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.editing,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool editing;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            style: AppTextStyles.body,
            cursorColor: AppColors.primaryText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMuted,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryText),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: InkWell(
            onTap: onSubmit,
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                border: const Border.fromBorderSide(AppTheme.hairline),
              ),
              child: Icon(
                editing ? LucideIcons.check : LucideIcons.plus,
                size: 20,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({
    required this.name,
    required this.editing,
    required this.onTap,
    required this.onDelete,
  });

  final String name;
  final bool editing;
  final VoidCallback onTap;
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
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  name,
                  style: editing
                      ? AppTextStyles.body
                          .copyWith(color: AppColors.secondaryText)
                      : AppTextStyles.body,
                ),
              ),
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

/// A plain underlined text field.
class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.style,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextStyle style;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      style: style,
      cursorColor: AppColors.primaryText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style.copyWith(color: AppColors.secondaryText),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 12),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryText),
        ),
      ),
    );
  }
}
