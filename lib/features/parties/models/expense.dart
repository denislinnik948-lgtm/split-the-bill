import '../../../core/ids.dart';

/// A party-level expense: an amount paid by one participant ([payerId]) and
/// split among the participants who are not in [excludedParticipantIds].
///
/// An empty [excludedParticipantIds] means the expense is split among everyone
/// ("for all"). Storing exclusions (rather than an explicit include list) keeps
/// a "for all" expense inclusive even when new participants are added later.
class Expense {
  const Expense({
    required this.id,
    this.title,
    required this.amount,
    required this.payerId,
    this.excludedParticipantIds = const [],
  });

  factory Expense.create({
    String? title,
    required double amount,
    required String payerId,
    List<String> excludedParticipantIds = const [],
  }) {
    return Expense(
      id: newId(),
      title: title,
      amount: amount,
      payerId: payerId,
      excludedParticipantIds: excludedParticipantIds,
    );
  }

  final String id;
  final String? title;
  final double amount;
  final String payerId;
  final List<String> excludedParticipantIds;

  /// Whether [participantId] shares this expense.
  bool includes(String participantId) =>
      !excludedParticipantIds.contains(participantId);

  Expense copyWith({
    String? title,
    double? amount,
    String? payerId,
    List<String>? excludedParticipantIds,
    bool clearTitle = false,
  }) {
    return Expense(
      id: id,
      title: clearTitle ? null : (title ?? this.title),
      amount: amount ?? this.amount,
      payerId: payerId ?? this.payerId,
      excludedParticipantIds:
          excludedParticipantIds ?? this.excludedParticipantIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'payerId': payerId,
        'excludedParticipantIds': excludedParticipantIds,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] as String,
        title: json['title'] as String?,
        amount: (json['amount'] as num).toDouble(),
        payerId: json['payerId'] as String? ?? '',
        excludedParticipantIds:
            (json['excludedParticipantIds'] as List<dynamic>? ?? const [])
                .map((e) => e as String)
                .toList(),
      );
}
