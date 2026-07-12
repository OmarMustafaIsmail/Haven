import 'package:equatable/equatable.dart';

import '../models/money_place.dart';

sealed class MoneyState extends Equatable {
  const MoneyState();

  @override
  List<Object?> get props => [];
}

final class MoneyLoadedState extends MoneyState {
  const MoneyLoadedState({
    required this.places,
    required this.totalBalance,
  });

  final List<MoneyPlace> places;
  final int totalBalance;

  @override
  List<Object?> get props => [places, totalBalance];
}
