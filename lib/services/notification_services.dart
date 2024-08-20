import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/modals/notification_model.dart';

class NotificationServices{
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Stream<List<NotificationModel>> getNotifications(){
    return db.collection(CollectionsKey.NOTIFICATIONS).snapshots().map((snapshot){
      return snapshot.docs.map((doc)=>NotificationModel.fromDocumentSnapshot(doc)).toList();
    });
  }
}