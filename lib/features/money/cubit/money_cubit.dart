import '../../../core/cubit/base_cubit.dart';
import '../repository/money_place_repository.dart';
import 'money_state.dart';

class MoneyCubit extends BaseCubit<MoneyState> {
  MoneyCubit({required MoneyPlaceRepository repository})
      : _repository = repository,
        super(
          MoneyLoadedState(
            places: repository.places,
            totalBalance: repository.totalBalance,
          ),
        ) {
    _repository.version.addListener(_onChanged);
  }

  final MoneyPlaceRepository _repository;

  void _onChanged() {
    emit(
      MoneyLoadedState(
        places: _repository.places,
        totalBalance: _repository.totalBalance,
      ),
    );
  }

  void addPlace({required String name, required int balance}) {
    _repository.add(name: name, balance: balance);
  }

  void editPlace({
    required String id,
    required String name,
    required int balance,
  }) {
    _repository.edit(id: id, name: name, balance: balance);
  }

  void updateBalance({required String id, required int balance}) {
    _repository.updateBalance(id: id, balance: balance);
  }

  void deletePlace(String id) {
    _repository.delete(id);
  }

  @override
  Future<void> close() {
    _repository.version.removeListener(_onChanged);
    return super.close();
  }
}
