import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress;

  BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center =
        Offset(size.width / 2, size.height / 2);

    /// 🔥 GLOWING ORB
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange.withOpacity(0.6),
          Colors.red.withOpacity(0.1),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: 150),
      );

    canvas.drawCircle(
      center.translate(
        sin(progress * 2 * pi) * 20,
        cos(progress * 2 * pi) * 20,
      ),
      120,
      paint,
    );

    /// ✨ PARTICLES
    final particlePaint = Paint()
      ..color = Colors.orange.withOpacity(0.3);

    for (int i = 0; i < 40; i++) {
      final dx = (i * 37 % size.width) +
          sin(progress * 2 * pi + i) * 20;
      final dy = (i * 53 % size.height) +
          cos(progress * 2 * pi + i) * 20;

      canvas.drawCircle(
        Offset(dx % size.width, dy % size.height),
        2,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}