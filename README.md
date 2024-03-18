# Fluid Animations

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Create effortlessly smooth and responsive animations in your Flutter apps inspired by SwiftUI's spring animations.

![Showcase of spring properties](https://raw.githubusercontent.com/RoundedInfinity/fluid_animations/master/docs/demo.gif)

## Features

- Effortlessly create smooth and responsive spring animations
- Customize animation behavior with damping and response parameters
- Choose from preset animation styles (bouncy, smooth, snappy, interactive, ...)

## Usage

The simplest way of creating a spring is using the prebuilt ones. For example:
```dart
final mySpring = FluidSpring.bouncy;
```

You can also create custom springs. `FluidSpring` has two properties: `dampingFraction` and `response`.
```dart
final mySpring = FluidSpring(dampingFraction: 0.8, response: 0.5);
```
**Response** controls how quickly an animating property value will try and get to a target. Higher values make the spring animation slower.


**Damping Fraction** is the amount of drag applied to the value being animated. A lower damping fraction will make the spring "more bouncy".

### Animating

The simplest way to animate your widgets with a spring is using the `FluidTransitionBuilder`. It animates all changes of `value` using a spring.

```dart
FluidTransitionBuilder<double>(
  value: isHovered ? 200.0 : 100.0,
  spring: FluidSpring.bouncy, // Use a bouncy spring animation
  builder: (animation, child) {
    return Container(
      width: animation.value,
      height: animation.value,
      child: child,
    );
  },
  child: const FlutterLogo()
);
```

When you need more control over your animation you can also use a `AnimationController` and run a spring simulation.
```dart
final spring = FluidSpring.smooth;

final simulation = SpringSimulation(spring, 0, 1, 0);

_controller.animateWith(simulation);
```

See the flutter example on how to [animate a widget using a physics simulation](https://docs.flutter.dev/cookbook/animation/physics-simulation).

## Acknowledgements

The math used is based on this [amazing article](https://github.com/jenox/UIKit-Playground/tree/master/01-Demystifying-UIKit-Spring-Animations/).

Values for the prebuilt springs are from the [Apple Documentation](https://developer.apple.com/documentation/swiftui/animation) on animation.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

