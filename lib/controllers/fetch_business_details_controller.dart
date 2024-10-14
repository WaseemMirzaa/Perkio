import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipe_app/models/business_details_model.dart';

class BusinessRatingController {


  Future<BusniessDetailsModel?> fetchBusinessDetails(String businessDetailsId) async {
    try {
      // Step 1: Get user document where the user ID matches the current user ID
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: businessDetailsId)
          .limit(1)
          .get();

      // Step 2: Check if the user exists
      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        // Step 3: Go to the subcollection 'business_details' and fetch the first document
        QuerySnapshot businessSnapshot = await userDoc.reference
            .collection('business_details')
            .limit(1)
            .get();

        if (businessSnapshot.docs.isNotEmpty) {
          // Fetch the first document in 'business_details'
          DocumentSnapshot businessDoc = businessSnapshot.docs.first;

          // Convert the fetched data to a model
          return BusniessDetailsModel.fromMap(
            businessDoc.data() as Map<String, dynamic>,
          );
        } else {
          print("No business details found");
        }
      } else {
        print("No user found with the current user ID");
      }
    } catch (e) {
      print("Error fetching business details: $e");
    }
    return null;
  }
}
