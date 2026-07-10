import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_motion.dart';
import '../../../theme/haven_spacing.dart';

class PullPulseReveal extends StatefulWidget {
  const PullPulseReveal({
    super.key,
    required this.child,
    required this.pullProgress,
    required this.pulseSettled,
    required this.hapticThresholdCrossed,
    required this.onPullProgress,
    required this.onPullReleased,
    required this.onPullReset,
  });

  final Widget child;
  final double pullProgress;
  final bool pulseSettled;
  final bool hapticThresholdCrossed;
  final ValueChanged<double> onPullProgress;
  final VoidCallback onPullReleased;
  final VoidCallback onPullReset;

  @override
  State<PullPulseReveal> createState() => _PullPulseRevealState();
}

class _PullPulseRevealState extends State<PullPulseReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  bool _thresholdHapticFired = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: HavenMotion.pulseBreathDuration,
    );
  }

  @override
  void didUpdateWidget(covariant PullPulseReveal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.hapticThresholdCrossed && !_thresholdHapticFired) {
      _thresholdHapticFired = true;
      HapticFeedback.lightImpact();
    }

    if (!widget.hapticThresholdCrossed) {
      _thresholdHapticFired = false;
    }

    if (widget.pulseSettled && !oldWidget.pulseSettled) {
      HapticFeedback.selectionClick();
      _breathController.repeat(reverse: true);
      Future<void>.delayed(HavenMotion.pulseSettleDuration, () {
        if (!mounted) return;
        widget.onPullReset();
        _breathController.stop();
        _breathController.reset();
      });
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final revealHeight = widget.pullProgress * HavenMotion.pullThreshold;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: revealHeight + HavenSpacing.xxl,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: HavenColors.pulseRevealGradient,
            ),
            child: Center(
              child: _PulseOrb(
                progress: widget.pullProgress,
                settled: widget.pulseSettled,
                breath: _breathController,
              ),
            ),
          ),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >= 0 &&
                notification is ScrollEndNotification) {
              widget.onPullReleased();
            }

            if (notification is ScrollUpdateNotification &&
                notification.metrics.pixels < 0) {
              final progress = (-notification.metrics.pixels /
                      HavenMotion.pullThreshold)
                  .clamp(0.0, 1.0);
              widget.onPullProgress(progress);
            }

            if (notification is ScrollEndNotification &&
                notification.metrics.pixels >= 0 &&
                widget.pullProgress < 0.45) {
              widget.onPullReset();
            }

            return false;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class _PulseOrb extends StatelessWidget {
  const _PulseOrb({
    required this.progress,
    required this.settled,
    required this.breath,
  });

  final double progress;
  final bool settled;
  final AnimationController breath;

  @override
  Widget build(BuildContext context) {
    final baseSize = HavenSpacing.xl + (progress * HavenSpacing.lg);

    return AnimatedBuilder(
      animation: breath,
      builder: (context, child) {
        final breathScale = settled ? 1 + (breath.value * 0.08) : 1.0;
        final opacity = (0.35 + progress * 0.45).clamp(0.0, 0.85);

        return Transform.scale(
          scale: breathScale,
          child: Container(
            width: baseSize,
            height: baseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: settled
                  ? HavenColors.pulseStrong.withValues(alpha: opacity)
                  : HavenColors.pulseCalm.withValues(alpha: opacity),
              boxShadow: [
                BoxShadow(
                  color: HavenColors.pulseCalm.withValues(alpha: opacity * 0.5),
                  blurRadius: HavenSpacing.lg,
                  spreadRadius: HavenSpacing.xs,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
