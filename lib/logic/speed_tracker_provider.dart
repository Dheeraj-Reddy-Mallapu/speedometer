import 'dart:async';

import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'speed_tracker_provider.g.dart';

@riverpod
class SpeedTracker extends _$SpeedTracker {
  StreamSubscription? _speedSubscription;
  Location location = Location();

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
    state = SpeedState(
      speed: speedInKmh.abs(),
      isTracking: true,
    );
  }

  Future<void> stopTracking() async {
    await _speedSubscription?.cancel();
    _speedSubscription = null;
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
}

class SpeedState {
  final double speed;
  final bool isTracking;

  SpeedState({
    required this.speed,
    required this.isTracking,
  });
}
