import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/logic/speed_tracker_provider.dart';
import 'package:speedometer/presentation/widgets/speedometer.dart';

class SpeedometerPage extends ConsumerWidget {
  const SpeedometerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the speed from the provider
    final speedState = ref.watch(speedTrackerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Speedometer widget
            Speedometer(speed: speedState.speed),

            const SizedBox(height: 30),

            // Tracking controls
            FilledButton(
              onPressed: () {
                if (speedState.isTracking) {
                  ref.read(speedTrackerProvider.notifier).stopTracking();
                } else {
                  ref.read(speedTrackerProvider.notifier).startTracking();
                }
              },
              child: Text(
                  speedState.isTracking ? 'Stop Tracking' : 'Start Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}
