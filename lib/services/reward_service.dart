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
}
