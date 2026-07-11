import 'package:flutter/material.dart';

import '../../../models/pulse_state.dart';
import '../../../pulse/pulse_colors.dart';
import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../../moments/models/moment.dart';
import '../../moments/models/moment_acknowledgement.dart';
import '../../moments/widgets/moment_acknowledgement.dart';
import '../../moments/widgets/moment_section.dart';
import '../models/pulse_status_copy.dart';
import 'pulse_line.dart';

/// Haven Hero — emotional center of Home (PD-032, PD-034).
///
/// Three layers in one calm conversation:
/// 1. Financial State (Pulse only)
/// 2. Safe to Spend (always dominant)
/// 3. active Moment (optional, max one)
class HavenHeroCard extends StatefulWidget {
  const HavenHeroCard({
    super.key,
    required this.pulseState,
    required this.safeToSpend,
    this.activeMoment,
    this.acknowledgement,
    this.isReading = false,
    this.pulseRevealed = true,
    this.onReadingComplete,
    this.onEnterMoney,
    this.onMomentAction,
  });

  final PulseState pulseState;
  final num safeToSpend;
  final Moment? activeMoment;
  final MomentAcknowledgement? acknowledgement;
  final bool isReading;
  final bool pulseRevealed;
  final VoidCallback? onReadingComplete;
  final VoidCallback? onEnterMoney;
  final void Function(Moment moment, MomentAction action)? onMomentAction;

  @override
  State<HavenHeroCard> createState() => _HavenHeroCardState();
}

class _HavenHeroCardState extends State<HavenHeroCard> {
  int _readingSession = 0;

  @override
  void didUpdateWidget(covariant HavenHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReading && !oldWidget.isReading) {
      _readingSession++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = pulseColorFor(widget.pulseState);
    final dimmed = widget.isReading && !widget.pulseRevealed;
    final showMomentLayer =
        widget.acknowledgement != null || widget.activeMoment != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HavenSpacing.md,
        vertical: HavenSpacing.xs,
      ),
      child: HavenCard(
        color: widget.isReading
            ? Color.alphaBlend(
                accent.withValues(alpha: 0.06),
                HavenColors.surface,
              )
            : HavenColors.surface,
        borderColor: widget.isReading
            ? accent.withValues(alpha: 0.22)
            : HavenColors.borderSubtle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isReading) ...[
              Text(
                'Reading your Pulse',
                style: HavenTypography.bodySmall.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: HavenSpacing.sm),
              PulseLine(
                key: ValueKey(_readingSession),
                color: accent,
                onComplete: widget.onReadingComplete,
              ),
              const SizedBox(height: HavenSpacing.lg),
            ],
            AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: dimmed ? 0.38 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FinancialStateLayer(
                    pulseState: widget.pulseState,
                    message: PulseStatusCopy.financialState(widget.pulseState),
                  ),
                  const SizedBox(height: HavenSpacing.lg),
                  _SafeToSpendLayer(
                    amount: widget.safeToSpend,
                    onEnterMoney:
                        !widget.isReading ? widget.onEnterMoney : null,
                  ),
                  if (showMomentLayer) ...[
                    const SizedBox(height: HavenSpacing.lg),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: widget.acknowledgement != null
                          ? MomentAcknowledgementWidget(
                              key: ValueKey(widget.acknowledgement!.momentId),
                              acknowledgement: widget.acknowledgement!,
                            )
                          : MomentSection(
                              key: ValueKey(widget.activeMoment!.id),
                              moment: widget.activeMoment!,
                              onAction: (action) => widget.onMomentAction?.call(
                                widget.activeMoment!,
                                action,
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Layer 1 — Financial State from Pulse only.
class _FinancialStateLayer extends StatelessWidget {
  const _FinancialStateLayer({
    required this.pulseState,
    required this.message,
  });

  final PulseState pulseState;
  final String message;

  @override
  Widget build(BuildContext context) {
    final accent = pulseColorFor(pulseState);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: HavenSpacing.md),
        Expanded(
          child: Text(
            message,
            style: HavenTypography.body.copyWith(
              color: HavenColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Layer 2 — Safe to Spend, visually dominant.
class _SafeToSpendLayer extends StatelessWidget {
  const _SafeToSpendLayer({
    required this.amount,
    this.onEnterMoney,
  });

  final num amount;
  final VoidCallback? onEnterMoney;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You can safely spend',
                style: HavenTypography.bodySmall.copyWith(
                  color: HavenColors.textSecondary,
                ),
              ),
              const SizedBox(height: HavenSpacing.xs),
              Text(
                HavenTypography.formatAmount(amount),
                style: HavenTypography.h1.copyWith(fontSize: 28),
              ),
              Text(
                'today',
                style: HavenTypography.bodySmall.copyWith(
                  color: HavenColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (onEnterMoney != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEnterMoney,
              borderRadius: BorderRadius.circular(HavenRadius.full),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: HavenColors.borderSubtle,
                  borderRadius: BorderRadius.circular(HavenRadius.full),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: HavenColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
