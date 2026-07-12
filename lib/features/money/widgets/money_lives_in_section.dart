import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../models/money_place.dart';

/// Where money lives — factual, not "Accounts."
class MoneyLivesInSection extends StatelessWidget {
  const MoneyLivesInSection({
    super.key,
    required this.places,
    this.onPlaceTap,
    this.onAddPlace,
  });

  final List<MoneyPlace> places;
  final ValueChanged<MoneyPlace>? onPlaceTap;
  final VoidCallback? onAddPlace;

  static const Key placesKey = Key('money_places');

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: placesKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Money lives in',
              style: HavenTypography.title.copyWith(fontSize: 16),
            ),
            const SizedBox(height: HavenSpacing.lg),
            for (var i = 0; i < places.length; i++) ...[
              if (i > 0) const SizedBox(height: HavenSpacing.lg),
              _PlaceRow(
                place: places[i],
                onTap: onPlaceTap == null
                    ? null
                    : () => onPlaceTap!(places[i]),
              ),
            ],
            if (onAddPlace != null) ...[
              const SizedBox(height: HavenSpacing.lg),
              TextButton(
                onPressed: onAddPlace,
                style: TextButton.styleFrom(
                  foregroundColor: HavenColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('+ Add place'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    this.onTap,
  });

  final MoneyPlace place;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            place.name,
            style: HavenTypography.body,
          ),
        ),
        Text(
          HavenTypography.formatAmount(place.balance),
          style: HavenTypography.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      child: row,
    );
  }
}
