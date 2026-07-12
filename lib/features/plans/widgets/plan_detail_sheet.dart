import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../models/plan.dart';

/// Plan detail sheet — progress, place, milestones, contributions (PD-036).
class PlanDetailSheet extends StatelessWidget {
  const PlanDetailSheet({super.key, required this.plan});

  final Plan plan;

  static Future<void> show(BuildContext context, Plan plan) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: HavenColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlanDetailSheet(plan: plan),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = plan.color ?? HavenColors.primary;
    final height = MediaQuery.sizeOf(context).height * 0.86;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HavenSpacing.lg,
          HavenSpacing.lg,
          HavenSpacing.lg,
          HavenSpacing.xxl,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(HavenRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(plan.icon, color: accent, size: 22),
                  ),
                ),
                const SizedBox(width: HavenSpacing.md),
                Expanded(
                  child: Text(plan.name, style: HavenTypography.title),
                ),
              ],
            ),
            const SizedBox(height: HavenSpacing.xxl),
            Text(
              'Progress',
              style: HavenTypography.caption.copyWith(
                color: HavenColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: HavenSpacing.sm),
            Text(
              '${(plan.progress * 100).round()}%',
              style: HavenTypography.h1.copyWith(fontSize: 32),
            ),
            const SizedBox(height: HavenSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(HavenRadius.full),
              child: LinearProgressIndicator(
                value: plan.progress,
                minHeight: 6,
                backgroundColor: HavenColors.borderSubtle,
                color: accent,
              ),
            ),
            const SizedBox(height: HavenSpacing.xxl),
            _FactRow(
              label: 'Target',
              value: HavenTypography.formatAmount(plan.targetAmount),
            ),
            const SizedBox(height: HavenSpacing.md),
            _FactRow(
              label: 'Allocated',
              value: HavenTypography.formatAmount(plan.allocatedAmount),
            ),
            if (plan.connectedPlaceName != null) ...[
              const SizedBox(height: HavenSpacing.md),
              _FactRow(
                label: 'Connected Money Place',
                value: plan.connectedPlaceName!,
              ),
            ],
            if (plan.targetDate != null) ...[
              const SizedBox(height: HavenSpacing.md),
              _FactRow(
                label: 'Target date',
                value: DateFormat.yMMMd().format(plan.targetDate!),
              ),
            ],
            if (plan.milestones.isNotEmpty) ...[
              const SizedBox(height: HavenSpacing.xxl),
              Text(
                'Upcoming milestones',
                style: HavenTypography.title.copyWith(fontSize: 16),
              ),
              const SizedBox(height: HavenSpacing.lg),
              for (final milestone in plan.milestones) ...[
                Row(
                  children: [
                    Icon(
                      milestone.reached
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: milestone.reached
                          ? accent
                          : HavenColors.textTertiary,
                    ),
                    const SizedBox(width: HavenSpacing.sm),
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: HavenTypography.bodySmall.copyWith(
                          color: milestone.reached
                              ? HavenColors.textSecondary
                              : HavenColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      HavenTypography.formatAmount(milestone.targetAmount),
                      style: HavenTypography.caption.copyWith(
                        color: HavenColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HavenSpacing.md),
              ],
            ],
            if (plan.contributions.isNotEmpty) ...[
              const SizedBox(height: HavenSpacing.lg),
              Text(
                'Recent contributions',
                style: HavenTypography.title.copyWith(fontSize: 16),
              ),
              const SizedBox(height: HavenSpacing.lg),
              for (final contribution in plan.contributions) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contribution.label,
                            style: HavenTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            contribution.timestamp,
                            style: HavenTypography.caption.copyWith(
                              color: HavenColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      HavenTypography.formatSignedAmount(contribution.amount),
                      style: HavenTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HavenSpacing.md),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            label,
            style: HavenTypography.bodySmall.copyWith(
              color: HavenColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: HavenTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
