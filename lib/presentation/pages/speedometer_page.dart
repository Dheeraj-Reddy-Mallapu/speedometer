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

    var children = [
      // Speedometer widget
      Speedometer(speed: speedState.speed),

      const SizedBox(height: 30, width: 100),

      // Tracking controls
      FilledButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.secondary)),
        onPressed: () {
          if (speedState.isTracking) {
            ref.read(speedTrackerProvider.notifier).stopTracking();
          } else {
            ref.read(speedTrackerProvider.notifier).startTracking();
          }
        },
        child: Text(speedState.isTracking ? 'Stop Tracking' : 'Start Tracking'),
      ),
    ];

    Widget buildPortraitLayout(List<Widget> children) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    Widget buildLandscapeLayout(List<Widget> children) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    return Scaffold(
      appBar: speedState.isTracking
          ? AppBar()
          : AppBar(
              title: const Text('Speedometer'),
              actions: [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/trip_history'),
                  tooltip: 'Trip History',
                  icon: const Icon(Icons.timeline_sharp),
                ),
              ],
            ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortraitLayout(children)
              : buildLandscapeLayout(children),
        ),
      ),
    );
  }
}
