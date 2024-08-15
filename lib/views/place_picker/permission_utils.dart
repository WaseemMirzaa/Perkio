
import 'package:geolocator/geolocator.dart';

class PermissionUtils{
  static Future<bool> checkStatus()async{
    return await Geolocator.isLocationServiceEnabled();
  }
}