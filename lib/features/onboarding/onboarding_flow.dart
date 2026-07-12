import 'package:flutter/material.dart';

import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_primary_button.dart';
import '../../widgets/haven_text_button.dart';
import '../commitments/models/commitment.dart';
import '../commitments/repository/commitment_repository.dart';
import '../money/repository/money_place_repository.dart';
import '../plans/repository/plan_repository.dart';
import '../settings/member_settings.dart';

/// Lightweight onboarding — gather the minimum Haven needs.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.settings,
    required this.moneyPlaces,
    required this.commitments,
    required this.plans,
    required this.now,
    required this.onFinished,
  });

  final MemberSettings settings;
  final MoneyPlaceRepository moneyPlaces;
  final CommitmentRepository commitments;
  final PlanRepository plans;
  final DateTime now;
  final VoidCallback onFinished;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  final _nameController = TextEditingController();
  final _placeNameController = TextEditingController(text: 'Main account');
  final _placeBalanceController = TextEditingController();
  final _salaryController = TextEditingController();
  final _goalNameController = TextEditingController();
  final _goalAmountController = TextEditingController();
  String _currency = 'EGP';
  String _salaryCadence = 'monthly';

  @override
  void initState() {
    super.initState();
    if (widget.settings.memberName != 'there') {
      _nameController.text = widget.settings.memberName;
    }
    _currency = widget.settings.currency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeNameController.dispose();
    _placeBalanceController.dispose();
    _salaryController.dispose();
    _goalNameController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final name = _nameController.text.trim();
    await widget.settings.setMemberName(name.isEmpty ? 'there' : name);
    await widget.settings.setCurrency(_currency);

    final placeName = _placeNameController.text.trim().isEmpty
        ? 'Main account'
        : _placeNameController.text.trim();
    final balance = int.tryParse(_placeBalanceController.text.trim()) ?? 0;
    widget.moneyPlaces.add(name: placeName, balance: balance);

    final salary = int.tryParse(_salaryController.text.trim());
    if (salary != null && salary > 0) {
      final cadence = switch (_salaryCadence) {
        'weekly' => CommitmentCadence.weekly,
        'annual' => CommitmentCadence.annual,
        _ => CommitmentCadence.monthly,
      };
      widget.commitments.add(
        Commitment(
          id: 'cmt_salary_onboarding',
          name: 'Salary',
          direction: CommitmentDirection.inflow,
          amount: salary,
          cadence: cadence,
          nextDate: widget.now,
          confidence: 0.85,
        ),
      );
    }

    final goalName = _goalNameController.text.trim();
    final goalAmount = int.tryParse(_goalAmountController.text.trim());
    if (goalName.isNotEmpty && goalAmount != null && goalAmount > 0) {
      final place = widget.moneyPlaces.places.firstOrNull;
      widget.plans.add(
        name: goalName,
        targetAmount: goalAmount,
        connectedPlaceId: place?.id,
        connectedPlaceName: place?.name,
      );
    }

    await widget.settings.setOnboarded(true);
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HavenSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Step ${_step + 1} of 4',
                style: HavenTypography.caption,
              ),
              const SizedBox(height: HavenSpacing.md),
              Expanded(child: _buildStep()),
              HavenPrimaryButton(
                label: _step == 3 ? 'Enter Haven' : 'Continue',
                onPressed: () async {
                  if (_step < 3) {
                    setState(() => _step++);
                    return;
                  }
                  await _finish();
                },
              ),
              if (_step > 0) ...[
                const SizedBox(height: HavenSpacing.sm),
                HavenTextButton(
                  label: 'Back',
                  onPressed: () => setState(() => _step--),
                ),
              ],
              if (_step == 3) ...[
                const SizedBox(height: HavenSpacing.sm),
                HavenTextButton(
                  label: 'Skip goal',
                  onPressed: _finish,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _StepBody(
          title: 'What should Haven call you?',
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      1 => _StepBody(
          title: 'Your currency',
          child: Column(
            children: [
              for (final code in const ['EGP', 'USD', 'EUR', 'GBP', 'SAR', 'AED'])
                RadioListTile<String>(
                  value: code,
                  groupValue: _currency,
                  title: Text(code, style: HavenTypography.body),
                  activeColor: HavenColors.primary,
                  onChanged: (v) {
                    if (v != null) setState(() => _currency = v);
                  },
                ),
            ],
          ),
        ),
      2 => _StepBody(
          title: 'Where does your money live?',
          child: Column(
            children: [
              TextField(
                controller: _placeNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Money Place name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: HavenSpacing.md),
              TextField(
                controller: _placeBalanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Current balance ($_currency)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: HavenSpacing.lg),
              Text(
                'Optional — salary',
                style: HavenTypography.title,
              ),
              const SizedBox(height: HavenSpacing.sm),
              TextField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Salary amount ($_currency)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: HavenSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _salaryCadence,
                decoration: const InputDecoration(
                  labelText: 'Cadence',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'annual', child: Text('Annual')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _salaryCadence = v);
                },
              ),
            ],
          ),
        ),
      _ => _StepBody(
          title: 'A goal to work toward?',
          child: Column(
            children: [
              Text(
                'Optional. Plans express intention — money stays in Money Places.',
                style: HavenTypography.bodySmall.copyWith(
                  color: HavenColors.textSecondary,
                ),
              ),
              const SizedBox(height: HavenSpacing.md),
              TextField(
                controller: _goalNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Goal name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: HavenSpacing.md),
              TextField(
                controller: _goalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target amount ($_currency)',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
    };
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(title, style: HavenTypography.h1),
        const SizedBox(height: HavenSpacing.lg),
        child,
      ],
    );
  }
}
