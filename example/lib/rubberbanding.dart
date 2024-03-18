import 'dart:math';

import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class RubberbandingPage extends StatelessWidget {
  const RubberbandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rubberbanding'),
      ),
      body: const RubberbandingView(),
    );
  }
}

class RubberbandingView extends StatefulWidget {
  const RubberbandingView({super.key});

  @override
  State<RubberbandingView> createState() => _RubberbandingViewState();
}

class _RubberbandingViewState extends State<RubberbandingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Offset _dragOffset = Offset.zero;

  late Animation<Offset> _animation;

  Offset initialPosition = Offset.zero;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = FluidSpring.withDamping(dampingFraction: 0.6, duration: 0.4);

    final distance = _dragOffset.distance;

    final simulation =
        SpringSimulation(spring, 0, 1, distance * 0.2 - unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    const friction = 0.7;

    return GestureDetector(
      onPanDown: (details) {
        initialPosition = details.globalPosition;
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          var offset = Offset(
            details.globalPosition.dx - initialPosition.dx,
            details.globalPosition.dy - initialPosition.dy,
          );

          final x = offset.dx > 0
              ? pow(offset.dx, friction)
              : -pow(-offset.dx, friction);
          final y = offset.dy > 0
              ? pow(offset.dy, friction)
              : -pow(-offset.dy, friction);

          _dragOffset = Offset(x.toDouble(), y.toDouble());
        });
      },
      onPanEnd: (details) {
        print(details.velocity);

        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Center(
        child: Transform.translate(
          offset: _dragOffset,
          child: Card(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
