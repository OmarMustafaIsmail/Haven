import 'package:equatable/equatable.dart';

import '../../persistence/serialization.dart';

/// Expected future money movement (HAVEN_ENGINE.md).
enum CommitmentDirection {
  inflow,
  outflow,
}

enum CommitmentCadence {
  once,
  weekly,
  monthly,
  annual,
  irregular,
}

class Commitment extends Equatable {
  const Commitment({
    required this.id,
    required this.name,
    required this.direction,
    required this.amount,
    required this.cadence,
    required this.nextDate,
    this.confidence = 0.8,
    this.linkedPlaceId,
  });

  final String id;
  final String name;
  final CommitmentDirection direction;
  final int amount;
  final CommitmentCadence cadence;
  final DateTime nextDate;
  final double confidence;
  final String? linkedPlaceId;

  bool isDueOn(DateTime day) {
    return nextDate.year == day.year &&
        nextDate.month == day.month &&
        nextDate.day == day.day;
  }

  bool isDueWithin(DateTime from, Duration window) {
    final end = from.add(window);
    final startOfDay = DateTime(from.year, from.month, from.day);
    return !nextDate.isBefore(startOfDay) && !nextDate.isAfter(end);
  }

  Commitment copyWith({
    String? name,
    CommitmentDirection? direction,
    int? amount,
    CommitmentCadence? cadence,
    DateTime? nextDate,
    double? confidence,
    String? linkedPlaceId,
    bool clearLinkedPlace = false,
  }) {
    return Commitment(
      id: id,
      name: name ?? this.name,
      direction: direction ?? this.direction,
      amount: amount ?? this.amount,
      cadence: cadence ?? this.cadence,
      nextDate: nextDate ?? this.nextDate,
      confidence: confidence ?? this.confidence,
      linkedPlaceId:
          clearLinkedPlace ? null : (linkedPlaceId ?? this.linkedPlaceId),
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'direction': direction.name,
        'amount': amount,
        'cadence': cadence.name,
        'next_date': HavenSerialization.dateTimeToMillis(nextDate),
        'confidence': confidence,
        'linked_place_id': linkedPlaceId,
      };

  factory Commitment.fromMap(Map<String, Object?> map) {
    return Commitment(
      id: map['id'] as String,
      name: map['name'] as String,
      direction: CommitmentDirection.values.byName(map['direction'] as String),
      amount: map['amount'] as int,
      cadence: CommitmentCadence.values.byName(map['cadence'] as String),
      nextDate: HavenSerialization.dateTimeFromMillis(map['next_date'] as int)!,
      confidence: (map['confidence'] as num).toDouble(),
      linkedPlaceId: map['linked_place_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        direction,
        amount,
        cadence,
        nextDate,
        confidence,
        linkedPlaceId,
      ];
}
