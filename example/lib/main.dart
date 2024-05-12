import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Spring Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Animations'),
      ),
      body: const Center(
        child: DraggableCard(),
      ),
    );
  }
}

/// A draggable card that can snaps back into its original
/// position using a spring animation when stopped dragging.
class DraggableCard extends StatefulWidget {
  const DraggableCard({super.key});

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _animation;

  /// The current position of the widget when dragging.
  var position = Offset.zero;

  @override
  void initState() {
    super.initState();

    // Using an unbound controller, that the spring animations can "bounce".
    _controller = AnimationController.unbounded(vsync: this);

    _controller.addListener(() {
      setState(() {
        position = _animation.value;
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
    return Transform.translate(
      offset: position,
      child: GestureDetector(
        onPanDown: (details) {
          _controller.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            final size = context.size;
            // Set the current position to the cursor position
            //
            // We subtract half of the widget size that the widget is
            // centered at the cursor.
            position = details.localPosition -
                Offset(size!.height / 2, size.width / 2);
          });
        },
        onPanEnd: (details) {
          // Get the absolute velocity from the gesture.
          final velocityAbsolute = details.velocity.pixelsPerSecond;

          // Now convert the absolute velocity into a relative velocity using
          // the current position and the target position.
          final relativeVelocity = VelocityHelper.getRelativeVelocity2D(
            velocityAbsolute,
            position, // Current position
            Offset.zero, // Target position (in this case the original position)
          );
          // Create a two-dimensional simulation, so we can apply the velocity
          // from the x and y direction.
          //
          // Using a one-dimensional simulation in this case would not feel smooth because
          // when you drag the widget up and then "throw" it to the right, it would just return
          // straight to its original position without reacting to the force applied to the right.
          final sim = SpringSimulation2D(
            // We start at 0 and end at 1 for both simulations meaning we play both from start to end.
            start: (0, 0),
            end: (1, 1),
            velocity: relativeVelocity,
            spring: FluidSpring.bouncy,
          );

          _animation = _controller.drive(
            FluidOffsetTween(
              begin: position,
              end: Offset.zero,
              simulation: sim,
            ),
          );

          _controller.animateWith(sim);
        },
        child: const _HoverLogo(),
      ),
    );
  }
}

class _HoverLogo extends StatefulWidget {
  const _HoverLogo();

  @override
  State<_HoverLogo> createState() => __HoverLogoState();
}

class __HoverLogoState extends State<_HoverLogo> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: FluidTransitionBuilder<double>(
        value: isHovered ? 130.0 : 100.0,
        spring: const FluidSpring(bounce: 0.3),
        builder: (animation, child) {
          return SizedBox(
            width: animation.value,
            height: animation.value,
            child: child,
          );
        },
        child: const Card(
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
