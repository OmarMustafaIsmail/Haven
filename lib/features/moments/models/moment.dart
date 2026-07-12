import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../persistence/serialization.dart';

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

  Map<String, Object?> toMap() => {
        'id': id,
        'label': label,
        'outcome': outcome.name,
      };

  factory MomentAction.fromMap(Map<String, Object?> map) {
    return MomentAction(
      id: map['id'] as String,
      label: map['label'] as String,
      outcome: MomentActionOutcome.values.byName(map['outcome'] as String),
    );
  }

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

  /// Prefer [isExpiredAt] with [HavenClock] — wall clock only as fallback.
  bool get isExpired => isExpiredAt(DateTime.now());

  bool isExpiredAt(DateTime now) {
    final expires = expiresAt;
    if (expires == null) return false;
    return now.isAfter(expires);
  }

  bool get isActive => status == MomentStatus.active && !isExpired;

  bool isActiveAt(DateTime now) =>
      status == MomentStatus.active && !isExpiredAt(now);

  Moment copyWith({
    MomentStatus? status,
    Map<String, Object?>? metadata,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
  }) {
    return Moment(
      id: id,
      type: type,
      title: title,
      description: description,
      actions: actions,
      priority: priority,
      createdAt: createdAt,
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'actions_json': jsonEncode(actions.map((a) => a.toMap()).toList()),
        'priority': priority,
        'created_at': HavenSerialization.dateTimeToMillis(createdAt),
        'expires_at': HavenSerialization.dateTimeToMillis(expiresAt),
        'status': status.name,
        'metadata_json': jsonEncode(metadata),
      };

  factory Moment.fromMap(Map<String, Object?> map) {
    final actionsRaw =
        HavenSerialization.decodeJson(map['actions_json'] as String?) as List? ??
            const [];
    final metadataRaw =
        HavenSerialization.decodeJson(map['metadata_json'] as String?) as Map? ??
            const {};
    return Moment(
      id: map['id'] as String,
      type: MomentType.values.byName(map['type'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
      actions: actionsRaw
          .map((e) => MomentAction.fromMap(Map<String, Object?>.from(e as Map)))
          .toList(),
      priority: map['priority'] as int,
      createdAt:
          HavenSerialization.dateTimeFromMillis(map['created_at'] as int)!,
      expiresAt:
          HavenSerialization.dateTimeFromMillis(map['expires_at'] as int?),
      status: MomentStatus.values.byName(map['status'] as String),
      metadata: Map<String, Object?>.from(metadataRaw),
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
