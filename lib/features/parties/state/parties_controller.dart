import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/party_repository.dart';
import '../models/expense.dart';
import '../models/participant.dart';
import '../models/party.dart';

/// Provides the [PartyRepository]. Overridden in `main` once Hive is ready.
final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  throw UnimplementedError('partyRepositoryProvider must be overridden');
});

/// Snapshot of everything the UI needs: the live draft and saved history.
class PartiesState {
  const PartiesState({this.draft, this.saved = const []});

  final Party? draft;
  final List<Party> saved;

  bool get hasDraft => draft != null;
}

/// Single source of truth for parties. Every mutation persists immediately
/// (auto-save) and reloads from the repository so Home and editors stay in
/// sync after app restarts.
class PartiesController extends Notifier<PartiesState> {
  PartyRepository get _repo => ref.read(partyRepositoryProvider);

  @override
  PartiesState build() => _load();

  PartiesState _load() {
    return PartiesState(
      draft: _repo.getDraft(),
      saved: _repo.getCompleted(),
    );
  }

  Future<void> _persist(Party party) async {
    await _repo.save(party);
    state = _load();
  }

  /// Starts a fresh draft, discarding any existing one, and returns it.
  Future<Party> startNewDraft() async {
    final existing = _repo.getDraft();
    if (existing != null) {
      await _repo.delete(existing.id);
    }
    final party = Party.create();
    await _persist(party);
    return party;
  }

  Future<void> renameDraft(String name) async {
    final draft = state.draft;
    if (draft == null) return;
    await _persist(draft.copyWith(name: name));
  }

  // --- Participants -------------------------------------------------------

  /// Adds a participant with [name] to the draft and returns its id.
  Future<String?> addParticipant(String name) async {
    final draft = state.draft;
    if (draft == null) return null;
    final participant = Participant.create(name: name.trim());
    await _persist(draft.copyWith(
      participants: [...draft.participants, participant],
    ));
    return participant.id;
  }

  Future<void> renameParticipant(String participantId, String name) async {
    final draft = state.draft;
    if (draft == null) return;
    final participants = draft.participants
        .map((p) => p.id == participantId ? p.copyWith(name: name.trim()) : p)
        .toList();
    await _persist(draft.copyWith(participants: participants));
  }

  /// Removes a participant, dropping expenses they paid and excluding them from
  /// the remaining expenses' splits so no dangling references are left.
  Future<void> deleteParticipant(String participantId) async {
    final draft = state.draft;
    if (draft == null) return;
    final participants =
        draft.participants.where((p) => p.id != participantId).toList();
    final expenses = draft.expenses
        .where((e) => e.payerId != participantId)
        .map((e) => e.copyWith(
              excludedParticipantIds: e.excludedParticipantIds
                  .where((id) => id != participantId)
                  .toList(),
            ))
        .toList();
    await _persist(draft.copyWith(participants: participants, expenses: expenses));
  }

  // --- Expenses -----------------------------------------------------------

  /// Inserts or replaces an expense in the draft by id.
  Future<void> upsertExpense(Expense expense) async {
    final draft = state.draft;
    if (draft == null) return;
    final expenses = [...draft.expenses];
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index >= 0) {
      expenses[index] = expense;
    } else {
      expenses.add(expense);
    }
    await _persist(draft.copyWith(expenses: expenses));
  }

  Future<void> deleteExpense(String expenseId) async {
    final draft = state.draft;
    if (draft == null) return;
    final expenses = draft.expenses.where((e) => e.id != expenseId).toList();
    await _persist(draft.copyWith(expenses: expenses));
  }

  /// Completes the draft, moving it into saved history. Returns its id.
  Future<String?> completeDraft() async {
    final draft = state.draft;
    if (draft == null) return null;
    final completed = draft.copyWith(
      status: PartyStatus.completed,
      createdAt: DateTime.now(),
    );
    await _persist(completed);
    return completed.id;
  }

  Future<void> deleteParty(String id) async {
    await _repo.delete(id);
    state = _load();
  }
}

final partiesControllerProvider =
    NotifierProvider<PartiesController, PartiesState>(PartiesController.new);
