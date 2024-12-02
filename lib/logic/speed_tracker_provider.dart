import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'speed_tracker_provider.g.dart';

@riverpod
class SpeedTracker extends _$SpeedTracker {
  StreamSubscription? _speedSubscription;

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

    // Start continuous position stream
    _speedSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best, distanceFilter: 1),
    ).listen(
      _updateSpeed,
      onError: (error) {
        // print('Position stream error: $error');
        stopTracking();
      },
      cancelOnError: false,
    );
  }

  void _updateSpeed(Position position) {
    // print('update');
    // Convert speed from m/s to km/h
    final speedInKmh = (position.speed * 3.6).abs();
    state = SpeedState(speed: speedInKmh, isTracking: true);
  }

  Future<void> stopTracking() async {
    await _speedSubscription?.cancel();
    _speedSubscription = null;

    state = SpeedState(speed: 0.0, isTracking: false);
  }

  // Permission handling method
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // print('Location services are disabled');
      return serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // print('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // print('Location permissions are permanently denied');
      return false;
    }

    return true;
  }
}

class SpeedState {
  final double speed;
  final bool isTracking;

  SpeedState({required this.speed, required this.isTracking});
}
