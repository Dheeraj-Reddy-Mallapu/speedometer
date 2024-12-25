import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speedometer/logic/trips_provider.dart';
import 'package:speedometer/models/trip_model.dart';
import 'package:uuid/uuid.dart';

part 'speed_tracker_provider.g.dart';

@riverpod
class SpeedTracker extends _$SpeedTracker {
  final _prefsBox = Hive.box('preferences');
  final trackingEnabledKey = 'trackingEnabled';
  StreamSubscription? _speedSubscription;
  Location location = Location();
  Trip? currentTrip; // Current Trip instance
  Uuid uuid = const Uuid();
  DateTime? lastWriteTime;

  @override
  SpeedState build() {
    return SpeedState(speed: 0.0, isTracking: false);
  }

  Future<void> startTracking() async {
    // Check and request location permissions
    final permission = await _checkLocationPermission();
    if (!permission) {
      state = SpeedState(speed: 0.0, isTracking: false);
      return;
    }

    // Stop any existing subscription
    await stopTracking();

    // Create a new trip
    var trackingEnabled = _prefsBox.get(trackingEnabledKey, defaultValue: true);
    if (trackingEnabled) {
      currentTrip = Trip(
        id: uuid.v4(), // Generate a unique ID
        name: _generateTripName(), // Assign a default name
        startTime: DateTime.now(),
        endTime: DateTime.now(), // Temporarily the same as startTime
        values: [],
      );

      await ref.read(tripsProvider.notifier).add(currentTrip!);
    }

    // Update state to tracking
    state = SpeedState(speed: 0.0, isTracking: true);

    await location.changeSettings(distanceFilter: 1);

    // Start continuous position stream
    _speedSubscription = location.onLocationChanged.listen(
      _updateSpeed,
      onError: (error) {
        stopTracking();
      },
      cancelOnError: false,
    );
  }

  void _updateSpeed(LocationData locationData) {
    // Convert speed from m/s to km/h
    final speedInKmh = (locationData.speed ?? 0) * 3.6;
    var trackingEnabled = _prefsBox.get(trackingEnabledKey, defaultValue: true);

    // Add a new data point to the current trip
    if (currentTrip != null &&
        trackingEnabled &&
        ((locationData.speedAccuracy ?? 0.0) < 1)) {
      final dataPoint = TripDataPoint(
        speed: speedInKmh.abs(),
        speedAccuracy: locationData.speedAccuracy ?? 0.0,
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
        timeStamp: DateTime.now(),
      );

      currentTrip = currentTrip!.addDataPoint(dataPoint);
      final now = DateTime.now();
      if (lastWriteTime == null ||
          now.difference(lastWriteTime!) >= const Duration(seconds: 5)) {
        lastWriteTime = now;
        ref.read(tripsProvider.notifier).update(currentTrip!);
      }
    }

    // Update state
    state = SpeedState(
      speed: speedInKmh.abs(),
      isTracking: true,
    );
  }

  Future<void> stopTracking() async {
    await _speedSubscription?.cancel();
    _speedSubscription = null;

    if (currentTrip != null) {
      if (currentTrip!.values.isNotEmpty) {
        // Finalize the trip by setting the end time
        currentTrip = currentTrip!.copyWith(endTime: DateTime.now());
        await ref.read(tripsProvider.notifier).update(currentTrip!);
      } else {
        await ref.read(tripsProvider.notifier).remove(currentTrip!);
      }
      currentTrip = null;
    }

    state = SpeedState(speed: 0.0, isTracking: false);
  }

  // Permission handling method
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  String _generateTripName() {
    final now = DateTime.now();

    // Filter trips by today's date
    final todaysTrips = ref.read(tripsProvider).where((trip) {
      return trip.startTime.day == now.day &&
          trip.startTime.month == now.month &&
          trip.startTime.year == now.year;
    }).toList();

    // Determine serial number
    final serialNumber = (todaysTrips.length + 1).toString().padLeft(2, '0');

    // Generate trip name
    return "Trip_$serialNumber";
  }
}

class SpeedState {
  final double speed;
  final bool isTracking;

  SpeedState({
    required this.speed,
    required this.isTracking,
  });
}
