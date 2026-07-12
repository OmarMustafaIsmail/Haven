import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../models/plan.dart';

/// Opening continuity for the Plans layer (PD-036).
class PlansIntroSection extends StatelessWidget {
  const PlansIntroSection({super.key, this.onCreatePlan});

  final VoidCallback? onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Plans',
            style: HavenTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: HavenSpacing.sm),
          Text(
            "Your money isn't just sitting somewhere.\n"
            "It's working toward the life you're building.",
            style: HavenTypography.bodySmall.copyWith(
              color: HavenColors.textSecondary,
              height: 1.45,
            ),
          ),
          if (onCreatePlan != null) ...[
            const SizedBox(height: HavenSpacing.md),
            TextButton(
              onPressed: onCreatePlan,
              style: TextButton.styleFrom(
                foregroundColor: HavenColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Create a plan'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Section of plan rows under a title.
class PlansGroupSection extends StatelessWidget {
  const PlansGroupSection({
    super.key,
    required this.title,
    required this.plans,
    this.onPlanTap,
    this.onSuggestedStart,
    this.emptyLabel,
  });

  final String title;
  final List<Plan> plans;
  final ValueChanged<Plan>? onPlanTap;
  final ValueChanged<Plan>? onSuggestedStart;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty && emptyLabel == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: HavenTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: HavenSpacing.lg),
          if (plans.isEmpty)
            Text(
              emptyLabel!,
              style: HavenTypography.bodySmall.copyWith(
                color: HavenColors.textTertiary,
              ),
            )
          else
            for (var i = 0; i < plans.length; i++) ...[
              if (i > 0) const SizedBox(height: HavenSpacing.md),
              PlanRow(
                plan: plans[i],
                onTap: onPlanTap == null ? null : () => onPlanTap!(plans[i]),
                onStart: plans[i].status == PlanStatus.suggested &&
                        onSuggestedStart != null
                    ? () => onSuggestedStart!(plans[i])
                    : null,
              ),
            ],
        ],
      ),
    );
  }
}

/// Compact plan row with progress — used on the Plans layer list.
class PlanRow extends StatelessWidget {
  const PlanRow({
    super.key,
    required this.plan,
    this.onTap,
    this.onStart,
  });

  final Plan plan;
  final VoidCallback? onTap;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final accent = plan.color ?? HavenColors.primary;

    return HavenCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(HavenSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(HavenRadius.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(plan.icon, size: 18, color: accent),
                ),
              ),
              const SizedBox(width: HavenSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: HavenTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.status == PlanStatus.suggested
                          ? 'Suggested · ${HavenTypography.formatAmount(plan.targetAmount)}'
                          : '${HavenTypography.formatAmount(plan.allocatedAmount)} of ${HavenTypography.formatAmount(plan.targetAmount)}',
                      style: HavenTypography.caption.copyWith(
                        color: HavenColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onStart != null)
                TextButton(
                  onPressed: onStart,
                  style: TextButton.styleFrom(
                    foregroundColor: HavenColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: HavenSpacing.sm,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Start'),
                ),
            ],
          ),
          if (plan.status != PlanStatus.suggested) ...[
            const SizedBox(height: HavenSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(HavenRadius.full),
              child: LinearProgressIndicator(
                value: plan.progress,
                minHeight: 4,
                backgroundColor: HavenColors.borderSubtle,
                color: accent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Quiet recent plan activity list.
class RecentPlanActivitySection extends StatelessWidget {
  const RecentPlanActivitySection({
    super.key,
    required this.items,
  });

  final List<PlanActivityItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Plan Activity',
            style: HavenTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: HavenSpacing.lg),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: HavenSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    items[i].label,
                    style: HavenTypography.bodySmall.copyWith(
                      color: HavenColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  items[i].timestamp,
                  style: HavenTypography.caption.copyWith(
                    color: HavenColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
