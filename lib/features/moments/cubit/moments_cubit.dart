import '../../../core/cubit/base_cubit.dart';
import '../../activity/repository/activity_repository.dart';
import '../../engine/haven_engine.dart';
import '../models/moment.dart';
import '../models/moment_acknowledgement.dart';
import '../repository/moment_repository.dart';
import 'moments_state.dart';

class MomentsCubit extends BaseCubit<MomentsState> {
  MomentsCubit({
    required MomentRepository momentRepository,
    required ActivityRepository activityRepository,
    HavenEngine? engine,
  })  : _momentRepository = momentRepository,
        _activityRepository = activityRepository,
        _engine = engine,
        super(const MomentsLoadedState()) {
    _momentRepository.version.addListener(_onMomentsChanged);
    _emitFromRepository();
  }

  final MomentRepository _momentRepository;
  final ActivityRepository _activityRepository;
  final HavenEngine? _engine;

  static const Duration _acknowledgementDuration = Duration(milliseconds: 2200);

  void _onMomentsChanged() => _emitFromRepository();

  void _emitFromRepository() {
    final current = state;
    if (current is! MomentsLoadedState) return;
    emit(current.copyWith(activeMoment: _momentRepository.activeMoment));
  }

  Future<void> act(Moment moment, MomentAction action) async {
    final current = state;
    if (current is! MomentsLoadedState) return;

    switch (action.outcome) {
      case MomentActionOutcome.complete:
        _momentRepository.complete(moment.id);
      case MomentActionOutcome.dismiss:
        _momentRepository.dismiss(moment.id);
        _engine?.rememberDismissal(moment.id);
      case MomentActionOutcome.later:
        _momentRepository.dismiss(moment.id);
      case MomentActionOutcome.navigate:
        _momentRepository.complete(moment.id);
    }

    _activityRepository.addInteraction(
      label: MomentAcknowledgementCopy.activityLabel(moment, action),
    );

    emit(
      current.copyWith(
        acknowledgement: MomentAcknowledgement(
          message: MomentAcknowledgementCopy.message(moment.type),
          momentId: moment.id,
        ),
        clearActiveMoment: true,
      ),
    );

    await Future<void>.delayed(_acknowledgementDuration);
    if (isClosed) return;

    final latest = state;
    if (latest is MomentsLoadedState &&
        latest.acknowledgement?.momentId == moment.id) {
      emit(latest.copyWith(clearAcknowledgement: true));
    }
  }

  @override
  Future<void> close() {
    _momentRepository.version.removeListener(_onMomentsChanged);
    return super.close();
  }
}
