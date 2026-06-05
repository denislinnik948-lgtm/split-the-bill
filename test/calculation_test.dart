import 'package:flutter_test/flutter_test.dart';
import 'package:splittrip/features/parties/logic/calculation.dart';
import 'package:splittrip/features/parties/models/expense.dart';
import 'package:splittrip/features/parties/models/participant.dart';
import 'package:splittrip/features/parties/models/party.dart';

/// Builds a party where each named participant paid the given amount as one
/// expense split among everyone. Participant id == name for readability.
Party _party(Map<String, double> paidByName) {
  final participants =
      paidByName.keys.map((n) => Participant(id: n, name: n)).toList();
  final expenses = <Expense>[
    for (final entry in paidByName.entries)
      if (entry.value > 0)
        Expense(id: '${entry.key}-e', amount: entry.value, payerId: entry.key),
  ];
  return Party(
    id: 'p',
    name: 'Test',
    createdAt: DateTime(2026, 1, 1),
    status: PartyStatus.draft,
    participants: participants,
    expenses: expenses,
  );
}

void main() {
  group('calculateParty', () {
    test('spec example: Denis/Andrew/Olga', () {
      final result =
          calculateParty(_party({'Denis': 1000, 'Andrew': 500, 'Olga': 0}));

      expect(result.totalAmount, 1500);
      expect(result.participantCount, 3);
      expect(result.amountPerPerson, 500);

      expect(result.transfers.length, 1);
      final t = result.transfers.single;
      expect(t.fromParticipantId, 'Olga');
      expect(t.toParticipantId, 'Denis');
      expect(t.amount, 500);
    });

    test('everyone equal: no transfers', () {
      final result = calculateParty(_party({'A': 300, 'B': 300, 'C': 300}));
      expect(result.transfers, isEmpty);
      expect(result.amountPerPerson, 300);
    });

    test('minimises transfers (largest pays largest)', () {
      final result = calculateParty(_party({'A': 1000, 'B': 200, 'C': 0, 'D': 0}));
      expect(result.transfers.length, 3);
      expect(result.transfers.every((t) => t.toParticipantId == 'A'), isTrue);
      final total = result.transfers.fold<double>(0, (s, t) => s + t.amount);
      expect(total, closeTo(700, 0.001));
    });

    test('conserves money', () {
      final result =
          calculateParty(_party({'A': 900, 'B': 100, 'C': 50, 'D': 0, 'E': 0}));
      final total = result.transfers.fold<double>(0, (s, t) => s + t.amount);
      expect(total, closeTo(690, 0.001));
    });

    test('empty party is safe', () {
      final result = calculateParty(_party({}));
      expect(result.totalAmount, 0);
      expect(result.participantCount, 0);
      expect(result.transfers, isEmpty);
    });

    test('expense excluding a participant is split only among the rest', () {
      // A, B, C; one 300 expense paid by A, but C is excluded.
      final party = Party(
        id: 'p',
        name: 'Test',
        createdAt: DateTime(2026, 1, 1),
        status: PartyStatus.draft,
        participants: const [
          Participant(id: 'A', name: 'A'),
          Participant(id: 'B', name: 'B'),
          Participant(id: 'C', name: 'C'),
        ],
        expenses: const [
          Expense(
            id: 'e',
            amount: 300,
            payerId: 'A',
            excludedParticipantIds: ['C'],
          ),
        ],
      );

      final result = calculateParty(party);
      // Split 300 between A and B → 150 each. C owes nothing.
      expect(result.transfers.length, 1);
      final t = result.transfers.single;
      expect(t.fromParticipantId, 'B');
      expect(t.toParticipantId, 'A');
      expect(t.amount, 150);
    });
  });
}
