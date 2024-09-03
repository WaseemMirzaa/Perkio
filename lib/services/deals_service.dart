import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/models/deal_model.dart';

class DealsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchPromotions() async {
    QuerySnapshot snapshot = await _firestore
        .collection('deals')
        .where('isPromotionStart', isEqualTo: true)
        .get();
    return snapshot.docs;
  }

  Future<List<DealModel>> fetchDeals() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('deals').get();
      return querySnapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching deals: $e');
    }
  }

  Future<GeoPoint> getUserLocation(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['latLong'] as GeoPoint;
    } catch (e) {
      throw Exception('Error fetching user location: $e');
    }
  }
}
