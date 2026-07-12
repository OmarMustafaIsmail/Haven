import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/pulse_state.dart';
import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_card.dart';
import '../../widgets/haven_choice_chip.dart';
import '../../widgets/haven_primary_button.dart';
import '../../widgets/haven_text_button.dart';
import '../commitments/models/commitment.dart';
import '../engine/haven_engine.dart';
import '../engine/safe_to_spend.dart';
import '../moments/models/moment.dart';
import '../shell/app_shell.dart';
import 'dev_time_config.dart';
import 'developer_scope.dart';
import 'engine_inspector.dart';

/// Hidden tooling for rapid product validation — Tools + Engine Inspector.
class DeveloperPanel extends StatefulWidget {
  const DeveloperPanel({super.key});

  static Future<void> open(BuildContext context) {
    final scope = DeveloperScope.of(context);
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DeveloperScope(
          services: scope.services,
          devTime: scope.devTime,
          child: const DeveloperPanel(),
        ),
      ),
    );
  }

  @override
  State<DeveloperPanel> createState() => _DeveloperPanelState();
}

class _DeveloperPanelState extends State<DeveloperPanel>
    with SingleTickerProviderStateMixin {
  String? _status;
  late final TabController _tabs;

  HavenAppServices get _services => DeveloperScope.of(context).services;
  DevTimeController get _devTime => DeveloperScope.of(context).devTime;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _flash(String message) {
    setState(() => _status = message);
  }

  @override
  Widget build(BuildContext context) {
    final s = _services;
    final engine = s.engine;

    return Scaffold(
      backgroundColor: HavenColors.background,
      appBar: AppBar(
        title: const Text('Developer Panel'),
        backgroundColor: HavenColors.surface,
        foregroundColor: HavenColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabs,
          labelColor: HavenColors.primary,
          unselectedLabelColor: HavenColors.textTertiary,
          indicatorColor: HavenColors.primary,
          tabs: const [
            Tab(text: 'Tools'),
            Tab(text: 'Inspector'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildTools(s, engine),
          ListenableBuilder(
            listenable: Listenable.merge([
              engine.safeToSpend,
              engine.pulse,
              engine.candidates,
              s.moneyPlaceRepository.version,
              s.commitmentRepository.version,
              s.planRepository.version,
              s.clock.version,
            ]),
            builder: (_, __) => EngineInspector(services: s),
          ),
        ],
      ),
    );
  }

  Widget _buildTools(HavenAppServices s, HavenEngine engine) {
    final now = s.clock.now();
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');

    return ListView(
      padding: const EdgeInsets.all(HavenSpacing.md),
      children: [
        if (_status != null) ...[
          HavenCard(
            color: HavenColors.primaryLight,
            child: Text(_status!, style: HavenTypography.body),
          ),
          const SizedBox(height: HavenSpacing.md),
        ],
        _Section(
          title: 'Engine state',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('Clock', dateFmt.format(now)),
              _kv('Offset', '${s.clock.offset}'),
              _kv('Safe to Spend', _stsLabel(engine.safeToSpend.value)),
              _kv('Pulse', engine.pulse.value.name),
              _kv(
                'Active Moment',
                s.momentRepository.activeMoment?.title ?? '—',
              ),
              _kv('Insights', '${engine.insights.value.length}'),
              _kv(
                'Suppressed',
                engine.suppressedIds.join(', ').ifEmpty('—'),
              ),
              _kv(
                'Compressed time',
                _devTime.config.enabled ? 'ON' : 'OFF',
              ),
              if (_devTime.config.enabled) ...[
                _kv('Salary cadence', '${_devTime.config.salaryInterval}'),
                _kv(
                  'Commitment cadence',
                  '${_devTime.config.commitmentInterval}',
                ),
                _kv(
                  'Plan deadline cadence',
                  '${_devTime.config.planDeadlineInterval}',
                ),
              ],
            ],
          ),
        ),
        _Section(
          title: 'Database',
          child: Column(
            children: [
              HavenPrimaryButton(
                label: 'Reset local database',
                onPressed: () async {
                  await s.resetLocalData();
                  _flash('Local database cleared.');
                },
              ),
              const SizedBox(height: HavenSpacing.sm),
              HavenPrimaryButton(
                label: 'Generate demo data',
                onPressed: () async {
                  await HavenAppServices.seedDemoData(
                    money: s.moneyPlaceRepository,
                    plans: s.planRepository,
                    commitments: s.commitmentRepository,
                    activity: s.activityRepository,
                    now: s.clock.now(),
                  );
                  engine.recompute();
                  _flash('Demo data generated.');
                },
              ),
              const SizedBox(height: HavenSpacing.sm),
              HavenPrimaryButton(
                label: 'Trigger engine recalculation',
                onPressed: () {
                  engine.recompute();
                  _flash('Engine recomputed.');
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Simulated time',
          child: Wrap(
            spacing: HavenSpacing.sm,
            runSpacing: HavenSpacing.sm,
            children: [
              _ChipAction(
                label: '+1 day',
                onTap: () async {
                  await _devTime.advance(const Duration(days: 1));
                  _flash('Advanced 1 day.');
                },
              ),
              _ChipAction(
                label: '+1 week',
                onTap: () async {
                  await _devTime.advance(const Duration(days: 7));
                  _flash('Advanced 1 week.');
                },
              ),
              _ChipAction(
                label: '+1 month',
                onTap: () async {
                  await _devTime.advance(const Duration(days: 30));
                  _flash('Advanced 1 month.');
                },
              ),
              _ChipAction(
                label: _devTime.config.enabled
                    ? 'Disable compressed time'
                    : 'Enable compressed time',
                onTap: () async {
                  final next = !_devTime.config.enabled;
                  await _devTime.setEnabled(next);
                  engine.applyDevTime(_devTime.config);
                  _flash(
                    next
                        ? 'Compressed time ON — salary ~2m, commitments ~5m, plans ~10m.'
                        : 'Compressed time OFF.',
                  );
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Money',
          child: HavenPrimaryButton(
            label: 'Add 10,000 to first Money Place',
            onPressed: () {
              final places = s.moneyPlaceRepository.places;
              if (places.isEmpty) {
                s.moneyPlaceRepository.add(
                  name: 'Main',
                  balance: 10000,
                );
                _flash('Created Money Place with 10,000.');
                return;
              }
              final place = places.first;
              s.moneyPlaceRepository.updateBalance(
                id: place.id,
                balance: place.balance + 10000,
              );
              _flash('Added 10,000 to ${place.name}.');
            },
          ),
        ),
        _Section(
          title: 'Commitments',
          child: Column(
            children: [
              HavenPrimaryButton(
                label: 'Simulate salary not arriving',
                onPressed: () {
                  final salary = s.commitmentRepository.items
                      .where(
                        (c) =>
                            c.direction == CommitmentDirection.inflow &&
                            c.name.toLowerCase().contains('salary'),
                      )
                      .firstOrNull;
                  if (salary == null) {
                    _flash('No salary Commitment found.');
                    return;
                  }
                  s.commitmentRepository.update(
                    salary.copyWith(
                      nextDate: s.clock.now().add(const Duration(days: 30)),
                    ),
                  );
                  engine.rememberDismissal('obs_${salary.id}');
                  _flash('Salary pushed out; observation suppressed.');
                },
              ),
              const SizedBox(height: HavenSpacing.sm),
              HavenPrimaryButton(
                label: 'Set salary due now',
                onPressed: () {
                  final salary = s.commitmentRepository.items
                      .where(
                        (c) =>
                            c.direction == CommitmentDirection.inflow &&
                            c.name.toLowerCase().contains('salary'),
                      )
                      .firstOrNull;
                  if (salary == null) {
                    final id =
                        'cmt_salary_${s.clock.now().microsecondsSinceEpoch}';
                    s.commitmentRepository.add(
                      Commitment(
                        id: id,
                        name: 'Salary',
                        direction: CommitmentDirection.inflow,
                        amount: 12000,
                        cadence: CommitmentCadence.monthly,
                        nextDate: s.clock.now(),
                        confidence: 0.9,
                      ),
                    );
                    engine.clearMemory();
                    _flash('Salary Commitment created for today.');
                    return;
                  }
                  s.commitmentRepository.update(
                    salary.copyWith(nextDate: s.clock.now()),
                  );
                  engine.clearMemory();
                  _flash('Salary set due now.');
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Plans',
          child: HavenPrimaryButton(
            label: 'Complete first active Plan',
            onPressed: () {
              final plan = s.planRepository.active.firstOrNull;
              if (plan == null) {
                _flash('No active Plan.');
                return;
              }
              s.planRepository.complete(plan.id);
              _flash('Completed ${plan.name}.');
            },
          ),
        ),
        _Section(
          title: 'Pulse preview',
          child: Wrap(
            spacing: HavenSpacing.sm,
            runSpacing: HavenSpacing.sm,
            children: [
              for (final state in PulseState.values)
                _ChipAction(
                  label: state.name,
                  onTap: () {
                    engine.setPulseOverride(state);
                    _flash('Pulse override → ${state.name}');
                  },
                ),
              _ChipAction(
                label: 'Clear override',
                onTap: () {
                  engine.setPulseOverride(null);
                  _flash('Pulse override cleared.');
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Moments',
          child: Wrap(
            spacing: HavenSpacing.sm,
            runSpacing: HavenSpacing.sm,
            children: [
              for (final type in MomentType.values)
                _ChipAction(
                  label: type.name,
                  onTap: () {
                    final now = s.clock.now();
                    s.momentRepository.inject(
                      Moment(
                        id: 'dev_${type.name}_${now.microsecondsSinceEpoch}',
                        type: type,
                        title: 'Test ${type.name}',
                        description: 'Generated from Developer Panel.',
                        priority: 999,
                        createdAt: now,
                        expiresAt: now.add(
                          engine.devTime.momentExpiryFor(now),
                        ),
                        actions: const [
                          MomentAction(
                            id: 'ok',
                            label: 'OK',
                            outcome: MomentActionOutcome.complete,
                          ),
                          MomentAction(
                            id: 'dismiss',
                            label: 'Dismiss',
                            outcome: MomentActionOutcome.dismiss,
                          ),
                        ],
                      ),
                    );
                    _flash('Injected ${type.name} Moment.');
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: HavenSpacing.xl),
        HavenTextButton(
          label: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

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

class _ChipAction extends StatelessWidget {
  const _ChipAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HavenChoiceChip(
      selected: false,
      onTap: onTap,
      size: null,
      child: Text(
        label,
        style: HavenTypography.caption.copyWith(color: HavenColors.primary),
      ),
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
