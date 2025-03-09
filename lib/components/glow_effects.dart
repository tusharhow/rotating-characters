import 'package:flutter/material.dart';

class GlowEffects extends StatelessWidget {
  final bool isVisible;
  final Animation<double> syncPulseAnimation;
  final Animation<Color?> syncColorAnimation;

  const GlowEffects({
    super.key,
    required this.isVisible,
    required this.syncPulseAnimation,
    required this.syncColorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedBuilder(
        animation: syncPulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,  
            children: [
               Container(
                width: 450 + syncPulseAnimation.value * 70,
                height: 450 + syncPulseAnimation.value * 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(syncPulseAnimation.value * 0.4),
                      Colors.blue.withOpacity(syncPulseAnimation.value * 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

               Container(
                width: 350 - syncPulseAnimation.value * 30,
                height: 350 - syncPulseAnimation.value * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple
                          .withOpacity((1 - syncPulseAnimation.value) * 0.4),
                      Colors.purple
                          .withOpacity((1 - syncPulseAnimation.value) * 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Container(
                width: 250 + syncPulseAnimation.value * 30,
                height: 250 + syncPulseAnimation.value * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan.withOpacity(syncPulseAnimation.value * 0.4),
                      Colors.cyan.withOpacity(syncPulseAnimation.value * 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (syncColorAnimation.value ?? Colors.blue)
                          .withOpacity(0.5),
                      (syncColorAnimation.value ?? Colors.blue)
                          .withOpacity(0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
