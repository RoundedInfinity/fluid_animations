// ignore_for_file: cascade_invocations

import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

import 'package:flutter/widgets.dart';

/// {@template fluid_transition_builder}
/// A widget that creates smooth, physics-based transitions between values.
///
/// Whenever [value] changes, this smoothly animated to the new value
/// using [spring].
///
/// The [Duration] of this transition is based on the [spring].
///
/// **Example Usage**
///
/// ```dart
/// FluidTransitionBuilder<double>(
///   value: isHovered ? 200.0 : 100.0,
///   spring: FluidSpring.bouncy, // Use a bouncy spring animation
///   builder: (animation, child) {
///     return Container(
///       width: animation.value,
///       height: animation.value,
///       child: child,
///     );
///   },
///   child: const FlutterLogo()
/// );
/// ```
///
/// See also:
/// - [FluidSpring] a spring for smooth animations.
/// - [AnimatedBuilder] see the *Performance optimizations* docs.
/// {@endtemplate}
class FluidTransitionBuilder<T> extends StatefulWidget {
  /// Creates a [FluidTransitionBuilder].
  ///
  /// {@macro fluid_transition_builder}
  const FluidTransitionBuilder({
    required this.value,
    required this.builder,
    this.spring = const FluidSpring(),
    this.child,
    this.upperBound,
    this.lowerBound,
    super.key,
  }) : assert(
          (upperBound != null && lowerBound != null) ||
              (upperBound == null && lowerBound == null),
          'upperBound and lowerBound have to be set for a bound animation. '
          'For an unbound animation both have to be null',
        );

  /// The target value for the transition.
  ///
  /// Whenever this value changes, the widget smoothly animates from
  /// the previous value to the new one.
  final T value;

  /// The spring behavior of the transition.
  ///
  /// Modify this for bounciness and duration.
  ///
  /// Typically a [FluidSpring].
  final SpringDescription spring;

  /// A function that builds the widget undergoing transition.
  final Widget Function(Animation<T> animation, Widget? child) builder;

  /// An optional child widget.
  ///
  /// {@macro flutter.widgets.transitions.ListenableBuilder.optimizations}
  final Widget? child;

  /// The value at which this animation is deemed to be completed.
  ///
  /// Can be used to clamp the spring to a maximal value.
  final double? upperBound;

  /// The value at which this animation is deemed to be dismissed.
  ///
  /// Can be used to clamp the spring to a minimal value.
  final double? lowerBound;

  @override
  State<FluidTransitionBuilder<T>> createState() =>
      _FluidTransitionBuilderState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<T>('value', value));
    properties
        .add(DoubleProperty('upperBound', upperBound, ifNull: 'infinite'));
    properties
        .add(DoubleProperty('lowerBound', lowerBound, ifNull: 'infinite'));
    properties.add(DiagnosticsProperty<SpringDescription>('spring', spring));
  }
}

class _FluidTransitionBuilderState<T> extends State<FluidTransitionBuilder<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<T> _animation;

  @override
  void initState() {
    super.initState();

    _initController();
    _animation = AlwaysStoppedAnimation(widget.value);
  }

  void _initController() {
    if (widget.upperBound == null && widget.lowerBound == null) {
      _controller = AnimationController.unbounded(vsync: this);
    } else {
      _controller = AnimationController(
        vsync: this,
        upperBound: widget.upperBound!,
        lowerBound: widget.lowerBound!,
      );
    }
  }

  @override
  void didUpdateWidget(covariant FluidTransitionBuilder<T> oldWidget) {
    final oldValue = oldWidget.value;

    final newValue = widget.value;

    if (oldValue != newValue) {
      _animation =
          _controller.drive(Tween<T>(begin: _animation.value, end: newValue));

      final simulation =
          SpringSimulation(widget.spring, 0, 1, -_controller.velocity);

      _controller.animateWith(simulation);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => widget.builder(_animation, child),
      child: widget.child,
    );
  }
}
