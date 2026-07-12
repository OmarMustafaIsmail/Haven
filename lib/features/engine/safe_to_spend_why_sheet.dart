import 'package:flutter/material.dart';

import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_primary_button.dart';
import '../../widgets/haven_sheet.dart';
import 'safe_to_spend.dart';

/// Explains how Safe to Spend was derived — transparency over invention (PD-038).
abstract final class SafeToSpendWhySheet {
  static Future<void> show(
    BuildContext context, {
    required SafeToSpendResult result,
  }) {
    return HavenSheet.show<void>(
      context: context,
      builder: (_) => _WhyBody(result: result),
    );
  }
}

class _WhyBody extends StatelessWidget {
  const _WhyBody({required this.result});

  final SafeToSpendResult result;

  @override
  Widget build(BuildContext context) {
    final b = result.breakdown;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Why this number?', style: HavenTypography.title),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            result.state == SafeToSpendState.unknown
                ? 'Haven does not have enough to calculate yet.'
                : 'Haven prefers a trustworthy floor over a prediction.',
            style: HavenTypography.bodySmall.copyWith(
              color: HavenColors.textSecondary,
            ),
          ),
          const SizedBox(height: HavenSpacing.lg),
          _row('Available money', b.availableMoney),
          _row('Estimated commitments', -b.commitmentHold),
          _row('Plan intention hold', -b.planIntentionHold),
          _row('Safety margin', -b.safetyMargin),
          const Divider(height: HavenSpacing.xl),
          _row(
            'Safe to Spend',
            result.displayAmount ?? 0,
            emphasize: true,
            unknown: result.state == SafeToSpendState.unknown,
          ),
          if (result.missingHints.isNotEmpty) ...[
            const SizedBox(height: HavenSpacing.lg),
            Text(
              'What would help',
              style: HavenTypography.caption.copyWith(
                color: HavenColors.textTertiary,
              ),
            ),
            const SizedBox(height: HavenSpacing.sm),
            for (final hint in result.missingHints)
              Padding(
                padding: const EdgeInsets.only(bottom: HavenSpacing.xs),
                child: Text('· $hint', style: HavenTypography.bodySmall),
              ),
          ],
          const SizedBox(height: HavenSpacing.lg),
          HavenPrimaryButton(
            label: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    int amount, {
    bool emphasize = false,
    bool unknown = false,
  }) {
    final style = emphasize ? HavenTypography.title : HavenTypography.body;
    return Padding(
      padding: const EdgeInsets.only(bottom: HavenSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            unknown && emphasize
                ? '—'
                : HavenTypography.formatSignedAmount(amount),
            style: style.copyWith(
              color: emphasize
                  ? HavenColors.primary
                  : HavenColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
