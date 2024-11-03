import 'dart:math';

import 'package:custom_painter_app/animations/loader_animation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController loaderController;
  late Animation<double> loaderAnimation;

  @override
  void initState() {
    super.initState();
    loaderController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    loaderAnimation = Tween(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: loaderController,
        curve: Curves.easeIn,
      ),
    );
    loaderController.repeat(reverse: true);
  }

  @override
  void dispose() {
    loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: loaderAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: loaderController.status == AnimationStatus.forward
                  ? (pi * 2) * loaderController.value
                  : -(pi * 2) * loaderController.value,
              child: CustomPaint(
                size: const Size(300, 300),
                foregroundPainter: LoaderAnimation(
                  radiusRatio: loaderAnimation.value,
                ),
                child: child,
              ),
            );
          },
          child:
              Container(width: 300, height: 300, color: Colors.cyan.shade900),
        ),
      ),
    );
  }
}
