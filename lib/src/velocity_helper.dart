import 'dart:ui';

/// A helper class for calculating velocities.
class VelocityHelper {
  /// Calculates the relative velocity from an absolute velocity within the
  /// context of a current position and a target position.
  static double getRelativeVelocity(
    double absoluteVelocity,
    double current,
    double target,
  ) {
    return absoluteVelocity / (target - current);
  }

  /// Calculates the relative velocity from an absolute velocity within the
  /// context of a current position and a target position for 2 dimensions.
  static Offset getRelativeVelocity2D(
    Offset absoluteVelocity,
    Offset current,
    Offset target,
  ) {
    return Offset(
      getRelativeVelocity(absoluteVelocity.dx, current.dx, target.dx),
      getRelativeVelocity(absoluteVelocity.dy, current.dy, target.dy),
    );
  }
}
