/// A single payment from one participant to another that settles part of the
/// debt. Generated dynamically — never persisted.
class Transfer {
  const Transfer({
    required this.fromParticipantId,
    required this.toParticipantId,
    required this.amount,
  });

  final String fromParticipantId;
  final String toParticipantId;
  final double amount;
}
