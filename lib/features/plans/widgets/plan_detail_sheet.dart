import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_choice_chip.dart';
import '../../../widgets/haven_primary_button.dart';
import '../../../widgets/haven_sheet.dart';
import '../../../widgets/haven_text_button.dart';
import '../../../widgets/haven_text_field.dart';
import '../../developer/developer_scope.dart';
import '../../engine/safe_to_spend.dart';
import '../../money/cubit/money_cubit.dart';
import '../../money/cubit/money_state.dart';
import '../../money/models/money_place.dart';
import '../cubit/plans_cubit.dart';
import '../cubit/plans_state.dart';
import '../models/plan.dart';

/// Plan detail — progress, confidence, allocation edit (PD-036, PD-039).
class PlanDetailSheet extends StatelessWidget {
  const PlanDetailSheet({super.key, required this.plan});

  final Plan plan;

  static Future<void> show(BuildContext context, Plan plan) {
    final plansCubit = context.read<PlansCubit>();
    final moneyCubit = context.read<MoneyCubit>();

    return HavenSheet.show<void>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: plansCubit),
          BlocProvider.value(value: moneyCubit),
        ],
        child: PlanDetailSheet(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moneyState = context.watch<MoneyCubit>().state;
    final places =
        moneyState is MoneyLoadedState ? moneyState.places : <MoneyPlace>[];
    final now = DeveloperScope.maybeOf(context)?.services.clock.now() ??
        DateTime.now();

    Plan current = plan;
    final plansState = context.watch<PlansCubit>().state;
    if (plansState is PlansLoadedState) {
      for (final p in plansState.plans) {
        if (p.id == plan.id) {
          current = p;
          break;
        }
      }
    }

    final accent = current.color ?? HavenColors.primary;
    final effective = current.effectiveAllocated(places);
    final progress = current.effectiveProgress(places);
    final band = PlanConfidence.band(current, now: now, places: places);
    final height = MediaQuery.sizeOf(context).height * 0.86;

    return SizedBox(
      height: height,
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
                  child: Icon(current.icon, color: accent, size: 22),
                ),
              ),
              const SizedBox(width: HavenSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(current.name, style: HavenTypography.title),
                    const SizedBox(height: 2),
                    Text(
                      'Confidence · ${band.memberLabel}',
                      style: HavenTypography.caption.copyWith(
                        color: HavenColors.textSecondary,
                      ),
                    ),
                  ],
                ),
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
            '${(progress * 100).round()}%',
            style: HavenTypography.h1.copyWith(fontSize: 32),
          ),
          const SizedBox(height: HavenSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(HavenRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: HavenColors.borderSubtle,
              color: accent,
            ),
          ),
          const SizedBox(height: HavenSpacing.xxl),
          _FactRow(
            label: 'Target',
            value: HavenTypography.formatAmount(current.targetAmount),
          ),
          const SizedBox(height: HavenSpacing.md),
          _FactRow(
            label: 'Allocated (lens)',
            value: HavenTypography.formatAmount(current.allocatedAmount),
          ),
          const SizedBox(height: HavenSpacing.md),
          _FactRow(
            label: 'Effective now',
            value: HavenTypography.formatAmount(effective),
          ),
          const SizedBox(height: HavenSpacing.md),
          _FactRow(
            label: 'Priority',
            value: current.priority.memberLabel,
          ),
          if (current.connectedPlaceName != null) ...[
            const SizedBox(height: HavenSpacing.md),
            _FactRow(
              label: 'Connected places',
              value: current.connectedPlaceName!,
            ),
          ],
          if (current.targetDate != null) ...[
            const SizedBox(height: HavenSpacing.md),
            _FactRow(
              label: 'Target date',
              value: DateFormat.yMMMd().format(current.targetDate!),
            ),
          ],
          if (current.status == PlanStatus.active) ...[
            const SizedBox(height: HavenSpacing.lg),
            HavenTextButton(
              label: 'Edit allocation',
              onPressed: () => _AllocationEditor.show(
                context,
                plan: current,
                places: places,
              ),
            ),
          ],
          if (current.milestones.isNotEmpty) ...[
            const SizedBox(height: HavenSpacing.xxl),
            Text(
              'Upcoming milestones',
              style: HavenTypography.title.copyWith(fontSize: 16),
            ),
            const SizedBox(height: HavenSpacing.lg),
            for (final milestone in current.milestones) ...[
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
          if (current.contributions.isNotEmpty) ...[
            const SizedBox(height: HavenSpacing.lg),
            Text(
              'Recent contributions',
              style: HavenTypography.title.copyWith(fontSize: 16),
            ),
            const SizedBox(height: HavenSpacing.lg),
            for (final contribution in current.contributions) ...[
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
    );
  }
}

class _AllocationEditor extends StatefulWidget {
  const _AllocationEditor({
    required this.plan,
    required this.places,
  });

  final Plan plan;
  final List<MoneyPlace> places;

  static Future<void> show(
    BuildContext context, {
    required Plan plan,
    required List<MoneyPlace> places,
  }) {
    final plansCubit = context.read<PlansCubit>();
    return HavenSheet.show<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: plansCubit,
        child: _AllocationEditor(plan: plan, places: places),
      ),
    );
  }

  @override
  State<_AllocationEditor> createState() => _AllocationEditorState();
}

class _AllocationEditorState extends State<_AllocationEditor> {
  late final TextEditingController _amount;
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(
      text: widget.plan.allocatedAmount > 0
          ? '${widget.plan.allocatedAmount}'
          : '',
    );
    _selected = Set<String>.from(widget.plan.connectedPlaceIds);
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int get _sum => widget.places
      .where((p) => _selected.contains(p.id))
      .fold(0, (s, p) => s + p.balance);

  void _save() {
    var allocation = int.tryParse(_amount.text.trim()) ?? 0;
    if (allocation < 0) allocation = 0;
    final max = _sum;
    if (max > 0 && allocation > max) allocation = max;
    final names = widget.places
        .where((p) => _selected.contains(p.id))
        .map((p) => p.name)
        .join(', ');
    context.read<PlansCubit>().updateAllocation(
          planId: widget.plan.id,
          allocatedAmount: allocation,
          connectedPlaceIds: _selected.toList(),
          connectedPlaceName: names.isEmpty ? null : names,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Edit allocation', style: HavenTypography.title),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            'Money stays in your places. This lens says how much supports the plan.',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
          const SizedBox(height: HavenSpacing.lg),
          if (widget.places.isNotEmpty) ...[
            Wrap(
              spacing: HavenSpacing.sm,
              runSpacing: HavenSpacing.sm,
              children: [
                for (final place in widget.places)
                  HavenChoiceChip(
                    selected: _selected.contains(place.id),
                    onTap: () {
                      setState(() {
                        if (_selected.contains(place.id)) {
                          _selected.remove(place.id);
                        } else {
                          _selected.add(place.id);
                        }
                      });
                    },
                    size: null,
                    child: Text(
                      '${place.name} · ${HavenTypography.formatAmount(place.balance)}',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HavenSpacing.md),
            Text(
              'Selected balance: ${HavenTypography.formatAmount(_sum)}',
              style: HavenTypography.caption.copyWith(
                color: HavenColors.textSecondary,
              ),
            ),
            const SizedBox(height: HavenSpacing.md),
          ],
          HavenAmountField(
            controller: _amount,
            label: 'Allocated amount',
          ),
          const SizedBox(height: HavenSpacing.lg),
          HavenPrimaryButton(label: 'Save', onPressed: _save),
        ],
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
