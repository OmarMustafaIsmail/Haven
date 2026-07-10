import 'package:flutter/material.dart';

/// Circular Financial Pulse — PD-026 locked form.
class PulseCircle extends StatelessWidget {
  const PulseCircle({
    super.key,
    required this.color,
    required this.diameter,
    required this.glowOpacity,
    this.scale = 1,
  });

  final Color color;
  final double diameter;
  final double glowOpacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: glowOpacity.clamp(0.0, 1.0)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: glowOpacity * 0.35),
                blurRadius: diameter * 0.35,
                spreadRadius: diameter * 0.02,
              ),
              BoxShadow(
                color: color.withValues(alpha: glowOpacity * 0.2),
                blurRadius: diameter * 0.55,
                spreadRadius: diameter * 0.08,
              ),
              BoxShadow(
                color: color.withValues(alpha: glowOpacity * 0.1),
                blurRadius: diameter * 0.75,
                spreadRadius: diameter * 0.12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
