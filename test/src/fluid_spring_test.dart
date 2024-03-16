// ignore_for_file: prefer_const_constructors

import 'package:fluid_animations/src/fluid_spring.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';

const _errorTolerance = 1e-3;

void testSpring(FluidSpring spring) {
  final simulation = SpringSimulation(spring, 0, 1, 0);
  expect(simulation.x(0), moreOrLessEquals(0, epsilon: _errorTolerance));
  expect(simulation.x(1), moreOrLessEquals(1, epsilon: _errorTolerance));
}

void main() {
  group('FluidSpring', () {
    test('can be instantiated', () {
      expect(FluidSpring(), isNotNull);
    });

    group('Default springs precision', () {
      test('FluidSpring', () {
        testSpring(FluidSpring());
      });
      test('Bouncy', () {
        testSpring(FluidSpring.bouncy);
      });
      test('defaultSpring', () {
        testSpring(FluidSpring.defaultSpring);
      });
      test('interactiveSpring', () {
        testSpring(FluidSpring.interactiveSpring);
      });
      test('smooth', () {
        testSpring(FluidSpring.smooth);
      });
      test('snappy', () {
        testSpring(FluidSpring.snappy);
      });
    });
  });
}
