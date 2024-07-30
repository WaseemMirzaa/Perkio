import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class UserModel {
  String? userId;
  String? userName;
  String? email;
  String? phoneNo;
  String? image;
  String? address;
  String? website;
  bool? isUser;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.phoneNo,
    this.image,
    this.address,
    this.website,
    this.isUser,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    // Use this factory method to convert Firebase DocumentSnapshot to UserProfile object
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snapshot.id,
      userName: data[UserKey.USERNAME] ?? '',
      email: data[UserKey.EMAIL] ?? '',
      phoneNo: data[UserKey.PHONENO] ?? '',
      image: data[UserKey.IMAGE] ?? '',
      address: data[UserKey.ADDRESS],
      website: data[UserKey.WEBSITE],
      isUser: data[UserKey.ISUSER],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map[UserKey.USERID],
      userName: map[UserKey.USERNAME],
      email: map[UserKey.EMAIL],
      phoneNo: map[UserKey.PHONENO],
      image: map[UserKey.IMAGE],
      address: map[UserKey.ADDRESS],
      website: map[UserKey.WEBSITE],
      isUser: map[UserKey.ISUSER]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserKey.USERID: userId,
      UserKey.USERNAME: userName,
      UserKey.EMAIL: email,
      UserKey.PHONENO: phoneNo,
      UserKey.IMAGE: image,
      UserKey.ADDRESS: address,
      UserKey.WEBSITE: website,
      UserKey.ISUSER: isUser,
    };
  }
}