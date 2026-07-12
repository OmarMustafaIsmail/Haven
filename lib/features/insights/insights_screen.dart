import 'package:flutter/material.dart';

import '../../models/pulse_state.dart';
import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_card.dart';
import '../engine/haven_engine.dart';
import '../engine/safe_to_spend.dart';
import '../home/models/pulse_status_copy.dart';
import '../moments/models/moment.dart';

/// Exposes what the Intelligence Engine currently knows — not a dashboard.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key, required this.engine});

  final HavenEngine engine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<List<Moment>>(
          valueListenable: engine.insights,
          builder: (context, insights, _) {
            return ValueListenableBuilder<SafeToSpendResult>(
              valueListenable: engine.safeToSpend,
              builder: (context, sts, _) {
                return ValueListenableBuilder<PulseState>(
                  valueListenable: engine.pulse,
                  builder: (context, pulse, _) {
                    return ListView(
                      padding: const EdgeInsets.all(HavenSpacing.md),
                      children: [
                        Text('Insights', style: HavenTypography.h1),
                        const SizedBox(height: HavenSpacing.xs),
                        Text(
                          'What Haven currently understands.',
                          style: HavenTypography.body.copyWith(
                            color: HavenColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: HavenSpacing.lg),
                        HavenCard(
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pulse', style: HavenTypography.title),
                              const SizedBox(height: HavenSpacing.sm),
                              Text(
                                PulseStatusCopy.financialState(pulse),
                                style: HavenTypography.body,
                              ),
                              const SizedBox(height: HavenSpacing.xs),
                              Text(
                                'State · ${pulse.name}',
                                style: HavenTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: HavenSpacing.md),
                        HavenCard(
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Safe to Spend',
                                style: HavenTypography.title,
                              ),
                              const SizedBox(height: HavenSpacing.sm),
                              Text(
                                _stsHeadline(sts),
                                style: HavenTypography.moneyEvidence,
                              ),
                              const SizedBox(height: HavenSpacing.xs),
                              Text(
                                _stsSubtitle(sts),
                                style: HavenTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: HavenSpacing.lg),
                        Text(
                          'Other observations',
                          style: HavenTypography.title,
                        ),
                        const SizedBox(height: HavenSpacing.sm),
                        if (insights.isEmpty)
                          HavenCard(
                            margin: EdgeInsets.zero,
                            child: Text(
                              'Nothing else competing right now. The highest-ranked observation is on Home.',
                              style: HavenTypography.body.copyWith(
                                color: HavenColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          for (final moment in insights) ...[
                            HavenCard(
                              margin: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    moment.type.name.toUpperCase(),
                                    style: HavenTypography.caption.copyWith(
                                      color: HavenColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: HavenSpacing.xs),
                                  Text(
                                    moment.title,
                                    style: HavenTypography.title,
                                  ),
                                  const SizedBox(height: HavenSpacing.xs),
                                  Text(
                                    moment.description,
                                    style: HavenTypography.body.copyWith(
                                      color: HavenColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: HavenSpacing.sm),
                          ],
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  static String _stsHeadline(SafeToSpendResult sts) {
    switch (sts.state) {
      case SafeToSpendState.unknown:
        return 'Not enough yet';
      case SafeToSpendState.estimated:
        return 'Around ${HavenTypography.formatAmount(sts.displayAmount ?? 0)}';
      case SafeToSpendState.confident:
        return HavenTypography.formatAmount(sts.displayAmount ?? 0);
    }
  }

  static String _stsSubtitle(SafeToSpendResult sts) {
    switch (sts.state) {
      case SafeToSpendState.unknown:
        return 'Haven needs a little more information.';
      case SafeToSpendState.estimated:
        return 'Based on what Haven currently knows.';
      case SafeToSpendState.confident:
        return 'A trustworthy floor — not a prediction.';
    }
  }
}
