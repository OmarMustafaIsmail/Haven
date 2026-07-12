import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/pulse_state.dart';
import '../theme/haven_colors.dart';
import '../theme/haven_motion.dart';
import '../theme/haven_spacing.dart';
import 'animation/pulse_animation_engine.dart';
import 'controller/pulse_ritual_controller.dart';
import 'layout/pulse_layout_resolver.dart';
import 'pulse_colors.dart';
import 'pulse_ritual_phase.dart';
import 'visual/pulse_circle.dart';

/// Haven's Financial Check-In ritual — reusable, Home-agnostic.
///
/// Emits events. Never imports Home or business logic.
/// See [HDL/13-financial-pulse.md] for component boundaries.
class FinancialPulse extends StatefulWidget {
  const FinancialPulse({
    super.key,
    required this.greeting,
    required this.pulseState,
    this.showHeroPresentation = true,
    this.heroSettleDelay = const Duration(milliseconds: 1000),
    this.conceptCChrome = false,
    this.headerBackground,
    this.headerToolbar,
    this.onPresentationSettled,
    this.onBeatStarted,
    this.onCheckInStarted,
    this.onThresholdReached,
    this.onResolveBeat,
    this.onBeatProgress,
    this.onHeartbeatFinished,
    this.onReturnedHome,
    this.onPullProgress,
    this.onLayerTransitionStarted,
    this.onLayerMorphProgress,
    this.onLayerTransitionFinished,
    this.child,
    this.backgroundColor = HavenColors.background,
  });

  final String greeting;
  final PulseState pulseState;
  final bool showHeroPresentation;
  final Duration heroSettleDelay;
  final bool conceptCChrome;
  final Widget? headerBackground;
  final Widget? headerToolbar;

  final VoidCallback? onPresentationSettled;

  /// Member began the beat gesture (pull down).
  final VoidCallback? onBeatStarted;

  /// Alias — same as [onBeatStarted].
  final VoidCallback? onCheckInStarted;

  /// Beat threshold reached — double heartbeat begins.
  final VoidCallback? onThresholdReached;

  /// Pulse Check-In resolution — awaited after heartbeat before return home.
  final Future<void> Function()? onResolveBeat;

  /// Progress through the beat animation (0–1), including both beats.
  final ValueChanged<double>? onBeatProgress;

  final VoidCallback? onHeartbeatFinished;
  final VoidCallback? onReturnedHome;

  /// Alias for [onBeatProgress] during the pre-beat pull.
  final ValueChanged<double>? onPullProgress;

  /// Layer navigation began (PD-031).
  final VoidCallback? onLayerTransitionStarted;

  /// Body morph progress during layer heartbeat (0–1).
  final ValueChanged<double>? onLayerMorphProgress;

  /// Layer navigation complete — Pulse returned to header.
  final VoidCallback? onLayerTransitionFinished;

  final Widget? child;
  final Color backgroundColor;

  @override
  State<FinancialPulse> createState() => FinancialPulseState();
}

