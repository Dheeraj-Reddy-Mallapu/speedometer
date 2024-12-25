import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedometer/logic/trips_provider.dart';
import 'package:speedometer/presentation/widgets/trip_card.dart';

class TripHistoryPage extends ConsumerStatefulWidget {
  const TripHistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TripHistoryPageState();
}

class _TripHistoryPageState extends ConsumerState<TripHistoryPage> {
  final _prefsBox = Hive.box('preferences');

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final trips = ref.watch(tripsProvider);

    const trackingEnabledKey = 'trackingEnabled';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        actions: [
          Tooltip(
            message: 'Enable/Disable trips tracking',
            child: Switch(
              activeColor: color.secondary,
              value: _prefsBox.get(trackingEnabledKey, defaultValue: true),
              onChanged: (value) async {
                await _prefsBox.put(trackingEnabledKey, value);
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: trips.isNotEmpty
          ? ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips.elementAt(index);

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Dismissible(
                      key: ValueKey(trip.id),
                      direction: DismissDirection.horizontal,
                      background:
                          _dismissBackground(color, Alignment.centerLeft),
                      secondaryBackground:
                          _dismissBackground(color, Alignment.centerRight),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this trip?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(color.error)),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: color.surface),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        await ref.read(tripsProvider.notifier).remove(trip);
                      },
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18.0),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            child: Column(
                              children: [
                                if (kDebugMode)
                                  ...List.generate(
                                    trip.values.length,
                                    (index) => Card(
                                      elevation: 0,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 8.0),
                                      child: ListTile(
                                        title: Text(
                                          'Speed: ${trip.values[index].speed.toStringAsFixed(2)} km/h',
                                        ),
                                        subtitle: Text(
                                          'Accuracy: ${trip.values[index].speedAccuracy.toStringAsFixed(2)} m',
                                        ),
                                        trailing: Text(
                                          '${trip.values[index].timeStamp.hour}:${trip.values[index].timeStamp.minute}:${trip.values[index].timeStamp.second}',
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        child: TripCard(trip: trip),
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No trips recorded yet'),
            ),
    );
  }
}

_dismissBackground(ColorScheme color, Alignment alignment) => Stack(
      children: [
        Container(
          color: color.error,
          alignment: Alignment.center,
          child: Text(
            'Delete trip',
            style: TextStyle(color: color.surface),
          ),
        ),
        Container(
          color: color.error.withOpacity(0.5),
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: color.surface),
        ),
      ],
    );
