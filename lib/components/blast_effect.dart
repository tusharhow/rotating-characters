import 'package:flutter/material.dart';

class BlastEffect extends StatelessWidget {
  final Animation<double> animation;
  final double maxSize;

  const BlastEffect({
    super.key,
    required this.animation,
    required this.maxSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final easedValue = Curves.easeOutQuad.transform(animation.value);
        final currentSize = easedValue * maxSize;

        return SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: currentSize,
                height: currentSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.4 * (1.0 - easedValue)),
                      Colors.blue.withOpacity(0.2 * (1.0 - easedValue)),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              Container(
                width: currentSize * 0.8,
                height: currentSize * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(0.3 * (1.0 - easedValue)),
                      Colors.purple.withOpacity(0.15 * (1.0 - easedValue)),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Container(
                width: currentSize * 0.6,
                height: currentSize * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.25 * (1.0 - easedValue)),
                      Colors.deepPurple.withOpacity(0.1 * (1.0 - easedValue)),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Container(
                width: 80 - easedValue * 40,
                height: 80 - easedValue * 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9 * (1.0 - easedValue)),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
