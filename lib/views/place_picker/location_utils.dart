import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

class LocationUtils{
  static Future<Position> fetchLocation() async {
// bool serviceEnabled;
// LocationPermission permission;
//
// // Test if location services are enabled.
// serviceEnabled = await Geolocator.isLocationServiceEnabled();
// if (!serviceEnabled) {
//   return Future.error('Location services are disabled.');
// }
//
// permission = await Geolocator.checkPermission();
// if (permission == LocationPermission.denied) {
//   permission = await Geolocator.requestPermission();
//   if (permission == LocationPermission.denied) {
//     // your App should show an explanatory UI now.
//     return Future.error('Location permissions are denied');
//   }
// }
//
// if (permission == LocationPermission.deniedForever) {
//   showDialog(
//           context: getContext,
//           builder: (BuildContext context) => const PermissionDeniedDialog(),
//         );
//   return Future.error(
//       'Location permissions are permanently denied, we cannot request permissions.');
// }

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast("Enable location service.");
// return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();
    }
    return await Geolocator.getCurrentPosition();
  }

  


}