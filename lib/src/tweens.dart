import 'dart:ui';

import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/widgets.dart';

/// A non-linear interpolation between two alignments using two separate spring
/// animations.
///
/// See also:
/// - [SpringSimulation2D], which is responsible for simulating two springs.
/// - [FluidOffsetTween], similar to this but for Offset.
class FluidAlignmentTween extends Tween<Alignment> {
  /// Creates an [Alignment] tween that is driven by a [SpringSimulation2D].
  ///
  /// The `x` and `y` values of [Alignment] are interpolated using two
  /// independent spring simulations.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as meaning the center.
  FluidAlignmentTween({
    required this.simulation,
    super.begin,
    super.end,
  });

  /// The simulation used to animate the `x` and `y` values.
  final SpringSimulation2D simulation;

  @override
  Alignment lerp(double t) {
    if (identical(begin, end)) {
      return begin!;
    }
    // Time of the second animation.
    final ty = simulation.y(simulation.deltaTime);
    if (begin == null) {
      return Alignment(
        lerpDouble(0.0, end!.x, t)!,
        lerpDouble(0.0, end!.y, ty)!,
      );
    }
    if (end == null) {
      return Alignment(
        lerpDouble(begin!.x, 0.0, t)!,
        lerpDouble(begin!.y, 0.0, ty)!,
      );
    }
    return Alignment(
      lerpDouble(begin!.x, end!.x, t)!,
      lerpDouble(begin!.y, end!.y, ty)!,
    );
  }
}

/// A non-linear interpolation between two [Offset] values using two separate
/// spring animations.
///
/// See also:
/// - [SpringSimulation2D], which is responsible for simulating two springs.
/// - [FluidAlignmentTween], similar to this but for Alignment.

class FluidOffsetTween extends Tween<Offset> {
  /// Creates an Offset tween that is driven by a [SpringSimulation2D].
  ///
  /// The dx and dy values of Offset are interpolated using two independent
  /// spring simulations.
  FluidOffsetTween({
    required this.simulation,
    super.begin,
    super.end,
  });

  /// The [SpringSimulation2D] used to animate the dx and dy values.
  final SpringSimulation2D simulation;

  @override
  Offset lerp(double t) {
    if (identical(begin, end)) {
      return begin!;
    }

    return Offset(
      lerpDouble(begin!.dx, end!.dx, t)!,
      lerpDouble(begin!.dy, end!.dy, simulation.y(simulation.deltaTime))!,
    );
  }
}
