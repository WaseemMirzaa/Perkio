import 'dart:math'; // Import to use math functions

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadiusKm = 6371; // Radius of Earth in kilometers
  const double kmToMiles =
      0.621371; // Conversion factor from kilometers to miles

  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distanceKm = earthRadiusKm * c; // Distance in kilometers
  return distanceKm * kmToMiles; // Convert to miles
}

double _toRadians(double degrees) {
  return degrees * pi / 180;
}
