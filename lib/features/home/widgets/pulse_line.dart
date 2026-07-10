import 'package:flutter/material.dart';

import '../../../theme/haven_motion.dart';

/// Hospital-monitor-style ECG sweep for Check-In reading (PD-030).
class PulseLine extends StatefulWidget {
  const PulseLine({
    super.key,
    required this.color,
    this.onComplete,
    this.active = true,
  });

  final Color color;
  final VoidCallback? onComplete;
  final bool active;

  @override
  State<PulseLine> createState() => _PulseLineState();
}

class _PulseLineState extends State<PulseLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completedFired = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: HavenMotion.pulseLineDuration,
    );
    _controller.addStatusListener(_onStatus);
    if (widget.active) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant PulseLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating && _controller.value < 1) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _completedFired) return;
    _completedFired = true;
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HavenMotion.pulseLineHeight,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PulseLinePainter(
              color: widget.color,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _PulseLinePainter extends CustomPainter {
  _PulseLinePainter({
    required this.color,
    required this.progress,
  });

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = size.height * 0.58;
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      gridPaint,
    );

    final path = _buildWaveform(size, baselineY);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final totalLength = metrics.first.length;
    final sweepLength = totalLength * progress.clamp(0.0, 1.0);

    final wavePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final visible = metrics.first.extractPath(0, sweepLength);

    canvas.drawPath(visible, glowPaint);
    canvas.drawPath(visible, wavePaint);

    if (progress > 0.02) {
      final tip = metrics.first.getTangentForOffset(sweepLength);
      if (tip != null) {
        canvas.drawCircle(
          tip.position,
          3.2,
          Paint()..color = color,
        );
        canvas.drawCircle(
          tip.position,
          6,
          Paint()..color = color.withValues(alpha: 0.25),
        );
      }
    }
  }

  Path _buildWaveform(Size size, double baselineY) {
    final w = size.width;
    final h = size.height;
    final amp = h * 0.42;

    Path beat(double startX) {
      final path = Path()..moveTo(startX, baselineY);
      final x = startX;

      path.lineTo(x + w * 0.04, baselineY);
      path.quadraticBezierTo(
        x + w * 0.055,
        baselineY - amp * 0.14,
        x + w * 0.07,
        baselineY,
      );
      path.lineTo(x + w * 0.095, baselineY);
      path.lineTo(x + w * 0.102, baselineY + amp * 0.08);
      path.lineTo(x + w * 0.108, baselineY - amp * 0.92);
      path.lineTo(x + w * 0.114, baselineY + amp * 0.16);
      path.lineTo(x + w * 0.12, baselineY);
      path.lineTo(x + w * 0.145, baselineY);
      path.quadraticBezierTo(
        x + w * 0.165,
        baselineY - amp * 0.28,
        x + w * 0.185,
        baselineY,
      );
      return path;
    }

    final path = Path();
    path.addPath(beat(0), Offset.zero);
    path.lineTo(w * 0.22, baselineY);
    path.addPath(beat(w * 0.22), Offset.zero);
    path.lineTo(w, baselineY);
    return path;
  }

  @override
  bool shouldRepaint(covariant _PulseLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
