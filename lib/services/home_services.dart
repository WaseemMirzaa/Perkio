import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeServices{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;

  Future<bool> updateCollection(String collectionName, String docID, Map<String, dynamic> list) async {
    try {
      await _db.collection(collectionName).doc(docID).update(list);
      return true;
    } catch (e) {
      log("The error while updating is: $e");
      return false;
    }
  }

  Future<String?> uploadImageToFirebaseOnID(String image, String userId) async {
    try {
      final storageReference = _storage.ref().child('profile/$userId');
      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error is: $e");
      return null;
    }
  }

  Future<String?>  uploadImageToFirebaseWithCustomPath(String image, String path) async {
    try {
      final storageReference = _storage.ref().child(path);
      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error is: $e");
      return null;
    }
  }
}