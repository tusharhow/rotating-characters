import 'package:flutter/material.dart';

class CenterDot extends StatelessWidget {
  final bool isVisible;
  final Animation<double> animation;
  final Animation<Color?> colorAnimation;

  const CenterDot({
    super.key,
    required this.isVisible,
    required this.animation,
    required this.colorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60 + animation.value * 30,
                height: 60 + animation.value * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.blue.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              Container(
                width: 40 + animation.value * 15,
                height: 40 + animation.value * 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      (colorAnimation.value ?? Colors.blue).withOpacity(0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Container(
                width: 20 + animation.value * 10,
                height: 20 + animation.value * 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
