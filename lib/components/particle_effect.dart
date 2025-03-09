import 'package:flutter/material.dart';
import 'dart:math';

class ParticleEffect extends StatelessWidget {
  final List<Map<String, dynamic>> particles;
  final bool isVisible;
  final Animation<double> syncPulseAnimation;
  final Animation<Color?> syncColorAnimation;

  const ParticleEffect({
    super.key,
    required this.particles,
    required this.isVisible,
    required this.syncPulseAnimation,
    required this.syncColorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(particles.length, (index) {
        final particle = particles[index];
        final x = particle['radius'] * cos(particle['angle']);
        final y = particle['radius'] * sin(particle['angle']);

        return Positioned(
          left:
              MediaQuery.of(context).size.width / 2 + x - particle['size'] / 2,
          top:
              MediaQuery.of(context).size.height / 2 + y - particle['size'] / 2,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            opacity: isVisible ? 1.0 : 0.0,
            child: AnimatedBuilder(
              animation: syncPulseAnimation,
              builder: (context, child) {
                final size = particle['size'] +
                    syncPulseAnimation.value * particle['size'] * 0.5;
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (syncColorAnimation.value ?? Colors.blue)
                            .withOpacity(particle['opacity'] * 0.9),
                        (syncColorAnimation.value ?? Colors.blue)
                            .withOpacity(particle['opacity'] * 0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
