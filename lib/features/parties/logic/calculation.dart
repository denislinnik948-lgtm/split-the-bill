import '../models/party.dart';
import 'transfer.dart';

/// The dynamically computed outcome of a party. Never persisted.
class CalculationResult {
  const CalculationResult({
    required this.totalAmount,
    required this.participantCount,
    required this.amountPerPerson,
    required this.transfers,
  });

  final double totalAmount;
  final int participantCount;
  final double amountPerPerson;
  final List<Transfer> transfers;
}

/// Amounts below this (in hryvnia) are treated as zero. Guards against
/// floating-point dust when balances don't divide evenly.
const double _epsilon = 0.005;

/// Computes totals and the minimal transfer list to settle a party.
///
/// Each expense is split equally among the participants it includes; the payer
/// is credited the full amount. A participant's balance is what they paid minus
/// the sum of their shares. Transfers are minimised with a greedy
/// largest-debtor-pays-largest-creditor strategy.
CalculationResult calculateParty(Party party) {
  final participants = party.participants;
  final count = participants.length;
  final total = party.total;
  final perPerson = count == 0 ? 0.0 : total / count;

  final paid = {for (final p in participants) p.id: 0.0};
  final share = {for (final p in participants) p.id: 0.0};

  for (final expense in party.expenses) {
    if (paid.containsKey(expense.payerId)) {
      paid[expense.payerId] = paid[expense.payerId]! + expense.amount;
    }
    var included = participants.where((p) => expense.includes(p.id)).toList();
    if (included.isEmpty) included = participants;
    if (included.isEmpty) continue;
    final per = expense.amount / included.length;
    for (final p in included) {
      share[p.id] = share[p.id]! + per;
    }
  }

  final creditors = <_Balance>[];
  final debtors = <_Balance>[];
  for (final p in participants) {
    final balance = paid[p.id]! - share[p.id]!;
    if (balance > _epsilon) {
      creditors.add(_Balance(p.id, balance));
    } else if (balance < -_epsilon) {
      debtors.add(_Balance(p.id, -balance));
    }
  }

  creditors.sort((a, b) => b.amount.compareTo(a.amount));
  debtors.sort((a, b) => b.amount.compareTo(a.amount));

  final transfers = <Transfer>[];
  var i = 0;
  var j = 0;
  while (i < creditors.length && j < debtors.length) {
    final creditor = creditors[i];
    final debtor = debtors[j];
    final amount =
        creditor.amount < debtor.amount ? creditor.amount : debtor.amount;

    transfers.add(Transfer(
      fromParticipantId: debtor.id,
      toParticipantId: creditor.id,
      amount: amount,
    ));

    creditor.amount -= amount;
    debtor.amount -= amount;
    if (creditor.amount <= _epsilon) i++;
    if (debtor.amount <= _epsilon) j++;
  }

  return CalculationResult(
    totalAmount: total,
    participantCount: count,
    amountPerPerson: perPerson,
    transfers: transfers,
  );
}

class _Balance {
  _Balance(this.id, this.amount);
  final String id;
  double amount;
}
