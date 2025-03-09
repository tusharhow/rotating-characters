import 'package:flutter/material.dart';

class AmbientGlow extends StatelessWidget {
  final bool isVisible;
  final Animation<double> glowAnimation;
  final Animation<Color?> colorAnimation;

  const AmbientGlow({
    super.key,
    required this.isVisible,
    required this.glowAnimation,
    required this.colorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: isVisible ? 1.0 : 0.0,
          child: AnimatedBuilder(
            animation: glowAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      (colorAnimation.value ?? Colors.blue)
                          .withOpacity(glowAnimation.value * 0.15),
                      (colorAnimation.value ?? Colors.blue)
                          .withOpacity(glowAnimation.value * 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),
        ),

        AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: isVisible ? 1.0 : 0.0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
                stops: const [0.6, 0.85, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
