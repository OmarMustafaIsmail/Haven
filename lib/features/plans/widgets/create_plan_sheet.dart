import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_choice_chip.dart';
import '../../../widgets/haven_date_field.dart';
import '../../../widgets/haven_primary_button.dart';
import '../../../widgets/haven_sheet.dart';
import '../../../widgets/haven_text_button.dart';
import '../../../widgets/haven_text_field.dart';
import '../../money/cubit/money_cubit.dart';
import '../../money/cubit/money_state.dart';
import '../../money/models/money_place.dart';
import '../cubit/plans_cubit.dart';
import '../models/mock_plans_data.dart';
import '../models/plan.dart';

/// Multi-step create-plan sheet (PD-039).
class CreatePlanSheet extends StatefulWidget {
  const CreatePlanSheet({super.key});

  static Future<void> show(BuildContext context) {
    final plansCubit = context.read<PlansCubit>();
    final moneyCubit = context.read<MoneyCubit>();

    return HavenSheet.show<void>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: plansCubit),
          BlocProvider.value(value: moneyCubit),
        ],
        child: const CreatePlanSheet(),
      ),
    );
  }

  @override
  State<CreatePlanSheet> createState() => _CreatePlanSheetState();
}

class _CreatePlanSheetState extends State<CreatePlanSheet> {
  int _step = 0;
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _allocationController = TextEditingController();
  DateTime? _targetDate;
  PlanPriority _priority = PlanPriority.important;
  final Set<String> _selectedPlaceIds = {};
  IconData _icon = MockPlansData.iconChoices.first;

  static const _stepTitles = [
    'What are you building?',
    'How much?',
    'When?',
    'How important?',
    'Where from?',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _allocationController.dispose();
    super.dispose();
  }

  List<MoneyPlace> get _places {
    final state = context.read<MoneyCubit>().state;
    return state is MoneyLoadedState ? state.places : const [];
  }

  int get _selectedBalanceSum {
    final ids = _selectedPlaceIds;
    return _places
        .where((p) => ids.contains(p.id))
        .fold<int>(0, (s, p) => s + p.balance);
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        final t = int.tryParse(_targetController.text.trim());
        return t != null && t > 0;
      case 2:
        return _targetDate != null;
      case 3:
        return true;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _next() {
    if (!_canContinue) return;
    if (_step < 4) {
      setState(() => _step++);
      return;
    }
    _save();
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _step--);
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text.trim());
    final date = _targetDate;
    if (name.isEmpty || target == null || target <= 0 || date == null) return;

    final places = _places;
    final selected = places.where((p) => _selectedPlaceIds.contains(p.id));
    final maxAlloc = selected.fold<int>(0, (s, p) => s + p.balance);
    var allocation = int.tryParse(_allocationController.text.trim()) ?? 0;
    if (allocation < 0) allocation = 0;
    if (maxAlloc > 0 && allocation > maxAlloc) allocation = maxAlloc;

    context.read<PlansCubit>().createPlan(
          name: name,
          targetAmount: target,
          targetDate: date,
          priority: _priority,
          connectedPlaceIds: _selectedPlaceIds.toList(),
          connectedPlaceName: selected.map((p) => p.name).join(', ').isEmpty
              ? null
              : selected.map((p) => p.name).join(', '),
          allocatedAmount: allocation,
          icon: _icon,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final moneyState = context.watch<MoneyCubit>().state;
    final places =
        moneyState is MoneyLoadedState ? moneyState.places : <MoneyPlace>[];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Step ${_step + 1} of 5',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
          const SizedBox(height: HavenSpacing.xs),
          Text(_stepTitles[_step], style: HavenTypography.title),
          const SizedBox(height: HavenSpacing.lg),
          if (_step == 0) _buildIntentStep(),
          if (_step == 1) _buildAmountStep(),
          if (_step == 2) _buildWhenStep(),
          if (_step == 3) _buildPriorityStep(),
          if (_step == 4) _buildPlacesStep(places),
          const SizedBox(height: HavenSpacing.lg),
          Row(
            children: [
              HavenTextButton(
                label: _step == 0 ? 'Cancel' : 'Back',
                onPressed: _back,
              ),
              const Spacer(),
              HavenPrimaryButton(
                label: _step == 4 ? 'Create plan' : 'Continue',
                expanded: false,
                onPressed: _canContinue ? _next : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HavenChoiceChipRow(
          children: [
            for (final preset in MockPlansData.intentPresets)
              HavenChoiceChip(
                selected: _nameController.text == preset.$1 ||
                    (preset.$1 == 'Custom' &&
                        !MockPlansData.intentPresets
                            .take(4)
                            .any((p) => p.$1 == _nameController.text)),
                onTap: () {
                  setState(() {
                    if (preset.$1 == 'Custom') {
                      if (MockPlansData.intentPresets
                          .take(4)
                          .any((p) => p.$1 == _nameController.text)) {
                        _nameController.clear();
                      }
                    } else {
                      _nameController.text = preset.$1;
                    }
                    _icon = preset.$2;
                  });
                },
                size: null,
                child: Text(preset.$1),
              ),
          ],
        ),
        const SizedBox(height: HavenSpacing.md),
        HavenTextField(
          controller: _nameController,
          label: 'Plan name',
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildAmountStep() {
    return HavenAmountField(
      controller: _targetController,
      label: 'Target amount',
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildWhenStep() {
    return HavenDateField(
      label: 'Target date',
      value: _targetDate,
      onChanged: (d) => setState(() => _targetDate = d),
    );
  }

  Widget _buildPriorityStep() {
    return HavenChoiceChipRow(
      children: [
        for (final p in PlanPriority.values)
          HavenChoiceChip(
            selected: _priority == p,
            onTap: () => setState(() => _priority = p),
            size: null,
            child: Text(p.memberLabel),
          ),
      ],
    );
  }

  Widget _buildPlacesStep(List<MoneyPlace> places) {
    if (places.isEmpty) {
      return Text(
        'No Money Places yet. You can still create the plan and connect places later.',
        style: HavenTypography.bodySmall.copyWith(
          color: HavenColors.textSecondary,
        ),
      );
    }

    final sum = _selectedBalanceSum;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select places that support this plan',
          style: HavenTypography.caption.copyWith(
            color: HavenColors.textTertiary,
          ),
        ),
        const SizedBox(height: HavenSpacing.sm),
        Wrap(
          spacing: HavenSpacing.sm,
          runSpacing: HavenSpacing.sm,
          children: [
            for (final place in places)
              HavenChoiceChip(
                selected: _selectedPlaceIds.contains(place.id),
                onTap: () {
                  setState(() {
                    if (_selectedPlaceIds.contains(place.id)) {
                      _selectedPlaceIds.remove(place.id);
                    } else {
                      _selectedPlaceIds.add(place.id);
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
        if (_selectedPlaceIds.isNotEmpty) ...[
          const SizedBox(height: HavenSpacing.md),
          Text(
            'Available in selected places: ${HavenTypography.formatAmount(sum)}',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textSecondary,
            ),
          ),
          const SizedBox(height: HavenSpacing.sm),
          HavenAmountField(
            controller: _allocationController,
            label: 'Initial allocation (lens)',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            'Money stays in your places. This is how much currently supports the plan.',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}
