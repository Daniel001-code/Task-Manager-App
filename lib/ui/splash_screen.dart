import 'package:flutter/material.dart';

import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    // Animation Controller for 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Scaling Animation from 1.5x to 0.0 (Zoom Out)
    _animation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Navigate to home screen after animation
    Timer(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
  }

  @override
  void dispose() {
    _controller.stop(); // Stop the animation before disposing
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'lib/assets/images/app-logo.png', // Replace with your image
            // Initial size
          ),
        ),
      ),
    );
  }
}
