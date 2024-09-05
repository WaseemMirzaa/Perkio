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
}
