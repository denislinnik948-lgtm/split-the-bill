import '../../../core/ids.dart';
import 'expense.dart';
import 'participant.dart';

enum PartyStatus { draft, completed }

/// A trip/event with its participants and expenses.
///
/// There is at most one [PartyStatus.draft] party at a time; completed parties
/// form the saved history.
class Party {
  const Party({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    this.participants = const [],
    this.expenses = const [],
  });

  factory Party.create() {
    return Party(
      id: newId(),
      name: '',
      createdAt: DateTime.now(),
      status: PartyStatus.draft,
      participants: const [],
      expenses: const [],
    );
  }

  final String id;
  final String name;
  final DateTime createdAt;
  final PartyStatus status;
  final List<Participant> participants;
  final List<Expense> expenses;

  bool get isDraft => status == PartyStatus.draft;

  /// Sum of every expense.
  double get total => expenses.fold(0, (sum, e) => sum + e.amount);

  /// Display name, or [fallback] (a localized "Untitled party") when blank.
  String displayNameOr(String fallback) =>
      name.trim().isEmpty ? fallback : name.trim();

  Party copyWith({
    String? name,
    PartyStatus? status,
    List<Participant>? participants,
    List<Expense>? expenses,
    DateTime? createdAt,
  }) {
    return Party(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      expenses: expenses ?? this.expenses,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'participants': participants.map((p) => p.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
      };

  factory Party.fromJson(Map<String, dynamic> json) {
    final participants = (json['participants'] as List<dynamic>? ?? const [])
        .map((p) => Participant.fromJson(p as Map<String, dynamic>))
        .toList();

    final List<Expense> expenses;
    if (json.containsKey('expenses')) {
      // New format: party-level expenses.
      expenses = (json['expenses'] as List<dynamic>? ?? const [])
          .map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      // Legacy format: expenses were nested under each participant, split
      // among everyone, paid by that participant. Migrate them up.
      expenses = [];
      for (final p in (json['participants'] as List<dynamic>? ?? const [])) {
        final map = p as Map<String, dynamic>;
        final payerId = map['id'] as String;
        for (final e in (map['expenses'] as List<dynamic>? ?? const [])) {
          final em = e as Map<String, dynamic>;
          expenses.add(Expense(
            id: em['id'] as String,
            title: em['title'] as String?,
            amount: (em['amount'] as num).toDouble(),
            payerId: payerId,
          ));
        }
      }
    }

    return Party(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: PartyStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PartyStatus.draft,
      ),
      participants: participants,
      expenses: expenses,
    );
  }
}
