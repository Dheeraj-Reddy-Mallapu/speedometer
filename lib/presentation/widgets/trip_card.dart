import 'package:flutter/material.dart';
import 'package:speedometer/models/trip_model.dart';
import 'package:speedometer/utils/geo_utils.dart';

class TripCard extends StatelessWidget {
  final Trip trip;

  const TripCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final totalTimeElapsed = trip.endTime.isAtSameMomentAs(trip.startTime)
        ? trip.values.last.timeStamp.difference(trip.startTime)
        : trip.endTime.difference(trip.startTime);
    final totalDistance = totalDistanceTraveled(
        trip.values.map((e) => [e.latitude, e.longitude]).toList());
    final averageSpeed =
        (totalDistance / totalTimeElapsed.inSeconds) * 3600; // km/h

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              trip.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${trip.startTime.hour}:${trip.startTime.minute}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatRow(
                  context,
                  icon: Icons.timelapse,
                  text: _formatDuration(totalTimeElapsed),
                  tooltip: 'Total time elapsed',
                ),
                _buildStatRow(
                  context,
                  icon: Icons.location_on,
                  text: '${totalDistance.toStringAsFixed(2)} km',
                  tooltip: 'Total distance covered',
                ),
                _buildStatRow(
                  context,
                  icon: Icons.speed,
                  text: '${averageSpeed.toStringAsFixed(2)} km/h',
                  tooltip: 'Average speed',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context,
      {required IconData icon, required String text, String? tooltip}) {
    return Tooltip(
      message: tooltip,
      child: Row(
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            margin: const EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    // Build the formatted string, including only non-zero units
    String result = '';
    if (hours > 0) result += '${hours}h ';
    if (minutes > 0 || hours > 0) result += '${minutes}m ';
    result += '${seconds}s';

    return result;
  }
}
