import 'package:equatable/equatable.dart';

/// Categories of Moments — examples only; architecture is generic.
enum MomentType {
  confirmation,
  question,
  reminder,
  insight,
  celebration,
  recommendation,
  information,
}

enum MomentStatus {
  active,
  completed,
  dismissed,
}

enum MomentActionOutcome {
  complete,
  dismiss,
  later,
  navigate,
}

class MomentAction extends Equatable {
  const MomentAction({
    required this.id,
    required this.label,
    required this.outcome,
  });

  final String id;
  final String label;
  final MomentActionOutcome outcome;

  @override
  List<Object?> get props => [id, label, outcome];
}

/// The single most relevant thing Haven wants to share today (PD-034).
class Moment extends Equatable {
  const Moment({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.actions,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    this.status = MomentStatus.active,
    this.metadata = const {},
  });

  final String id;
  final MomentType type;
  final String title;
  final String description;
  final List<MomentAction> actions;
  final int priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final MomentStatus status;
  final Map<String, Object?> metadata;

  bool get isExpired {
    final expires = expiresAt;
    if (expires == null) return false;
    return DateTime.now().isAfter(expires);
  }

  bool get isActive => status == MomentStatus.active && !isExpired;

  Moment copyWith({
    MomentStatus? status,
    Map<String, Object?>? metadata,
  }) {
    return Moment(
      id: id,
      type: type,
      title: title,
      description: description,
      actions: actions,
      priority: priority,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        actions,
        priority,
        createdAt,
        expiresAt,
        status,
        metadata,
      ];
}
