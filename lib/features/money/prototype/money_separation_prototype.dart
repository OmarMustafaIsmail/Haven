import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';

/// Throwaway prototype — single object opens to reveal money places.
/// Motion-first. Not production.
class MoneySeparationPrototype extends StatefulWidget {
  const MoneySeparationPrototype({super.key});

  @override
  State<MoneySeparationPrototype> createState() =>
      _MoneySeparationPrototypeState();
}

class _MoneyPlace {
  const _MoneyPlace(this.amount, this.label, this.anchorX, this.anchorY);

  final int amount;
  final String label;
  /// Organic field position (0–1 of usable area).
  final double anchorX;
  final double anchorY;
}

class _MoneySeparationPrototypeState extends State<MoneySeparationPrototype>
    with TickerProviderStateMixin {
  static const _places = [
    _MoneyPlace(28000, 'Main Bank', 0.14, 0.36),
    _MoneyPlace(8200, 'Savings', 0.58, 0.30),
    _MoneyPlace(3500, 'Cash', 0.16, 0.56),
    _MoneyPlace(2650, 'Wallet', 0.56, 0.58),
  ];

  static const _total = 42350;
  static const _fullDrag = 140.0;
  static const _placeStagger = 0.075;

  late final AnimationController _progress;
  late final AnimationController _focus;
  final _amountFormat = NumberFormat('#,##0', 'en_US');

  int? _focusedIndex;
  bool _hapticOpenFired = false;

  Size _sceneSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(_onProgressTick);

    _focus = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _progress.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onProgressTick() {
    final p = _p;
    if (p > 0.32 && !_hapticOpenFired) {
      _hapticOpenFired = true;
      HapticFeedback.lightImpact();
    } else if (p < 0.12) {
      _hapticOpenFired = false;
    }
    setState(() {});
  }

  double get _p => _progress.value.clamp(0.0, 1.0);

  double _phase(double start, double end) =>
      ((_p - start) / (end - start)).clamp(0.0, 1.0);

  double get _lift => Curves.easeOutCubic.transform(_phase(0, 0.22));
  double get _warmthFade => (1 - _phase(0.15, 0.42)).clamp(0.0, 1.0);
  double get _splitGlobal =>
      Curves.easeOutCubic.transform(_phase(0.22, 0.65));
  double get _labelsGlobal =>
      Curves.easeOut.transform(_phase(0.78, 0.90));
  double get _monolithOpacity =>
      (1 - _phase(0.20, 0.55)).clamp(0.0, 1.0);
  double get _unifiedOpacity =>
      (1 - Curves.easeIn.transform((_splitGlobal * 1.05).clamp(0.0, 1.0)))
          .clamp(0.0, 1.0);

  double _placeSplit(int index) {
    final stagger = index * _placeStagger;
    final denom = (1 - stagger * 0.9).clamp(0.05, 1.0);
    final t = ((_splitGlobal - stagger) / denom).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(t);
  }

  double _placeLabels(int index) {
    final stagger = index * 0.06;
    final denom = (1 - stagger).clamp(0.05, 1.0);
    final t = ((_labelsGlobal - stagger) / denom).clamp(0.0, 1.0);
    return Curves.easeOut.transform(t);
  }

  double get _monolithStretchY => 1.0 + _lift * 0.06 + _splitGlobal * 0.06;
  double get _monolithStretchX => 1.0 - _lift * 0.015 - _splitGlobal * 0.02;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_focusedIndex != null) {
      if (details.delta.dy > 2) {
        setState(() {
          _focusedIndex = null;
          _focus.value = 0;
        });
      } else {
        return;
      }
    }
    final resistance = 1.0 + _p * 2.2;
    final delta = -details.delta.dy / (_fullDrag * resistance);
    _progress.value = (_progress.value + delta).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_focusedIndex != null) {
      _clearFocus();
      return;
    }
    _snapTo(_progress.value > 0.42 ? 1.0 : 0.0);
  }

  void _snapTo(double target) {
    _progress.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 155, damping: 23),
        _progress.value.clamp(0.0, 1.0),
        target,
        0,
      ),
    );
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (target == 0.0 && _p < 0.06) {
        HapticFeedback.selectionClick();
      } else if (target == 1.0 && _p > 0.94) {
        HapticFeedback.selectionClick();
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    if (_p < 0.85) return;

    final hit = _hitTestPlace(details.localPosition, _sceneSize);
    if (hit == null) {
      if (_focusedIndex != null) _clearFocus();
      return;
    }

    if (_focusedIndex == hit) {
      _clearFocus();
      return;
    }

    setState(() => _focusedIndex = hit);
    _focus.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  Offset _driftOrigin(Size size) => Offset(size.width * 0.5, size.height * 0.54);

  Offset _placePositionAt(int index, double split, Size size) {
    final place = _places[index];
    final fieldTop = size.height * 0.22;
    final fieldHeight = size.height * 0.52;

    final target = Offset(
      size.width * place.anchorX,
      fieldTop + fieldHeight * place.anchorY,
    );

    final eased = Curves.easeOutCubic.transform(split.clamp(0.0, 1.0));
    return Offset.lerp(_driftOrigin(size), target, eased)!;
  }

  int? _hitTestPlace(Offset local, Size size) {
    if (_splitGlobal < 0.5) return null;

    const hitSlop = 56.0;
    for (var i = _places.length - 1; i >= 0; i--) {
      final split = _placeSplit(i);
      if (split < 0.4) continue;

      final pos = _placePositionAt(i, split, size);
      final rect = Rect.fromLTWH(
        pos.dx - 8,
        pos.dy - 8,
        160 + hitSlop,
        64 + hitSlop,
      );
      if (rect.contains(local)) return i;
    }
    return null;
  }

  void _clearFocus() {
    _focus.reverse().then((_) {
      if (mounted) setState(() => _focusedIndex = null);
    });
  }

  String _formatAmount(int amount) => _amountFormat.format(amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              onTapUp: _onTapUp,
              onDoubleTap: () {
                if (_focusedIndex != null) {
                  _clearFocus();
                  return;
                }
                _snapTo(_progress.value < 0.5 ? 1.0 : 0.0);
              },
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    _WarmField(opacity: _warmthFade),
                    _buildScene(constraints),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScene(BoxConstraints constraints) {
    _sceneSize = Size(constraints.maxWidth, constraints.maxHeight);
    final liftPx = _lift * 24;

    return Transform.translate(
      offset: Offset(0, -liftPx),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Unified hero
          if (_unifiedOpacity > 0.01)
            Align(
              alignment: Alignment(0, -0.14),
              child: Opacity(
                opacity: _unifiedOpacity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HavenSpacing.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your Money',
                        textAlign: TextAlign.center,
                        style: HavenTypography.body.copyWith(
                          color: HavenColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: HavenSpacing.lg),
                      Text(
                        '${_formatAmount(_total)} EGP',
                        textAlign: TextAlign.center,
                        style: HavenTypography.amountStyle(),
                      ),
                      const SizedBox(height: HavenSpacing.sm),
                      Opacity(
                        opacity: (1 - _splitGlobal * 2).clamp(0.0, 1.0),
                        child: Text(
                          'All of it, together.',
                          textAlign: TextAlign.center,
                          style: HavenTypography.bodySmall.copyWith(
                            color: HavenColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Soft monolith — the single object
          if (_monolithOpacity > 0.01)
            Align(
              alignment: Alignment(0, 0.08),
              child: Opacity(
                opacity: _monolithOpacity,
                child: _MoneyMonolith(
                  stretchX: _monolithStretchX,
                  stretchY: _monolithStretchY,
                ),
              ),
            ),

          // Breathing affordance at rest
          if (_p < 0.04)
            const Align(
              alignment: Alignment(0, 0.22),
              child: _BreathAffordance(),
            ),

          // Places — organic field
          if (_splitGlobal > 0.001)
            for (var i = 0; i < _places.length; i++)
              _buildPlaceNode(i),
        ],
      ),
    );
  }

  Widget _buildPlaceNode(int index) {
    final split = _placeSplit(index);
    if (split <= 0) return const SizedBox.shrink();

    final place = _places[index];
    final labels = _placeLabels(index);
    final pos = _placePositionAt(index, split, _sceneSize);

    final isFocused = _focusedIndex == index;
    final hasFocus = _focusedIndex != null;
    final focusT = Curves.easeOutCubic.transform(_focus.value.clamp(0.0, 1.0));

    double opacity = Curves.easeOut.transform(
      ((split - 0.05) / 0.95).clamp(0.0, 1.0),
    );
    double scale = 0.88 + split * 0.12;
    Offset offset = pos;

    if (hasFocus && _p > 0.85) {
      final center = Offset(_sceneSize.width * 0.5, _sceneSize.height * 0.44);

      if (isFocused) {
        opacity = 1.0;
        scale = scale + focusT * 0.08;
        offset = Offset.lerp(pos, center, focusT * 0.55)!;
      } else {
        opacity = opacity * (1 - focusT * 0.65);
        scale = scale * (1 - focusT * 0.08);
      }
    }

    final fontSize = 28.0 + split * 4.0;

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatAmount(place.amount),
                  style: HavenTypography.amountStyle().copyWith(
                    fontSize: fontSize.clamp(28.0, 32.0),
                    height: 1.1,
                  ),
                ),
                SizedBox(height: HavenSpacing.xs + labels * 4),
                Opacity(
                  opacity: labels,
                  child: Text(
                    place.label,
                    style: HavenTypography.caption.copyWith(
                      color: HavenColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft capsule — one financial life. Not a pebble.
class _MoneyMonolith extends StatefulWidget {
  const _MoneyMonolith({
    required this.stretchX,
    required this.stretchY,
  });

  final double stretchX;
  final double stretchY;

  @override
  State<_MoneyMonolith> createState() => _MoneyMonolithState();
}

class _MoneyMonolithState extends State<_MoneyMonolith>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breath,
      builder: (context, child) {
        final idle = 1.0 + _breath.value * 0.02;
        return Transform.scale(
          scaleX: widget.stretchX,
          scaleY: widget.stretchY * idle,
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: HavenColors.primaryLight.withValues(alpha: 0.55),
          border: Border.all(
            color: HavenColors.primaryMuted.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

class _WarmField extends StatelessWidget {
  const _WarmField({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity * 0.65,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.15),
              radius: 0.8,
              colors: [
                HavenColors.primaryLight.withValues(alpha: 0.4),
                HavenColors.background.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _BreathAffordance extends StatefulWidget {
  const _BreathAffordance();

  @override
  State<_BreathAffordance> createState() => _BreathAffordanceState();
}

class _BreathAffordanceState extends State<_BreathAffordance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breath,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_breath.value.clamp(0.0, 1.0));
        return Transform.translate(
          offset: Offset(0, -2.5 * t),
          child: Opacity(
            opacity: 0.16 + t * 0.16,
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 22,
              color: HavenColors.primary.withValues(alpha: 0.38),
            ),
          ),
        );
      },
    );
  }
}
