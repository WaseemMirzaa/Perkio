import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/models/deal_model.dart';

class DealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch deals based on the businessId
  Future<List<DealModel>> fetchDeals(String businessId) async {
    try {
      print('Querying Firestore for deals with business ID: $businessId');
      QuerySnapshot snapshot = await _firestore
          .collection('deals')
          .where('businessId', isEqualTo: businessId)
          .get();

      print(
          'Firestore query successful. Documents found: ${snapshot.docs.length}');
      return snapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching deals: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchDealData(String dealId) async {
    try {
      DocumentReference dealRef = _firestore.collection('deals').doc(dealId);
      DocumentSnapshot dealSnapshot = await dealRef.get();
      return dealSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching deal data: $e');
      return {};
    }
  }

  Future<void> updateUsedBy(String dealId, String userId) async {
    try {
      DocumentReference dealRef = _firestore.collection('deals').doc(dealId);
      DocumentSnapshot dealSnapshot = await dealRef.get();

      if (dealSnapshot.exists) {
        Map<String, dynamic> dealData =
            dealSnapshot.data() as Map<String, dynamic>;

        Map<String, int> usedBy =
            Map<String, int>.from(dealData['usedBy'] ?? {});
        usedBy[userId] = (usedBy[userId] ?? 0) + 1;

        await dealRef.update({
          'usedBy': usedBy,
        });
      }
    } catch (e) {
      print('Error updating usedBy field: $e');
    }
  }

  Future<bool> canSwipe(String dealId, String userId) async {
    try {
      Map<String, dynamic> dealData = await fetchDealData(dealId);
      Map<String, int> usedBy = Map<String, int>.from(dealData['usedBy'] ?? {});
      int userCurrentUsage = usedBy[userId] ?? 0;
      int maxUses = dealData['uses'] ?? 0;
      return userCurrentUsage < maxUses;
    } catch (e) {
      print('Error checking swipe eligibility: $e');
      return false;
    }
  }
}
