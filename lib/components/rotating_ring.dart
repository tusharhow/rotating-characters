import 'package:flutter/material.dart';
import 'dart:math';

class RotatingRing extends StatelessWidget {
  final List<String> letters;
  final List<Offset> positions;
  final double rotation;
  final double opacity;
  final bool isSynchronized;
  final double fontSize;
  final FontWeight fontWeight;

  const RotatingRing({
    super.key,
    required this.letters,
    required this.positions,
    required this.rotation,
    required this.opacity,
    required this.isSynchronized,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(letters.length, (index) {
        final basePosition = positions[index];
        final angle = 2 * pi * index / letters.length + rotation;

        final x =
            basePosition.dx * cos(rotation) - basePosition.dy * sin(rotation);
        final y =
            basePosition.dx * sin(rotation) + basePosition.dy * cos(rotation);

        return Transform(
          transform: Matrix4.translationValues(x, y, 0)
            ..rotateZ(angle + pi / 2), 
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            opacity: opacity,
            child: Text(
              letters[index],
              style: TextStyle(
                color: isSynchronized
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.8),
                fontWeight: fontWeight,
                fontSize: fontSize,
                shadows: isSynchronized
                    ? [
                        Shadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : [], 
              ),
            ),
          ),
        );
      }),
    );
  }
}