class FinancialPulseState extends State<FinancialPulse>
    with TickerProviderStateMixin {
  late final PulseRitualController _controller;
  late final PulseAnimationEngine _engine;

  bool _beatStartedFired = false;
  bool _thresholdHapticFired = false;
  bool _scrollAtTop = true;
  Future<void>? _beatResolveFuture;

  @override
  void initState() {
    super.initState();
    _controller = PulseRitualController(startWithHero: widget.showHeroPresentation);
    _engine = PulseAnimationEngine(this);

    if (widget.showHeroPresentation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleHeroSettle();
      });
    }
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  void _scheduleHeroSettle() {
    if (widget.heroSettleDelay > Duration.zero) {
      Future<void>.delayed(widget.heroSettleDelay, () {
        if (!mounted) return;
        _runHeroSettle();
      });
      return;
    }
    Future<void>.microtask(() {
      if (!mounted) return;
      _runHeroSettle();
    });
  }

  void _runHeroSettle() {
    if (!mounted || _controller.phase != PulseRitualPhase.heroPresentation) {
      return;
    }
    _controller.beginSettleToHeader();
    setState(() {});

    _engine.heroSettle.addListener(_onHeroSettleTick);
    _engine.runHeroSettle(onComplete: () {
      if (!mounted) return;
      _engine.heroSettle.removeListener(_onHeroSettleTick);
      _controller.completeSettleToHeader();
      setState(() {});
      widget.onPresentationSettled?.call();
    });
  }

  void _onHeroSettleTick() => setState(() {});

  bool get _beatGestureEnabled {
    if (_controller.isLayerTransitionActive) return false;
    if (_controller.phase == PulseRitualPhase.checkInPull) return true;
    if (!_controller.canPull) return false;
    return _scrollAtTop;
  }

  /// Pulse-anchored layer transition — no financial reading (PD-031).
  Future<void> runLayerTransition({
    required VoidCallback onMorphStart,
    ValueChanged<double>? onMorphProgress,
  }) async {
    if (_controller.isRitualActive || _controller.isLayerTransitionActive) {
      return;
    }

    widget.onLayerTransitionStarted?.call();
    _controller.beginLayerTransition();
    setState(() {});

    final travelDone = Completer<void>();
    _engine.runLayerTravel(
      onTick: () {
        _controller.updateLayerTravel(
          HavenMotion.layerCurve.transform(_engine.layerTravel.value),
        );
        setState(() {});
      },
      onComplete: () {
        _controller.completeLayerTravel();
        travelDone.complete();
      },
    );
    await travelDone.future;
    if (!mounted) return;

    onMorphStart();
    setState(() {});

    final heartbeatDone = Completer<void>();
    _engine.runLightHeartbeat(
      onTick: () {
        final t = _engine.layerHeartbeat.value;
        onMorphProgress?.call(t);
        widget.onLayerMorphProgress?.call(t);
        setState(() {});
      },
      onComplete: () {
        _controller.completeLayerHeartbeat();
        heartbeatDone.complete();
      },
    );
    await heartbeatDone.future;
    if (!mounted) return;

    final returnDone = Completer<void>();
    _engine.returnHome.addListener(_onReturnTick);
    _engine.runReturnHome(onComplete: () {
      if (!mounted) return;
      _engine.returnHome.removeListener(_onReturnTick);
      _controller.completeLayerReturn();
      widget.onLayerTransitionFinished?.call();
      returnDone.complete();
    });
    await returnDone.future;
    if (mounted) setState(() {});
  }

  bool _onScrollNotification(ScrollNotification notification) {
    final atTop = notification.metrics.pixels <= 0;
    if (atTop != _scrollAtTop) {
      setState(() => _scrollAtTop = atTop);
    }
    return false;
  }

  void _emitPullProgress(double value) {
    widget.onPullProgress?.call(value);
  }

  void _emitBeatProgress(double value) {
    widget.onBeatProgress?.call(value);
  }

  void _onBeatPullUpdate(double delta) {
    if (!_beatGestureEnabled &&
        _controller.phase != PulseRitualPhase.checkInPull) {
      return;
    }

    final wasIdle = _controller.phase == PulseRitualPhase.headerRest;
    _controller.updatePull(delta);

    if (wasIdle && _controller.phase == PulseRitualPhase.checkInPull) {
      _beatStartedFired = false;
      _thresholdHapticFired = false;
    }

    if (!_beatStartedFired && _controller.phase == PulseRitualPhase.checkInPull) {
      _beatStartedFired = true;
      widget.onBeatStarted?.call();
      widget.onCheckInStarted?.call();
    }

    _emitPullProgress(_controller.pullProgress);

    if (_controller.pullProgress >= HavenMotion.pullHapticThreshold &&
        !_thresholdHapticFired) {
      _thresholdHapticFired = true;
      _engine.hapticThreshold();
    }

    setState(() {});
  }

  void _onBeatPullEnd() {
    if (_controller.phase != PulseRitualPhase.checkInPull) return;

    if (_controller.endPull()) {
      widget.onThresholdReached?.call();
      _beatResolveFuture = widget.onResolveBeat?.call();
      _runHeartbeat();
    } else {
      _emitPullProgress(0);
      setState(() {});
    }
  }

  void _runHeartbeat() {
    if (!mounted) return;
    _controller.beginHeartbeat();
    setState(() {});

    _engine.runHeartbeat(
      onTick: () {
        _emitBeatProgress(_engine.heartbeat.value);
        setState(() {});
      },
      onComplete: () async {
        if (!mounted) return;
        _controller.completeHeartbeat();
        if (_beatResolveFuture != null) {
          await _beatResolveFuture;
        }
        if (!mounted) return;
        widget.onHeartbeatFinished?.call();
        _beatResolveFuture = null;
        _runReturnHome();
      },
    );
  }

  void _runReturnHome() {
    if (!mounted) return;
    setState(() {});

    _engine.returnHome.addListener(_onReturnTick);
    _engine.runReturnHome(onComplete: () {
      if (!mounted) return;
      _engine.returnHome.removeListener(_onReturnTick);
      _controller.completeReturn();
      widget.onReturnedHome?.call();
      _emitPullProgress(0);
      _beatStartedFired = false;
      _thresholdHapticFired = false;
      setState(() {});
    });
  }

  void _onReturnTick() => setState(() {});

  PulseLayoutFrame _resolveFrame({
    required PulseRitualPhase phase,
    required EdgeInsets padding,
    required double width,
    double pullProgress = 0,
    double heartbeatT = 0,
    double returnT = 0,
    double heroSettleT = 0,
  }) {
    return PulseLayoutResolver.resolve(
      phase: phase,
      breath: _engine.breath.value,
      heroSettleT: heroSettleT,
      pullProgress: pullProgress,
      heartbeatT: heartbeatT,
      returnT: returnT,
      width: width,
      padding: padding,
      conceptCChrome: widget.conceptCChrome,
    );
  }

  double _overlayHeight(PulseLayoutFrame frame) {
    final pulseBottom =
        frame.pulseCenter.dy + frame.pulseDiameter * frame.pulseScale / 2;
    return math.max(frame.chromeHeight, pulseBottom + 16);
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);
    final padding = EdgeInsets.fromLTRB(
      HavenSpacing.md,
      viewPadding.top,
      HavenSpacing.md,
      0,
    );
    final width = MediaQuery.sizeOf(context).width;

    final phase = _controller.phase;
    final pullProgress = phase == PulseRitualPhase.layerTravelToCenter
        ? _controller.layerTravelProgress
        : _controller.pullProgress;
    final heartbeatT = phase == PulseRitualPhase.layerHeartbeat
        ? _engine.layerHeartbeat.value
        : _engine.heartbeat.value;
    final returnT = phase == PulseRitualPhase.layerReturnToHeader
        ? _engine.returnHome.value
        : _engine.returnHome.value;

    final frame = _resolveFrame(
      phase: phase,
      padding: padding,
      width: width,
      pullProgress: pullProgress,
      heartbeatT: heartbeatT,
      returnT: returnT,
      heroSettleT: _engine.heroSettle.value,
    );

    final restingFrame = _resolveFrame(
      phase: PulseRitualPhase.headerRest,
      padding: padding,
      width: width,
    );

    final color = pulseColorFor(widget.pulseState);
    final overlayHeight = _overlayHeight(frame);
    final liveContentShift = frame.contentShift +
        (_controller.phase == PulseRitualPhase.checkInPull
            ? _controller.pullOffset * 0.22
            : 0);

    final isRitualElevated =
        _controller.isRitualActive || _controller.isLayerTransitionActive;

    return ColoredBox(
      color: widget.backgroundColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: _beatGestureEnabled
              ? (event) {
                  if (event.delta.dy > 0) {
                    _onBeatPullUpdate(event.delta.dy);
                  } else if (_controller.phase == PulseRitualPhase.checkInPull) {
                    _onBeatPullUpdate(event.delta.dy);
                  }
                }
              : null,
          onPointerUp: _beatGestureEnabled ? (_) => _onBeatPullEnd() : null,
          onPointerCancel: _beatGestureEnabled ? (_) => _onBeatPullEnd() : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (widget.child != null)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, liveContentShift),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: restingFrame.chromeHeight - HavenSpacing.sm,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: overlayHeight,
                child: IgnorePointer(
                  child: Material(
                    color: Colors.transparent,
                    elevation: isRitualElevated ? 4 : 0,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (widget.headerBackground != null)
                          Positioned.fill(child: widget.headerBackground!),
                        if (widget.headerToolbar != null)
                          Positioned(
                            top: viewPadding.top,
                            left: 0,
                            right: 0,
                            child: widget.headerToolbar!,
                          ),
                        Positioned(
                          left: frame.greetingOffset.dx,
                          top: frame.greetingOffset.dy,
                          child: Text(
                            widget.greeting,
                            style: frame.greetingStyle,
                          ),
                        ),
                        Positioned(
                          left: frame.pulseCenter.dx - frame.pulseDiameter / 2,
                          top: frame.pulseCenter.dy - frame.pulseDiameter / 2,
                          child: PulseCircle(
                            color: color,
                            diameter: frame.pulseDiameter,
                            glowOpacity: frame.pulseGlow,
                            scale: frame.pulseScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
