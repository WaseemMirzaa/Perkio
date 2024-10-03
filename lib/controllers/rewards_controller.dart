import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/models/receipt_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';

class RewardController extends GetxController {
  final RewardService _rewardService = RewardService();
  var rewardModel = Rx<RewardModel?>(null); // Holds the specific reward data

  var rewards = <RewardModel>[].obs;
  var searchedRewards = <RewardModel>[].obs; // List to hold searched results
  var isLoading = true.obs;
  var isSearching = false.obs; // Observable for search status
  var currentUserId = ''.obs; // Observable variable for the current user UID
  final ImagePicker _picker = ImagePicker();
  var isLoadingforscan = false.obs; // Observable to track loading state
  var progress = 0.0.obs; // Observable to track progress

  @override
  void onInit() {
    super.onInit();
    currentUserId.value =
        getCurrentUserId(); // Initialize with the current user UID
    listenToRewards();
  }

  String getCurrentUserId() {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is signed in, return UID if signed in, otherwise return an empty string or handle the case
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case where the user is not signed in
      log('No user is currently signed in.');
      return '';
    }
  }

  // Method to listen to a specific reward by rewardId
  void listenToReward(String rewardId) {
    isLoading(true);
    _rewardService.getRewardByIdStream(rewardId).listen((data) {
      rewardModel.value = data;
      isLoading(false);
    }).onError((error) {
      log('Failed to listen to reward: $error');
      isLoading(false);
    });
  }

  void listenToRewards() {
    _rewardService.getRewardStream().listen((data) {
      rewards.value = data;
      isLoading(false);
    }).onError((error) {
      log('Failed to listen to rewards: $error');
    });
  }

  // Search method to filter rewards based on search input
  void searchRewards(String query) {
    if (query.isEmpty) {
      searchedRewards.assignAll(rewards); // If query is empty, show all rewards
    } else {
      String lowerCaseQuery = query.toLowerCase();
      var filteredRewards = rewards.where((reward) {
        var rewardName = reward.rewardName?.toLowerCase() ?? '';
        var companyName = reward.companyName?.toLowerCase() ?? '';
        return rewardName.contains(lowerCaseQuery) ||
            companyName.contains(lowerCaseQuery);
      }).toList();
      searchedRewards.assignAll(filteredRewards); // Update searched rewards
    }
  }

  Future<void> toggleLike(RewardModel reward, String userId) async {
    bool isLiked = reward.isFavourite?.contains(userId) ?? false;
    await _rewardService.toggleLike(reward.rewardId!, userId, !isLiked);
    // Update the local state if needed
    listenToRewards(); // This will refresh the reward list
  }

  // Method to update the usedBy and pointsEarned fields in the reward collection
  // Future<void> updateRewardUsage(String rewardId, String userId) async {
  //   try {
  //     log(userId);

  //     final firestore = FirebaseFirestore.instance;
  //     final rewardDoc = firestore.collection('reward').doc(rewardId);
  //     final receiptsCollection = rewardDoc.collection('receipts');

  //     await firestore.runTransaction((transaction) async {
  //       final rewardSnapshot = await transaction.get(rewardDoc);

  //       if (!rewardSnapshot.exists) {
  //         throw Exception("Reward does not exist");
  //       }

  //       // Get current usedBy and pointsEarned data
  //       Map<String, dynamic> usedBy =
  //           rewardSnapshot.get('usedBy') as Map<String, dynamic>? ?? {};
  //       Map<String, dynamic> pointsEarned =
  //           rewardSnapshot.get('pointsEarned') as Map<String, dynamic>? ?? {};

  //       // Update the usage count for the user
  //       int currentUses = usedBy[userId] ?? 0;
  //       usedBy[userId] = currentUses + 1;

  //       // If the user exists in pointsEarned, set their points to 0
  //       if (pointsEarned.containsKey(userId)) {
  //         pointsEarned[userId] = 0;
  //       }

  //       // Update the document with the new usedBy and pointsEarned maps
  //       transaction.update(rewardDoc, {
  //         'usedBy': usedBy,
  //         'pointsEarned': pointsEarned,
  //       });

  //       // Query the receipts subcollection for the matching userId
  //       final querySnapshot = await receiptsCollection.get();

  //       // Ensure we're working with a QuerySnapshot
  //       for (final doc in querySnapshot.docs) {
  //         if (doc.id == userId) {
  //           // Delete the matching document
  //           transaction.delete(doc.reference);
  //           break; // Assuming there should be only one matching document
  //         }
  //       }
  //     });

  //     // Delete images from Firebase Storage after the transaction is committed
  //     final storage = FirebaseStorage.instance;
  //     final userImagesRef = storage.ref().child('receipts/$rewardId/$userId');
  //     final listResult = await userImagesRef.listAll();

  //     // Delete all files in the folder
  //     for (final fileRef in listResult.items) {
  //       await fileRef.delete();
  //     }

  //     // Optionally, delete the folder itself (if it has no other files or folders)
  //     if (listResult.items.isEmpty && listResult.prefixes.isEmpty) {
  //       await userImagesRef.delete();
  //     }
  //   } catch (e) {
  //     log('Error updating reward usage and points: $e');
  //   }
  // }

  Future<void> updateRewardUsage(String rewardId, String userId) async {
    try {
      log(userId);

      final firestore = FirebaseFirestore.instance;
      final rewardDoc = firestore.collection('reward').doc(rewardId);

      await firestore.runTransaction((transaction) async {
        final rewardSnapshot = await transaction.get(rewardDoc);

        if (!rewardSnapshot.exists) {
          throw Exception("Reward does not exist");
        }

        // Get current usedBy and pointsEarned data
        Map<String, dynamic> usedBy =
            rewardSnapshot.get('usedBy') as Map<String, dynamic>? ?? {};
        Map<String, dynamic> pointsEarned =
            rewardSnapshot.get('pointsEarned') as Map<String, dynamic>? ?? {};

        // Update the usage count for the user
        int currentUses = usedBy[userId] ?? 0;
        usedBy[userId] = currentUses + 1;

        // If the user exists in pointsEarned, set their points to 0
        if (pointsEarned.containsKey(userId)) {
          pointsEarned[userId] = 0;
        }

        // Update the document with the new usedBy and pointsEarned maps
        transaction.update(rewardDoc, {
          'usedBy': usedBy,
          'pointsEarned': pointsEarned,
        });
      });
    } catch (e) {
      log('Error updating reward usage and points: $e');
    }
  }

  //cleaning scan screen

  Future<void> pickImageAndUpload(
      RewardModel rewardModel, String userId) async {
    isLoadingforscan.value = true; // Start loading

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        final file = File(image.path);

        // Get the UploadTask and track progress
        final uploadTask =
            await _rewardService.uploadReceiptImage(file, rewardModel, userId);

        // Listen to snapshot events for progress tracking
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          if (taskSnapshot.state == TaskState.running) {
            progress.value = (taskSnapshot.bytesTransferred.toDouble() /
                taskSnapshot.totalBytes.toDouble());
          }
        });

        // Complete the upload and get the download URL
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the receipt and add points
        await _rewardService.saveReceipt(rewardModel, userId, downloadUrl);
        await _rewardService.addPointsToReward(
            rewardModel.rewardId!, userId, 20);

        // Navigate to the reward detail screen
        Get.offAll(() => RewardRedeemDetail(
              rewardId: rewardModel.rewardId,
              businessId: rewardModel.businessId,
              userId: userId,
            ));
      } catch (e) {
        print("Error uploading image: $e");
      } finally {
        isLoadingforscan.value = false; // Stop loading
        progress.value = 0.0; // Reset progress
      }
    } else {
      isLoadingforscan.value = false; // Stop loading if no image was selected
      progress.value = 0.0; // Reset progress
    }
  }

  var userReceipts = <ReceiptModel>[].obs; // Observable list of ReceiptModels

  late List<ReceiptModel> receipts;

// Method to fetch receipts
  Future<void> fetchReceipts(String rewardId) async {
    try {
      // Fetch receipts for the current user based on rewardId
      receipts = await _rewardService.fetchUserReceipts(rewardId);

      // Log the fetched receipts
      for (var receipt in receipts) {
        // Ensure imageUrls is not null before logging
        final imageUrls = receipt.imageUrls ?? [];
        print("Fetched Receipt: ${receipt.receiptId}, "
            "Business ID: ${receipt.businessId}, "
            "Reward ID: ${receipt.rewardId}, "
            "User ID: ${receipt.userId}, "
            "Image URLs: ${imageUrls.join(", ")}, "
            "Timestamp: ${receipt.timestamp}, "
            "Additional Info: ${receipt.additionalInfo}");
      }

      // Update the observable list with the fetched receipts
      userReceipts.assignAll(receipts);
    } catch (e) {
      print("Error fetching receipts in controller: $e");
      // Optional: Handle error (e.g., show a message to the user)
    }
  }

  //update user recepit status
  Future<void> updateReceiptStatus(String rewardId) async {
    try {
      await _rewardService.updateReceiptStatus(rewardId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
