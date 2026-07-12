import 'package:equatable/equatable.dart';

import '../models/moment.dart';
import '../models/moment_acknowledgement.dart';

sealed class MomentsState extends Equatable {
  const MomentsState();

  @override
  List<Object?> get props => [];
}

final class MomentsLoadedState extends MomentsState {
  const MomentsLoadedState({
    this.activeMoment,
    this.acknowledgement,
  });

  final Moment? activeMoment;
  final MomentAcknowledgement? acknowledgement;

  MomentsLoadedState copyWith({
    Moment? activeMoment,
    MomentAcknowledgement? acknowledgement,
    bool clearAcknowledgement = false,
    bool clearActiveMoment = false,
  }) {
    return MomentsLoadedState(
      activeMoment: clearActiveMoment ? null : (activeMoment ?? this.activeMoment),
      acknowledgement: clearAcknowledgement
          ? null
          : (acknowledgement ?? this.acknowledgement),
    );
  }

  @override
  List<Object?> get props => [activeMoment, acknowledgement];
}
