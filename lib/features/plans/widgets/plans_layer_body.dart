import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_spacing.dart';
import '../cubit/plans_cubit.dart';
import '../cubit/plans_state.dart';
import '../models/plan.dart';
import 'create_plan_sheet.dart';
import 'plan_detail_sheet.dart';
import 'plans_layer_sections.dart';

/// Plans layer body — typography-first intent view (PD-036).
class PlansLayerBody extends StatelessWidget {
  const PlansLayerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit, PlansState>(
      builder: (context, state) {
        final loaded = state is PlansLoadedState ? state : null;
        final active = loaded?.active ?? const <Plan>[];
        final completed = loaded?.completed ?? const <Plan>[];
        final suggested = loaded?.suggested ?? const <Plan>[];
        final activity = loaded?.recentActivity ?? const <PlanActivityItem>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: HavenSpacing.lg),
            PlansIntroSection(
              onCreatePlan: () => CreatePlanSheet.show(context),
            ),
            const SizedBox(height: HavenSpacing.xxl),
            PlansGroupSection(
              title: 'Active Plans',
              plans: active,
              emptyLabel: 'No active plans yet.',
              onPlanTap: (plan) => PlanDetailSheet.show(context, plan),
            ),
            const SizedBox(height: HavenSpacing.xxl),
            PlansGroupSection(
              title: 'Completed Plans',
              plans: completed,
              onPlanTap: (plan) => PlanDetailSheet.show(context, plan),
            ),
            if (suggested.isNotEmpty) ...[
              const SizedBox(height: HavenSpacing.xxl),
              PlansGroupSection(
                title: 'Suggested Plans',
                plans: suggested,
                onPlanTap: (plan) => PlanDetailSheet.show(context, plan),
                onSuggestedStart: (plan) =>
                    context.read<PlansCubit>().startSuggested(plan.id),
              ),
            ],
            const SizedBox(height: HavenSpacing.xxl),
            RecentPlanActivitySection(items: activity),
          ],
        );
      },
    );
  }
}
