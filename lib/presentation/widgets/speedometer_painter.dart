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

    // _drawTicks(canvas, center, radius);
    // _drawNeedle(canvas, center, radius, speed);
  }

  // void _drawTicks(Canvas canvas, Offset center, double radius) {
  //   final tickPaint = Paint()
  //     ..color = Colors.black
  //     ..strokeWidth = 2
  //     ..style = PaintingStyle.stroke;

  //   // Total number of ticks
  //   const totalTicks = 15;

  //   // Tick length and position
  //   // final tickLength = radius * 0.1;
  //   final tickStartRadius = radius - 50;
  //   final tickEndRadius = radius - 30;

  //   for (int i = 0; i <= totalTicks; i++) {
  //     // Calculate the angle for each tick
  //     final angle = pi + (i / totalTicks) * pi;

  //     // Calculate start and end points of the tick
  //     final startX = center.dx + tickStartRadius * cos(angle);
  //     final startY = center.dy + tickStartRadius * sin(angle);

  //     final endX = center.dx + tickEndRadius * cos(angle);
  //     final endY = center.dy + tickEndRadius * sin(angle);

  //     // Draw major ticks at certain intervals
  //     if (i % 3 == 0) {
  //       tickPaint.strokeWidth = 4;
  //       canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
  //     } else {
  //       // Minor ticks
  //       tickPaint.strokeWidth = 2;
  //       canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
  //     }
  //   }
  // }

  // void _drawNeedle(
  //     Canvas canvas, Offset center, double radius, double currentSpeed) {
  //   // Needle paint
  //   final needlePaint = Paint()
  //     ..color = Colors.red
  //     ..strokeWidth = 4
  //     ..style = PaintingStyle.stroke;

  //   // Calculate needle angle based on current speed
  //   final speedRatio = min(currentSpeed / maxSpeed, 1.0);
  //   final needleAngle = pi + speedRatio * pi;

  //   // Needle length slightly shorter than the radius
  //   final needleLength = radius - 40;

  //   // Calculate needle end point
  //   final needleEndX = center.dx + needleLength * cos(needleAngle);
  //   final needleEndY = center.dy + needleLength * sin(needleAngle);

  //   // Draw the needle
  //   canvas.drawLine(center, Offset(needleEndX, needleEndY), needlePaint);

  //   // Draw needle base (a small circle at the center)
  //   final basePaint = Paint()
  //     ..color = Colors.black
  //     ..style = PaintingStyle.fill;

  //   canvas.drawCircle(center, 8, basePaint);
  // }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.speed != speed;
  }
}
