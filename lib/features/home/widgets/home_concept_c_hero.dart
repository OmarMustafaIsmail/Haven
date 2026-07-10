import 'package:flutter/material.dart';

import '../../../models/pulse_state.dart';
import '../../../pulse/pulse_colors.dart';
import '../../../theme/haven_colors.dart';

/// Concept C hero — illustration tint follows [PulseState].
class HomeConceptCHeroBackground extends StatelessWidget {
  const HomeConceptCHeroBackground({super.key, required this.pulseState});

  final PulseState pulseState;

  @override
  Widget build(BuildContext context) {
    final accent = pulseColorFor(pulseState);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.alphaBlend(
              accent.withValues(alpha: 0.12),
              const Color(0xFFEAF4F3),
            ),
            const Color(0xFFF5FAFA),
            HavenColors.background,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accent.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.5),
                  HavenColors.background,
                ],
                stops: const [0.0, 0.68, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
