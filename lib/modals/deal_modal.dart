import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class DealModel {
  String? businessId;
  String? dealId;
  String? dealName;
  String? restaurantName;
  String? image;
  String? uses;
  String? location;
  List<String>? favourites;

  DealModel({
    this.businessId,
    this.dealId,
    this.dealName,
    this.restaurantName,
    this.image,
    this.uses,
    this.location,
    this.favourites,
  });

  factory DealModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    // Use this factory method to convert Firebase DocumentSnapshot to Deal object
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DealModel(
      dealId: snapshot.id,
      businessId: data[DealKey.BUSINESSID] ?? '',
      dealName: data[DealKey.DEALNAME] ?? '',
      restaurantName: data[DealKey.RESTAURANTNAME] ?? '',
      image: data[DealKey.IMAGE] ?? '',
      uses: data[DealKey.USES] ?? '',
      location: data[DealKey.LOCATION] ?? '',
      favourites: data[DealKey.FAVOURITES] != null 
          ? List<String>.from(data[DealKey.FAVOURITES])
          : [],
    );
  }

  factory DealModel.fromMap(Map<String, dynamic> map) {
    return DealModel(
      dealId: map[DealKey.DEALID],
      businessId: map[DealKey.BUSINESSID],
      dealName: map[DealKey.DEALNAME],
      restaurantName: map[DealKey.RESTAURANTNAME],
      image: map[DealKey.IMAGE],
      uses: map[DealKey.USES],
      location: map[DealKey.LOCATION],
      favourites: map[DealKey.FAVOURITES] != null 
          ? List<String>.from(map[DealKey.FAVOURITES])
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DealKey.DEALID: dealId,
      DealKey.BUSINESSID: businessId,
      DealKey.DEALNAME: dealName,
      DealKey.RESTAURANTNAME: restaurantName,
      DealKey.IMAGE: image,
      DealKey.USES: uses,
      DealKey.LOCATION: location,
      DealKey.FAVOURITES: favourites,
    };
  }
}
