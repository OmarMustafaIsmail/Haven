import 'moment.dart';

/// Type-driven acknowledgement copy after a Moment action (PD-034).
abstract final class MomentAcknowledgementCopy {
  static String message(MomentType type) => switch (type) {
        MomentType.confirmation =>
          "Thanks.\nI've updated your financial picture.",
        MomentType.question => "Got it.\nI'll keep that in mind.",
        MomentType.reminder => "Noted.\nI'll remind you again if needed.",
        MomentType.insight => "Good to know.\nI'll watch for patterns.",
        MomentType.celebration => "Nice.\nI'll remember that.",
        MomentType.recommendation => "Great.\nYou're all set.",
        MomentType.information => "Understood.\nNothing else for now.",
      };

  static String activityLabel(Moment moment, MomentAction action) {
    return switch (action.outcome) {
      MomentActionOutcome.complete => switch (moment.type) {
          MomentType.confirmation => '${moment.title} confirmed',
          MomentType.celebration => 'Plan milestone acknowledged',
          MomentType.recommendation => 'Recommendation accepted',
          _ => 'Moment completed',
        },
      MomentActionOutcome.dismiss => 'Reminder dismissed',
      MomentActionOutcome.later => 'Saved for later',
      MomentActionOutcome.navigate => 'Opened from Moment',
    };
  }
}

class MomentAcknowledgement {
  const MomentAcknowledgement({
    required this.message,
    required this.momentId,
  });

  final String message;
  final String momentId;
}
