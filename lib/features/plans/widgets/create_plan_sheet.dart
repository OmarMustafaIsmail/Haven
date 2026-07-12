import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_primary_button.dart';
import '../../money/cubit/money_cubit.dart';
import '../../money/cubit/money_state.dart';
import '../../money/models/money_place.dart';
import '../cubit/plans_cubit.dart';
import '../models/mock_plans_data.dart';

/// Lightweight create-plan sheet (PD-036).
class CreatePlanSheet extends StatefulWidget {
  const CreatePlanSheet({super.key});

  static Future<void> show(BuildContext context) {
    final plansCubit = context.read<PlansCubit>();
    final moneyCubit = context.read<MoneyCubit>();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: HavenColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now.add(const Duration(days: 180)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
    );
    if (picked != null) setState(() => _targetDate = picked);
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
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final moneyState = context.watch<MoneyCubit>().state;
    final places =
        moneyState is MoneyLoadedState ? moneyState.places : <MoneyPlace>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        HavenSpacing.lg,
        HavenSpacing.lg,
        HavenSpacing.lg,
        HavenSpacing.lg + bottomInset,
      ),
      child: SingleChildScrollView(
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
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Plan name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: HavenSpacing.md),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target amount (EGP)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: HavenSpacing.md),
            TextButton(
              onPressed: () => setState(() => _showOptional = !_showOptional),
              style: TextButton.styleFrom(
                foregroundColor: HavenColors.primary,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                _showOptional ? 'Hide optional details' : 'Add optional details',
              ),
            ),
            if (_showOptional) ...[
              const SizedBox(height: HavenSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _targetDate == null
                      ? 'Target date (optional)'
                      : DateFormat.yMMMd().format(_targetDate!),
                  style: HavenTypography.body,
                ),
                trailing: Icon(
                  Icons.calendar_today_outlined,
                  color: HavenColors.textTertiary,
                  size: 20,
                ),
                onTap: _pickDate,
              ),
              if (places.isNotEmpty) ...[
                const SizedBox(height: HavenSpacing.sm),
                DropdownButtonFormField<MoneyPlace?>(
                  initialValue: _connectedPlace,
                  decoration: const InputDecoration(
                    labelText: 'Connected Money Place',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<MoneyPlace?>(
                      value: null,
                      child: Text('None'),
                    ),
                    for (final place in places)
                      DropdownMenuItem(
                        value: place,
                        child: Text(place.name),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _connectedPlace = value),
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
              Wrap(
                spacing: HavenSpacing.sm,
                children: [
                  for (final icon in MockPlansData.iconChoices)
                    _ChoiceChip(
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
              Wrap(
                spacing: HavenSpacing.sm,
                children: [
                  for (final color in MockPlansData.accentChoices)
                    _ChoiceChip(
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
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HavenRadius.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? HavenColors.primaryLight
                : HavenColors.borderSubtle,
            borderRadius: BorderRadius.circular(HavenRadius.sm),
            border: Border.all(
              color: selected ? HavenColors.primary : HavenColors.borderSubtle,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(HavenSpacing.sm),
            child: child,
          ),
        ),
      ),
    );
  }
}
