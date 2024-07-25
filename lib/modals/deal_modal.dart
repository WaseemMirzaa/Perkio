import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class DealModel{
  String? businessId;
  String? dealId;
  String? dealName;
  String? restaurantName;
  String? dealPrice;
  String? uses;
  String? location;

  DealModel({
    this.businessId,
    this.dealId,
    this.dealName,
    this.restaurantName,
    this.dealPrice,
    this.uses,
    this.location,
  });

  factory DealModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    // Use this factory method to convert Firebase DocumentSnapshot to Deal object
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DealModel(
      dealId: snapshot.id,
      businessId: data[DealKey.BUSINESSID] ?? '',
      dealName: data[DealKey.DEALNAME] ?? '',
      restaurantName: data[DealKey.RESTAURANTNAME] ?? '',
      dealPrice: data[DealKey.DEALPRICE] ?? '',
      uses: data[DealKey.USES] ?? '',
      location: data[DealKey.LOCATION] ?? '',
    );
  }

  factory DealModel.fromMap(Map<String, dynamic> map) {
    return DealModel(
      dealId: map[DealKey.DEALID],
      businessId: map[DealKey.BUSINESSID],
      dealName: map[DealKey.DEALNAME],
      restaurantName: map[DealKey.RESTAURANTNAME],
      dealPrice: map[DealKey.DEALPRICE],
      uses: map[DealKey.USES],
      location: map[DealKey.LOCATION],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DealKey.DEALID: dealId,
      DealKey.BUSINESSID: businessId,
      DealKey.DEALNAME: dealName,
      DealKey.RESTAURANTNAME: restaurantName,
      DealKey.DEALPRICE: dealPrice,
      DealKey.USES: uses,
      DealKey.LOCATION: location,
    };
  }
}