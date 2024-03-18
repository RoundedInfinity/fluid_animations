import 'package:example/rubberbanding.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Spring'),
      ),
      body: Center(
        child: MouseRegion(
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
            value: isHovered ? 200.0 : 100.0,
            spring: const FluidSpring(bounce: 0.3),
            builder: (animation, child) {
              return SizedBox(
                width: animation.value,
                height: animation.value,
                child: child,
              );
            },
            child: const FlutterLogo(),
          ),
        ),
      ),
    );
  }
}
