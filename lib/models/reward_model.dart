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
  Map<String, int>? pointsEarned; // Changed to Map<String, int>
  int? pointsPerScan; // Added field
  String? rewardLogo;
  Timestamp? createdAt;
  List<String>? isFavourite; // Added field

  RewardModel({
    this.businessId,
    this.rewardId,
    this.noOfUsed,
    this.uses,
    this.rewardName,
    this.pointsPerScan, // Initialize the new field
    this.companyName,
    this.rewardAddress,
    this.pointsToRedeem,
    this.pointsEarned, // Changed field type
    this.rewardLogo,
    this.createdAt,
    this.isFavourite, // Initialize the new field
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
      pointsEarned: Map<String, int>.from(data[RewardKey.POINTSEARNED] ?? {}), // Changed to Map<String, int>
      rewardLogo: data[RewardKey.REWARDLOGO] ?? '',
      rewardAddress: data[RewardKey.REWARDADDRESS] ?? '',
      uses: data[RewardKey.USES] ?? 0,
      pointsPerScan: data[RewardKey.POINTSPERSCAN] ?? 0, // Added field
      createdAt: data[RewardKey.CREATEDAT] ?? Timestamp.now(),
      isFavourite: List<String>.from(data[RewardKey.ISFAVOURITE] ?? []), // Initialize the new field
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
      pointsEarned: Map<String, int>.from(map[RewardKey.POINTSEARNED] ?? {}), // Changed to Map<String, int>
      rewardLogo: map[RewardKey.REWARDLOGO] ?? '',
      pointsPerScan: map[RewardKey.POINTSPERSCAN] ?? 0, // Added field
      createdAt: map[RewardKey.CREATEDAT] ?? Timestamp.now(),
      isFavourite: List<String>.from(map[RewardKey.ISFAVOURITE] ?? []), // Initialize the new field
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
      RewardKey.POINTSEARNED: pointsEarned ?? {}, // Changed to Map<String, int>
      RewardKey.REWARDLOGO: rewardLogo ?? '',
      RewardKey.POINTSPERSCAN: pointsPerScan ?? 0, // Include the new field
      RewardKey.CREATEDAT: createdAt ?? Timestamp.now(),
      RewardKey.ISFAVOURITE: isFavourite ?? [], // Include the new field
    };
  }
}
