import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class DragDemoPage extends StatelessWidget {
  const DragDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag Demo')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: DragDemo(),
      ),
    );
  }
}

class DragDemo extends StatefulWidget {
  const DragDemo({super.key});

  @override
  State<DragDemo> createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.centerLeft;

  Animation<Alignment> _animation =
      const AlwaysStoppedAnimation(Alignment.centerLeft);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(DragEndDetails details) {
    setState(() {});
    var end =
        _dragAlignment.x < 0 ? Alignment.centerLeft : Alignment.centerRight;

    if (details.primaryVelocity!.abs() > 4000) {
      end = end == Alignment.centerLeft
          ? end = Alignment.centerRight
          : end = Alignment.centerLeft;
    }

    _animation =
        _controller.drive(AlignmentTween(begin: _dragAlignment, end: end));
    final spring = FluidSpring();

    final simulation = SpringSimulation(
        spring, 0, 1, details.primaryVelocity!.abs().clamp(-20, 20).toDouble());

    _dragAlignment = end;
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onHorizontalDragDown: (details) {},
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2.3),
            0,
          );
          _animation = AlwaysStoppedAnimation(_dragAlignment);
        });
      },
      onHorizontalDragEnd: (details) {
        _runAnimation(details);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Align(
            alignment: _animation.value,
            child: child,
          );
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
