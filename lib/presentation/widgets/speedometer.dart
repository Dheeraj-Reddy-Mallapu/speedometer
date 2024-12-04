// Speedometer Widget
import 'package:flutter/material.dart';
import 'package:speedometer/presentation/widgets/speedometer_painter.dart';

class Speedometer extends StatelessWidget {
  final double speed;
  final double maxSpeed;

  const Speedometer({
    super.key,
    required this.speed,
    this.maxSpeed = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpeedometerPainter(speed: speed, maxSpeed: maxSpeed),
      child: SizedBox(
        width: 300,
        height: 300,
        child: Center(
          child: Stack(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: speed.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    const TextSpan(
                      text: 'km/h',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
