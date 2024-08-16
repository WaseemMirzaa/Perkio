import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skhickens_app/views/place_picker/address_model.dart';

class CurrentLocationModel{
  LatLng? latLon;
  AddressModel? address;

  CurrentLocationModel({this.latLon, this.address});

}