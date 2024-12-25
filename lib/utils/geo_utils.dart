import 'dart:math';

/// Calculates the Haversine distance between two geographic points
/// [lat1], [lon1]: Latitude and longitude of the first point.
/// [lat2], [lon2]: Latitude and longitude of the second point.
/// Returns the distance in kilometers.
double haversine(double lat1, double lon1, double lat2, double lon2) {
  const double radiusOfEarth = 6371; // Earth's radius in kilometers.

  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return radiusOfEarth * c;
}

/// Converts degrees to radians.
double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

/// Calculates the total distance traveled given a list of coordinates.
/// [coordinates]: List of latitude and longitude points.
/// Returns the total distance in kilometers.
double totalDistanceTraveled(List<List<double>> coordinates) {
  if (coordinates.length < 2) return 0.0;

  double totalDistance = 0.0;

  for (int i = 0; i < coordinates.length - 1; i++) {
    totalDistance += haversine(
      coordinates[i][0],
      coordinates[i][1],
      coordinates[i + 1][0],
      coordinates[i + 1][1],
    );
  }

  return totalDistance;
}
