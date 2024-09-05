import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';

class RewardModel {
  String? businessId;
  String? rewardId;
  String? rewardName;
  int? noOfUsed;
  int? uses;
  String? companyName;
  String? rewardAddress;
  int? pointsToRedeem;
  int? pointsEarned; // New optional parameter
  String? rewardLogo;
  Timestamp? createdAt;

  RewardModel({
    this.businessId,
    this.rewardId,
    this.noOfUsed,
    this.uses,
    this.rewardName,
    this.companyName,
    this.rewardAddress,
    this.pointsToRedeem,
    this.pointsEarned, // Initialize the new parameter
    this.rewardLogo,
    this.createdAt,
  });

  factory RewardModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RewardModel(
      rewardId: snapshot.id,
      businessId: data[RewardKey.BUSINESSID] ?? '',
      rewardName: data[RewardKey.REWARDNAME] ?? '',
      noOfUsed: data[RewardKey.NOOFUSED] ?? 0,
      companyName: data[RewardKey.COMPANYNAME] ?? '',
      pointsToRedeem: data[RewardKey.POINTSTOREDEEM] ?? 0,
      pointsEarned:
          data[RewardKey.POINTSEARNED] ?? 0, // Set value for the new parameter
      rewardLogo: data[RewardKey.REWARDLOGO] ?? '',
      rewardAddress: data[RewardKey.REWARDADDRESS] ?? '',
      uses: data[RewardKey.USES] ?? 0,
      createdAt: data[RewardKey.CREATEDAT] ?? Timestamp.now(),
    );
  }

  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      rewardId: map[RewardKey.REWARDID] ?? '',
      businessId: map[RewardKey.BUSINESSID] ?? '',
      noOfUsed: map[RewardKey.NOOFUSED] ?? 0,
      rewardName: map[RewardKey.REWARDNAME] ?? '',
      rewardAddress: map[RewardKey.REWARDADDRESS] ?? '',
      companyName: map[RewardKey.COMPANYNAME] ?? '',
      uses: map[RewardKey.USES] ?? 0,
      pointsToRedeem: map[RewardKey.POINTSTOREDEEM] ?? 0,
      pointsEarned:
          map[RewardKey.POINTSEARNED] ?? 0, // Set value for the new parameter
      rewardLogo: map[RewardKey.REWARDLOGO] ?? '',
      createdAt: map[RewardKey.CREATEDAT] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      RewardKey.REWARDID: rewardId ?? '',
      RewardKey.BUSINESSID: businessId ?? '',
      RewardKey.NOOFUSED: noOfUsed ?? 0,
      RewardKey.USES: uses ?? 0,
      RewardKey.REWARDNAME: rewardName ?? '',
      RewardKey.REWARDADDRESS: rewardAddress ?? '',
      RewardKey.COMPANYNAME: companyName ?? '',
      RewardKey.POINTSTOREDEEM: pointsToRedeem ?? 0,
      RewardKey.POINTSEARNED: pointsEarned ?? 0, // Include the new parameter
      RewardKey.REWARDLOGO: rewardLogo ?? '',
      RewardKey.CREATEDAT: createdAt ?? Timestamp.now(),
    };
  }
}
