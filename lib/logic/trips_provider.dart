import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speedometer/models/trip_model.dart';

part 'trips_provider.g.dart';

@riverpod
class Trips extends _$Trips {
  late Box<Trip> _box;
  StreamSubscription<BoxEvent>? _subscription;

  @override
  List<Trip> build() {
    _box = Hive.box<Trip>('trips');

    // Set up the subscription
    _subscription = _box.watch().listen((BoxEvent event) {
      // Update state whenever the box changes
      state = _box.values.toList();
    });

    // Clean up subscription when the provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return _box.values.toList();
  }

  Future<void> add(Trip trip) async => await _box.put(trip.id, trip);

  Future<void> remove(Trip trip) async => await _box.delete(trip.id);

  Future<void> update(Trip trip) async => await _box.put(trip.id, trip);
}
