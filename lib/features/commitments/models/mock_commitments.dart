import 'commitment.dart';

/// Omar persona — a few big, obvious commitments (MVP restraint).
abstract final class MockCommitments {
  static List<Commitment> seed({DateTime? now}) {
    final today = now ?? DateTime(2026, 7, 12);
    return [
      Commitment(
        id: 'cmt_salary',
        name: 'Salary',
        direction: CommitmentDirection.inflow,
        amount: 12000,
        cadence: CommitmentCadence.monthly,
        nextDate: today,
        confidence: 0.9,
        linkedPlaceId: 'place_main',
      ),
      Commitment(
        id: 'cmt_rent',
        name: 'Rent',
        direction: CommitmentDirection.outflow,
        amount: 8000,
        cadence: CommitmentCadence.monthly,
        nextDate: today.add(const Duration(days: 3)),
        confidence: 0.95,
        linkedPlaceId: 'place_main',
      ),
      Commitment(
        id: 'cmt_electricity',
        name: 'Electricity',
        direction: CommitmentDirection.outflow,
        amount: 450,
        cadence: CommitmentCadence.monthly,
        nextDate: today.add(const Duration(days: 1)),
        confidence: 0.7,
      ),
    ];
  }
}
