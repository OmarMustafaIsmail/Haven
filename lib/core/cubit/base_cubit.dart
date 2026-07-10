import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cubit for Haven features.
abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);
}
