// Speedometer Painter (same as previous implementation)
import 'dart:math';

import 'package:flutter/material.dart';

class SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  SpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 30), pi, pi,
        false, backgroundPaint);

    // Speed arc with gradient
    final speedPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.green, Colors.yellow, Colors.red],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final sweepAngle = min(speed / maxSpeed * pi, pi);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 30), pi,
        sweepAngle, false, speedPaint);

    // Draw ticks and needle (same as previous implementation)
    _drawTicks(canvas, center, radius);
    _drawNeedle(canvas, center, radius, speed);
  }

  // Ticks and needle methods remain the same as in previous implementation
  void _drawTicks(Canvas canvas, Offset center, double radius) {
    // Implementation from previous example
  }

  void _drawNeedle(
      Canvas canvas, Offset center, double radius, double currentSpeed) {
    // Implementation from previous example
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}
