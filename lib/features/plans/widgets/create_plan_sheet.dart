import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_choice_chip.dart';
import '../../../widgets/haven_date_field.dart';
import '../../../widgets/haven_primary_button.dart';
import '../../../widgets/haven_select.dart';
import '../../../widgets/haven_sheet.dart';
import '../../../widgets/haven_text_button.dart';
import '../../../widgets/haven_text_field.dart';
import '../../money/cubit/money_cubit.dart';
import '../../money/cubit/money_state.dart';
import '../../money/models/money_place.dart';
import '../cubit/plans_cubit.dart';
import '../models/mock_plans_data.dart';

/// Lightweight create-plan sheet (PD-036, PD-037).
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
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime? _targetDate;
  MoneyPlace? _connectedPlace;
  IconData _icon = MockPlansData.iconChoices.first;
  Color _color = MockPlansData.accentChoices.first;
  bool _showOptional = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text.trim());
    if (name.isEmpty || target == null || target <= 0) return;

    context.read<PlansCubit>().createPlan(
          name: name,
          targetAmount: target,
          targetDate: _targetDate,
          connectedPlaceId: _connectedPlace?.id,
          connectedPlaceName: _connectedPlace?.name,
          icon: _icon,
          color: _color,
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
          Text('Create a plan', style: HavenTypography.title),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            'Keep it simple. You can refine this later.',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
          const SizedBox(height: HavenSpacing.lg),
          HavenTextField(
            controller: _nameController,
            label: 'Plan name',
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: HavenSpacing.md),
          HavenAmountField(
            controller: _targetController,
            label: 'Target amount',
          ),
          const SizedBox(height: HavenSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: HavenTextButton(
              label: _showOptional
                  ? 'Hide optional details'
                  : 'Add optional details',
              onPressed: () => setState(() => _showOptional = !_showOptional),
            ),
          ),
          if (_showOptional) ...[
            const SizedBox(height: HavenSpacing.sm),
            HavenDateField(
              label: 'Target date',
              value: _targetDate,
              onChanged: (d) => setState(() => _targetDate = d),
            ),
            if (places.isNotEmpty) ...[
              const SizedBox(height: HavenSpacing.md),
              HavenSelect<MoneyPlace>(
                label: 'Connected Money Place',
                value: _connectedPlace,
                options: [
                  for (final place in places)
                    HavenSelectOption(value: place, label: place.name),
                ],
                onChanged: (v) => setState(() => _connectedPlace = v),
              ),
            ],
            const SizedBox(height: HavenSpacing.md),
            Text(
              'Icon',
              style: HavenTypography.caption.copyWith(
                color: HavenColors.textTertiary,
              ),
            ),
            const SizedBox(height: HavenSpacing.sm),
            HavenChoiceChipRow(
              children: [
                for (final icon in MockPlansData.iconChoices)
                  HavenChoiceChip(
                    selected: _icon == icon,
                    onTap: () => setState(() => _icon = icon),
                    child: Icon(icon, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: HavenSpacing.md),
            Text(
              'Color',
              style: HavenTypography.caption.copyWith(
                color: HavenColors.textTertiary,
              ),
            ),
            const SizedBox(height: HavenSpacing.sm),
            HavenChoiceChipRow(
              children: [
                for (final color in MockPlansData.accentChoices)
                  HavenChoiceChip(
                    selected: _color == color,
                    onTap: () => setState(() => _color = color),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: HavenSpacing.lg),
          HavenPrimaryButton(label: 'Create plan', onPressed: _save),
        ],
      ),
    );
  }
}
