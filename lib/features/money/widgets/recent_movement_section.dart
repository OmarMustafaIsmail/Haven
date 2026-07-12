import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../models/money_movement.dart';

/// Last few transactions — minimal, secondary.
class RecentMovementSection extends StatelessWidget {
  const RecentMovementSection({
    super.key,
    required this.movements,
  });

  final List<MoneyMovement> movements;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent movement',
            style: HavenTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: HavenSpacing.lg),
          for (var i = 0; i < movements.length; i++) ...[
            if (i > 0) const SizedBox(height: HavenSpacing.sm),
            _MovementRow(movement: movements[i]),
          ],
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.movement});

  final MoneyMovement movement;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movement.label,
                style: HavenTypography.bodySmall.copyWith(
                  color: HavenColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (movement.timestamp != null) ...[
                const SizedBox(height: 2),
                Text(
                  movement.timestamp!,
                  style: HavenTypography.caption.copyWith(
                    color: HavenColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          HavenTypography.formatSignedAmount(movement.amount),
          style: HavenTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: HavenColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
