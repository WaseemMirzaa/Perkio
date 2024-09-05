import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/models/reward_model.dart';

class RewardService {
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection('reward');

  Stream<List<RewardModel>> getRewardStream() {
    return _rewardCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => RewardModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<List<RewardModel>> fetchRewards(String businessId) async {
    try {
      QuerySnapshot snapshot = await _rewardCollection
          .where('businessId', isEqualTo: businessId) // Filter by businessId
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Map all document snapshots to RewardModel
        List<RewardModel> rewards = snapshot.docs
            .map((doc) => RewardModel.fromDocumentSnapshot(doc))
            .toList();
        return rewards;
      } else {
        log('No rewards found for businessId: $businessId');
        return [];
      }
    } catch (e) {
      log('Error fetching rewards: $e');
      return [];
    }
  }
}
