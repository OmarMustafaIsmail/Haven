import 'package:flutter/material.dart';

import '../../models/pulse_state.dart';
import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../financial_pulse.dart';

/// Isolated demo for polishing FinancialPulse — no Home, no business logic.
class FinancialPulseDemoScreen extends StatefulWidget {
  const FinancialPulseDemoScreen({super.key});

  @override
  State<FinancialPulseDemoScreen> createState() =>
      _FinancialPulseDemoScreenState();
}

class _FinancialPulseDemoScreenState extends State<FinancialPulseDemoScreen> {
  final _events = <String>[];

  void _log(String event) {
    setState(() {
      _events.insert(0, event);
      if (_events.length > 6) _events.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: FinancialPulse(
          greeting: 'Good morning, Omar.',
          pulseState: PulseState.attention,
          showHeroPresentation: true,
          onPresentationSettled: () => _log('onPresentationSettled'),
          onCheckInStarted: () => _log('onCheckInStarted'),
          onThresholdReached: () => _log('onThresholdReached'),
          onHeartbeatFinished: () => _log('onHeartbeatFinished'),
          onReturnedHome: () => _log('onReturnedHome'),
          child: ListView(
            padding: const EdgeInsets.only(bottom: HavenSpacing.xxl),
            children: [_DemoContent(eventLog: _events)],
          ),
        ),
      ),
    );
  }
}

class _DemoContent extends StatelessWidget {
  const _DemoContent({required this.eventLog});

  final List<String> eventLog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calm today.', style: HavenTypography.emotionalHeadline),
          const SizedBox(height: HavenSpacing.sm),
          Text(
            'Nothing needs your attention.',
            style: HavenTypography.bodySmall.copyWith(
              color: HavenColors.textSecondary,
            ),
          ),
          const SizedBox(height: HavenSpacing.lg),
          Text(
            '42,350 EGP safe to spend',
            style: HavenTypography.moneyEvidence,
          ),
          const SizedBox(height: HavenSpacing.lg),
          Text('I have a suggestion.', style: HavenTypography.caption),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            'Move 12,000 EGP to your Apartment fund.',
            style: HavenTypography.body,
          ),
          const SizedBox(height: HavenSpacing.xl),
          Text('Recent activity', style: HavenTypography.caption),
          const SizedBox(height: HavenSpacing.sm),
          Text('Lunch · −185 EGP', style: HavenTypography.bodySmall),
          const SizedBox(height: HavenSpacing.xl),
          if (eventLog.isNotEmpty) ...[
            Text('Events', style: HavenTypography.caption),
            const SizedBox(height: HavenSpacing.xs),
            ...eventLog.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(e, style: HavenTypography.caption),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
