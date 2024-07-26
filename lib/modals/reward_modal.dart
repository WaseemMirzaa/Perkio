import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class RewardModel{
  String? businessId;
  String? rewardId;
  String? dealName;
  String? receiptPrice;
  String? rewardDetails;

  RewardModel({
    this.businessId,
    this.rewardId,
    this.dealName,
    this.receiptPrice,
    this.rewardDetails,
  });

  factory RewardModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    // Use this factory method to convert Firebase DocumentSnapshot to Deal object
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RewardModel(
      rewardId: snapshot.id,
      businessId: data[RewardKey.BUSINESSID] ?? '',
      dealName: data[RewardKey.DEALNAME],
      receiptPrice: data[RewardKey.RECEIPTPRICE] ?? '',
      rewardDetails: data[RewardKey.REWARDDETAILS] ?? '',
    );
  }

  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      rewardId: map[RewardKey.REWARDID],
      businessId: map[RewardKey.BUSINESSID],
      dealName: map[RewardKey.DEALNAME],
      receiptPrice: map[RewardKey.RECEIPTPRICE],
      rewardDetails: map[RewardKey.REWARDDETAILS],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      RewardKey.REWARDID: rewardId,
      RewardKey.BUSINESSID: businessId,
      RewardKey.DEALNAME: dealName,
      RewardKey.RECEIPTPRICE: receiptPrice,
      RewardKey.REWARDDETAILS: rewardDetails,
    };
  }
}