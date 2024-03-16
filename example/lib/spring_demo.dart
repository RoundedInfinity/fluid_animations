import 'package:fluid_spring/fluid_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringDemo extends StatelessWidget {
  const SpringDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Spring'),
      ),
      body: const SpringDemoView(),
    );
  }
}

class SpringDemoView extends StatefulWidget {
  const SpringDemoView({super.key});

  @override
  State<SpringDemoView> createState() => _SpringDemoViewState();
}

class _SpringDemoViewState extends State<SpringDemoView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Animation<Alignment> _animation =
      const AlwaysStoppedAnimation(Alignment.centerLeft);

  var dampingFraction = 0.85;
  var response = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);

    _runAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runAnimation() async {
    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );

    final spring =
        FluidSpring(dampingFraction: dampingFraction, response: response);

    final simulation = SpringSimulation(spring, 0, 1, 0);

    await _controller.animateWith(simulation);

    // Loop the animation
    _runAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Align(
                alignment: _animation.value,
                child: child,
              );
            },
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Response (speed): ${response.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: response,
            onChanged: (value) {
              setState(() {
                response = value;
              });
            },
            min: 0.1,
            max: 2,
          ),
          const SizedBox(height: 24),
          Text(
            'Damping fraction (bounciness): ${dampingFraction.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: dampingFraction,
            onChanged: (value) {
              setState(() {
                dampingFraction = value;
              });
            },
            min: 0.1,
            max: 1,
          )
        ],
      ),
    );
  }
}
