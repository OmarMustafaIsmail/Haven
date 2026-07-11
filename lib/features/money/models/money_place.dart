import 'package:equatable/equatable.dart';

/// Where money lives (PD-035).
enum MoneyPlaceSource {
  manual,
  connected,
}

class MoneyPlace extends Equatable {
  const MoneyPlace({
    required this.id,
    required this.name,
    required this.balance,
    this.source = MoneyPlaceSource.manual,
  });

  final String id;
  final String name;
  final int balance;
  final MoneyPlaceSource source;

  MoneyPlace copyWith({
    String? name,
    int? balance,
    MoneyPlaceSource? source,
  }) {
    return MoneyPlace(
      id: id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props => [id, name, balance, source];
}
