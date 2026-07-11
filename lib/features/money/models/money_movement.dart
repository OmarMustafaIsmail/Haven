class MoneyMovement {
  const MoneyMovement({
    required this.label,
    required this.amount,
    this.timestamp,
  });

  final String label;
  final int amount;
  final String? timestamp;
}
