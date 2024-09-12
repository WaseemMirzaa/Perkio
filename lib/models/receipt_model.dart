import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String? receiptId; // Unique identifier for the receipt
  final String? businessId; // ID of the business associated with the receipt
  final String? rewardId; // ID of the reward associated with the receipt
  final String? userId; // ID of the user who uploaded the receipt
  late final List<String>? imageUrls; // List of URLs of the receipt images
  final DateTime? timestamp; // Date and time when the receipt was uploaded
  final String? additionalInfo; // Any additional info related to the receipt

  ReceiptModel({
    this.receiptId,
    this.businessId,
    this.rewardId,
    this.userId,
    this.imageUrls,
    this.timestamp,
    this.additionalInfo,
  });

  // Factory method to create a ReceiptModel from a map (e.g., from Firestore)
  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      receiptId: map['receiptId'] as String?,
      businessId: map['businessId'] as String?,
      rewardId: map['rewardId'] as String?,
      userId: map['userId'] as String?,
      imageUrls: List<String>.from(
          map['imageUrls'] ?? []), // Convert list of URLs from map
      timestamp: (map['timestamp'] as Timestamp?)
          ?.toDate(), // Convert Firestore Timestamp to DateTime
      additionalInfo: map['additionalInfo'] as String?,
    );
  }

  // Method to convert a ReceiptModel to a map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'receiptId': receiptId,
      'businessId': businessId,
      'rewardId': rewardId,
      'userId': userId,
      'imageUrls': imageUrls, // Store list of URLs
      'timestamp': timestamp,
      'additionalInfo': additionalInfo,
    };
  }
}
