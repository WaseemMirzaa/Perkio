import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/views/place_picker/dio.dart';
import 'package:swipe_app/views/place_picker/key.dart';
import 'package:swipe_app/views/place_picker/suggestion.dart';
import 'package:uuid/uuid.dart';

class Apis {
  static String apiKey = Platform.isAndroid ? MAP_API_KEY : MAP_API_KEY;
  static Future<CameraPosition> getPlaceDetailFromId(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey";
    ApiResponse response = await DioHelper.get(url);
    if (response.body != null) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components = result['result']['geometry'] as Map<String, dynamic>;
        CameraPosition cameraPosition = CameraPosition(
            zoom: 14,
            target: LatLng(
                components["location"]["lat"], components["location"]["lng"]));
        return cameraPosition;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception(DioHelper.apiErrorResponse);
    }
  }

  static Future<List<Suggestion>> fetchSuggestions(
      {required String input, required String lang}) async {
    final sessionToken = const Uuid().v4();
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&key=$apiKey&sessiontoken=$sessionToken';
    ApiResponse response = await DioHelper.get(url);
    if (response.body != null) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        toast("No result found!");
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception(DioHelper.apiErrorResponse);
    }
  }

  // New method to get coordinates from city name
  static Future<LatLng?> getCoordinatesFromCity(String cityName) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$apiKey';
    ApiResponse response = await DioHelper.get(url);
    if (response.body != null) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final location = result['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception(DioHelper.apiErrorResponse);
    }
  }
}
