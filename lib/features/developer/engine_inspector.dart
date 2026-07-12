import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_card.dart';
import '../engine/safe_to_spend.dart';
import '../moments/models/moment.dart';
import '../plans/models/plan.dart';
import '../shell/app_shell.dart';

/// Read-only engine pipeline view for validation (Facts → Derived → Moments).
class EngineInspector extends StatelessWidget {
  const EngineInspector({super.key, required this.services});

  final HavenAppServices services;

  @override
  Widget build(BuildContext context) {
    final s = services;
    final engine = s.engine;
    final now = s.clock.now();
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');
    final places = s.moneyPlaceRepository.places;
    final commitments = s.commitmentRepository.items;
    final plans = s.planRepository.plans;
    final sts = engine.safeToSpend.value;
    final candidates = engine.candidates.value;
    final winning = s.momentRepository.activeMoment;

    return ListView(
      padding: const EdgeInsets.all(HavenSpacing.md),
      children: [
        _Block(
          title: 'Facts',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('Clock', dateFmt.format(now)),
              _kv('Money Places', '${places.length}'),
              for (final p in places)
                _kv('  · ${p.name}', '${p.balance}'),
              _kv('Commitments', '${commitments.length}'),
              for (final c in commitments)
                _kv(
                  '  · ${c.name}',
                  '${c.direction.name} ${c.amount} · ${dateFmt.format(c.nextDate)}',
                ),
              _kv('Plans', '${plans.length}'),
              for (final plan in plans)
                _kv(
                  '  · ${plan.name}',
                  '${plan.status.name}'
                      '${plan.targetDate == null ? '' : ' · ${dateFmt.format(plan.targetDate!)}'}',
                ),
            ],
          ),
        ),
        _Block(
          title: 'Derived',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('Safe to Spend', _stsLabel(sts)),
              _kv('Available', '${sts.breakdown.availableMoney}'),
              _kv('Commitment hold', '${sts.breakdown.commitmentHold}'),
              _kv('Plan intention hold', '${sts.breakdown.planIntentionHold}'),
              _kv('Safety margin', '${sts.breakdown.safetyMargin}'),
              _kv('Pulse', engine.pulse.value.name),
              const SizedBox(height: HavenSpacing.sm),
              Text('Plan confidence', style: HavenTypography.caption),
              const SizedBox(height: HavenSpacing.xs),
              for (final plan
                  in plans.where((p) => p.status == PlanStatus.active))
                _kv(
                  plan.name,
                  PlanConfidence.band(
                    plan,
                    now: now,
                    places: places,
                  ).memberLabel,
                ),
            ],
          ),
        ),
        _Block(
          title: 'Candidate Moments',
          child: candidates.isEmpty
              ? Text(
                  'None observed.',
                  style: HavenTypography.bodySmall.copyWith(
                    color: HavenColors.textTertiary,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < candidates.length; i++)
                      _candidateRow(i + 1, candidates[i]),
                  ],
                ),
        ),
        _Block(
          title: 'Winning Moment',
          child: winning == null
              ? Text(
                  'No active Moment.',
                  style: HavenTypography.bodySmall.copyWith(
                    color: HavenColors.textTertiary,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Title', winning.title),
                    _kv('Type', winning.type.name),
                    _kv('Priority', '${winning.priority}'),
                    _kv('Reason', _reason(winning)),
                  ],
                ),
        ),
        _Block(
          title: 'Learning',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv(
                'Suppressed ids',
                engine.suppressedIds.isEmpty
                    ? '—'
                    : engine.suppressedIds.join(', '),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _candidateRow(int rank, Moment m) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#$rank · ${m.title}',
            style: HavenTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'score ${m.priority} · ${_reason(m)}',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _reason(Moment m) {
    final meta = m.metadata;
    if (meta.containsKey('commitmentId')) {
      return 'commitment ${meta['commitmentId']}';
    }
    if (meta.containsKey('planId')) {
      return 'plan ${meta['planId']}';
    }
    return m.type.name;
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(key, style: HavenTypography.caption),
          ),
          Expanded(child: Text(value, style: HavenTypography.bodySmall)),
        ],
      ),
    );
  }

  String _stsLabel(SafeToSpendResult sts) {
    switch (sts.state) {
      case SafeToSpendState.unknown:
        return 'Unknown';
      case SafeToSpendState.estimated:
        return 'Estimated · ${sts.displayAmount ?? 0}';
      case SafeToSpendState.confident:
        return 'Confident · ${sts.displayAmount ?? 0}';
    }
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.lg),
      child: HavenCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: HavenTypography.title),
            const SizedBox(height: HavenSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
