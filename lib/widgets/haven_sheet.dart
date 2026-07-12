import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_motion.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';

/// Haven bottom sheet scaffold — tokenized radius and entry motion (PD-037).
abstract final class HavenSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: HavenColors.surface,
      barrierColor: HavenColors.textPrimary.withValues(alpha: 0.28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HavenRadius.sheet),
        ),
      ),
      transitionAnimationController: null,
      builder: (ctx) {
        return AnimatedPadding(
          duration: HavenMotion.sheetEnterDuration,
          curve: HavenMotion.sheetCurve,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              HavenSpacing.lg,
              HavenSpacing.md,
              HavenSpacing.lg,
              HavenSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: HavenSpacing.md),
                  decoration: BoxDecoration(
                    color: HavenColors.border,
                    borderRadius: BorderRadius.circular(HavenRadius.full),
                  ),
                ),
                Flexible(child: builder(ctx)),
              ],
            ),
          ),
        );
      },
    );
  }
}
