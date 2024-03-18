import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// A persistent spring animation that is based on response
/// and damping fraction.
class FluidSpring extends SpringDescription {
  /// Creates a spring with the specified duration and bounce.
  const FluidSpring({
    this.duration = 0.5,
    this.bounce = 0,
  })  : assert(
          -1 <= bounce && bounce <= 1,
          'The bounce value needs to be in a range of -1 to 1.',
        ),
        super(
          mass: 1,
          stiffness: (2 * pi / duration) * (2 * pi / duration),
          damping: 4 * pi * (1 - bounce) / duration,
        );

  /// Creates a persistent spring that is based on duration
  /// and damping fraction.
  ///
  /// [dampingFraction] is the amount of drag applied to the value being
  /// animated, as a fraction of an estimate of amount needed to produce
  /// critical damping.
  const FluidSpring.withDamping({
    double dampingFraction = 0.825,
    this.duration = 0.5,
  })  : bounce = 1 - dampingFraction,
        super(
          mass: 1,
          stiffness: (2 * pi / duration) * (2 * pi / duration),
          damping: 4 * pi * dampingFraction / duration,
        );

  /// Defines the pace of the spring.
  ///
  /// This is approximately equal to the settling duration,
  /// but for springs with very large bounce values, will be the duration of
  /// the period of oscillation for the spring.
  final double duration;

  /// How bouncy the spring should be.
  ///
  /// A value of 0 indicates no bounces (a critically damped spring),
  /// positive values indicate increasing amounts of bounciness up to a maximum
  /// of 1.0 (corresponding to undamped oscillation), and negative values
  /// indicate overdamped springs with a minimum value of -1.0.
  final double bounce;

  /// The amount of drag applied to the value being
  /// animated, as a fraction of an estimate of amount needed to produce
  /// critical damping.
  ///
  /// See also:
  /// - [FluidSpring.withDamping]
  double get dampingFraction => 1 - bounce;

  /// A smooth spring with no bounce.
  ///
  /// This uses the [default values for iOS](https://developer.apple.com/documentation/swiftui/animation/default).
  static const defaultSpring = FluidSpring.withDamping(
    dampingFraction: 1,
    duration: 0.55,
  );

  /// A spring with a predefined duration and higher amount of bounce.
  static const bouncy = FluidSpring.withDamping(
    dampingFraction: 0.7,
  );

  /// A smooth spring with a response duration and no bounce.
  static const smooth = FluidSpring.withDamping(dampingFraction: 1);

  /// A spring with a predefined response and small amount of bounce
  /// that feels more snappy.
  static const snappy = FluidSpring.withDamping(dampingFraction: 0.85);

  /// A spring animation with a lower response value,
  /// intended for driving interactive animations.
  static const interactiveSpring = FluidSpring.withDamping(
    dampingFraction: 0.86,
    duration: 0.15,
    //blend: 0.25
  );

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return '${objectRuntimeType(this, 'FluidSpring')}(bounce: $bounce, duration: $duration)';
  }
}
