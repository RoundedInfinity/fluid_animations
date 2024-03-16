import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// A persistent spring animation that is based on response
/// and damping fraction.
class FluidSpring extends SpringDescription {
  /// Creates a persistent spring that is based on response
  /// and damping fraction.
  ///
  /// A higher response value will slow down the animation.
  /// A lower response speeds it up.
  const FluidSpring({
    this.dampingFraction = 0.825,
    this.response = 0.5,
  }) : super(
          mass: 1,
          stiffness: (2 * pi / response) * (2 * pi / response),
          damping: 4 * pi * dampingFraction / response,
        );

  /// The amount of drag applied to the value being animated,
  /// as a fraction of an estimate of amount needed to produce critical damping.
  ///
  /// You can damp the spring in the following ways:
  ///
  /// - **Over Damping**: Set the [dampingFraction] to a value greater than 1.
  /// It lets the object you are animating, quickly return to the rest position.
  /// - **Critical Damping**:  Set the [dampingFraction] = 1.
  /// It lets the object return to the rest position within
  /// the shortest possible time.
  /// **Under Damping**:  Set the damping fraction to be less than 1.
  /// It lets the object overshoot multiple times passing the rest position and
  /// gradually reaching the rest position.
  final double dampingFraction;

  /// The stiffness of the spring, defined as an approximate
  /// duration in seconds.
  final double response;

  /// A smooth spring with no bounce.
  ///
  /// This uses the [default values for iOS](https://developer.apple.com/documentation/swiftui/animation/default).
  static const defaultSpring = FluidSpring(
    dampingFraction: 1,
    response: 0.55,
  );

  /// A spring with a predefined duration and higher amount of bounce.
  static const bouncy = FluidSpring(
    dampingFraction: 0.7,
  );

  /// A smooth spring with a response duration and no bounce.
  static const smooth = FluidSpring(dampingFraction: 1);

  /// A spring with a predefined response and small amount of bounce
  /// that feels more snappy.
  static const snappy = FluidSpring(dampingFraction: 0.85);

  /// A spring animation with a lower response value,
  /// intended for driving interactive animations.
  static const interactiveSpring = FluidSpring(
    dampingFraction: 0.86,
    response: 0.15,
    //blend: 0.25
  );

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return '${objectRuntimeType(this, 'FluidSpring')}(dampingFraction: $dampingFraction, response: $response)';
  }
}
