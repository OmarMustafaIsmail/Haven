import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_card.dart';
import '../../widgets/haven_primary_button.dart';
import '../../widgets/haven_text_button.dart';
import '../commitments/models/commitment.dart';
import '../developer/developer_panel.dart';
import '../shell/app_shell.dart';

/// Control center — You, Haven Knows, Commitments, Learning, Preferences, Debug.
class YouAndHavenScreen extends StatelessWidget {
  const YouAndHavenScreen({super.key, required this.services});

  final HavenAppServices services;

  @override
  Widget build(BuildContext context) {
    final s = services;
    final engine = s.engine;
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HavenSpacing.md),
          children: [
            Text('You & Haven', style: HavenTypography.h1),
            const SizedBox(height: HavenSpacing.xs),
            Text(
              'Your relationship with Haven.',
              style: HavenTypography.body.copyWith(
                color: HavenColors.textSecondary,
              ),
            ),
            const SizedBox(height: HavenSpacing.lg),
            _Section(
              title: 'You',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('Name', s.settings.memberName),
                  _kv('Currency', s.settings.currency),
                ],
              ),
            ),
            _Section(
              title: 'Haven Knows',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('Pulse', engine.pulse.value.name),
                  _kv('Safe to Spend', '${engine.safeToSpend.value}'),
                  _kv(
                    'Active Moment',
                    s.momentRepository.activeMoment?.title ?? '—',
                  ),
                  _kv('Insights', '${engine.insights.value.length}'),
                  _kv('Clock', dateFmt.format(s.clock.now())),
                ],
              ),
            ),
            _Section(
              title: 'Commitments',
              child: s.commitmentRepository.items.isEmpty
                  ? Text(
                      'No commitments yet.',
                      style: HavenTypography.body.copyWith(
                        color: HavenColors.textSecondary,
                      ),
                    )
                  : Column(
                      children: [
                        for (final c in s.commitmentRepository.items)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: HavenSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c.name,
                                    style: HavenTypography.body,
                                  ),
                                ),
                                Text(
                                  '${c.direction == CommitmentDirection.inflow ? '+' : '-'}${c.amount}',
                                  style: HavenTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            _Section(
              title: 'Learning',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dismissed observations Haven remembers:',
                    style: HavenTypography.bodySmall,
                  ),
                  const SizedBox(height: HavenSpacing.sm),
                  Text(
                    engine.suppressedIds.isEmpty
                        ? 'Nothing suppressed yet.'
                        : engine.suppressedIds.join('\n'),
                    style: HavenTypography.caption,
                  ),
                  const SizedBox(height: HavenSpacing.md),
                  HavenTextButton(
                    label: 'Clear learning memory',
                    onPressed: () {
                      engine.clearMemory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Learning memory cleared')),
                      );
                    },
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Preferences',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv(
                    'Compressed time',
                    s.devTime.config.enabled ? 'On' : 'Off',
                  ),
                  _kv('Signed in', s.settings.isSignedIn ? 'Yes' : 'No'),
                  _kv('Onboarded', s.settings.hasOnboarded ? 'Yes' : 'No'),
                ],
              ),
            ),
            _Section(
              title: 'Debug',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HavenPrimaryButton(
                    label: 'Open Developer Panel',
                    onPressed: () => DeveloperPanel.open(context),
                  ),
                  const SizedBox(height: HavenSpacing.sm),
                  HavenPrimaryButton(
                    label: 'Reset local data',
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Reset local data?'),
                          content: const Text(
                            'This clears places, plans, commitments, activity, and session. You will return to onboarding after restart.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await s.resetLocalData();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Local data cleared. Restart the app for a fresh start.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.md),
      child: HavenCard(
        margin: EdgeInsets.zero,
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
