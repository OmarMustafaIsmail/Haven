import 'package:flutter/material.dart';

import '../../../models/pulse_state.dart';
import '../../../pulse/pulse_colors.dart';
import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import 'pulse_line.dart';

/// Hero wellbeing card — shifts down during pull unchanged; reading starts
/// only when Pulse reaches center (PD-030).
class HavenHeroCard extends StatefulWidget {
  const HavenHeroCard({
    super.key,
    required this.headline,
    required this.detail,
    required this.amount,
    required this.pulseState,
    this.isReading = false,
    this.pulseRevealed = true,
    this.onReadingComplete,
  });

  final String headline;
  final String detail;
  final num amount;
  final PulseState pulseState;
  final bool isReading;
  final bool pulseRevealed;
  final VoidCallback? onReadingComplete;

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

  void _onLineComplete() {
    widget.onReadingComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final accent = pulseColorFor(widget.pulseState);

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
                onComplete: _onLineComplete,
              ),
              const SizedBox(height: HavenSpacing.md),
            ],
            AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: widget.isReading && !widget.pulseRevealed ? 0.38 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: HavenSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 320),
                              opacity: widget.pulseRevealed ? 1 : 0,
                              child: Text(
                                widget.headline,
                                style: HavenTypography.title.copyWith(
                                  color: accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 320),
                              opacity: widget.pulseRevealed ? 1 : 0,
                              child: Text(
                                widget.detail,
                                style: HavenTypography.bodySmall.copyWith(
                                  color: HavenColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!widget.isReading) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: HavenSpacing.md,
                      ),
                      child: Divider(
                        height: 1,
                        color: HavenColors.borderSubtle.withValues(alpha: 0.85),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 320),
                      opacity: widget.pulseRevealed ? 1 : 0,
                      child: Row(
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
                                  HavenTypography.formatAmount(widget.amount),
                                  style: HavenTypography.h1.copyWith(
                                    fontSize: 28,
                                  ),
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
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: HavenColors.borderSubtle,
                              borderRadius:
                                  BorderRadius.circular(HavenRadius.full),
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
                        ],
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
