import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

// Function to calculate the distance between two GeoPoints (Haversine formula)
double calculateDistancefordealandreward(GeoPoint start, GeoPoint end) {
  const double radiusOfEarth = 6371.0; // Radius of Earth in kilometers

  double lat1 = start.latitude * (pi / 180);
  double lon1 = start.longitude * (pi / 180);
  double lat2 = end.latitude * (pi / 180);
  double lon2 = end.longitude * (pi / 180);

  double dlat = lat2 - lat1;
  double dlon = lon2 - lon1;

  double a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = radiusOfEarth * c;

  return distance; // distance in kilometers
}