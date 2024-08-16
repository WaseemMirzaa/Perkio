class AddressModel {

  /// The name associated with the placemark.
  String? name;

  /// The street associated with the placemark.
  String? street;

  /// The abbreviated country name, according to the two letter (alpha-2) https://www.iso.org/iso-3166-country-codes.html.
  String? isoCountryCode;

  /// The name of the country associated with the placemark.
  String? country;

  /// The postal code associated with the placemark.
  String? postalCode;

  /// The name of the state or province associated with the placemark.
  String? administrativeArea;

  /// Additional administrative area information for the placemark.
  String? subAdministrativeArea;

  /// The name of the city associated with the placemark.

  String? locality;
  String? completeAddress;

  /// Additional city-level information for the placemark.
  String? subLocality;

  /// The street address associated with the placemark.
  String? thoroughfare;

  /// Additional street address information for the placemark.
  String? subThoroughfare;

  /// Latitude of address
  double? latitude;
  // /// Longitude of address
  double? longitude;

  AddressModel(
      {this.name,
        this.street,
        this.isoCountryCode,
        this.country,
        this.postalCode,
        this.completeAddress,
        this.administrativeArea,
        this.subAdministrativeArea,
        this.locality,
        this.subLocality,
        this.thoroughfare,
        this.subThoroughfare,
        this.latitude,
        this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'isoCountryCode': isoCountryCode,
      'country': country,
      'postalCode': postalCode,
      'administrativeArea': administrativeArea,
      'subAdministrativeArea': subAdministrativeArea,
      'locality': locality,
      'subLocality': subLocality,
      'thoroughfare': thoroughfare,
      'subThoroughfare': subThoroughfare,
      'latitude': latitude,
      'longitude': longitude,
      'completeAddress': completeAddress
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
        name: map['name'] as String ?? '',
        completeAddress: map['completeAddress'] as String ?? '',
        street: map['street'] as String ?? '',
        isoCountryCode: map['isoCountryCode'] as String ?? "",
        country: map['country'] as String ?? '',
        postalCode: map['postalCode'] as String ?? '',
        administrativeArea: map['administrativeArea'] as String ?? '',
        subAdministrativeArea: map['subAdministrativeArea'] as String ?? '',
        locality: map['locality'] as String ?? '',
        subLocality: map['subLocality'] ?? "",
        thoroughfare: map['thoroughfare'] ?? "",
        subThoroughfare: map['subThoroughfare'] ?? "",
        latitude: map['latitude'],
        longitude: map['longitude'] );
  }
  factory AddressModel.fromLatLng(double lat, double lon) {
    return AddressModel(
      latitude: lat,
      longitude: lon,
    );
  }
}
