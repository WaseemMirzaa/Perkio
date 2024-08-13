import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';

class UserModel {
  String? userId;
  String? userName;
  String? email;
  String? phoneNo;
  String? image;
  String? logo;
  String? address;
  String? website;
  String? role;
  String? businessId;
  String? stripeCustomerId;
  String? password;
  int? balance;
  bool? isPromotionStart;
  String? isVerified;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.phoneNo,
    this.image,
    this.address,
    this.website,
    this.logo,
    this.role,
    this.businessId,
    this.password,
    this.balance,
    this.isPromotionStart,
    this.isVerified,
    this.stripeCustomerId
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snapshot.id,
      userName: data[UserKey.USERNAME] ?? '',
      email: data[UserKey.EMAIL] ?? '',
      phoneNo: data[UserKey.PHONENO] ?? '',
      image: data[UserKey.IMAGE] ?? '',
      logo: data[UserKey.LOGO] ?? '',
      address: data[UserKey.ADDRESS],
      website: data[UserKey.WEBSITE],
      role: data[UserKey.ROLE],
      businessId: data[UserKey.BUSINESSID],
      balance: data[UserKey.BALANCE] ?? 0,
      isPromotionStart: data[UserKey.ISPROMOTIONSTART] ?? false,
      isVerified: data[UserKey.ISVERIFIED] ?? StatusKey.pending,
      stripeCustomerId: data[UserKey.STRIPECUSTOMERID] ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map[UserKey.USERID],
      userName: map[UserKey.USERNAME],
      email: map[UserKey.EMAIL],
      phoneNo: map[UserKey.PHONENO],
      image: map[UserKey.IMAGE],
      logo: map[UserKey.LOGO],
      address: map[UserKey.ADDRESS],
      website: map[UserKey.WEBSITE],
      role: map[UserKey.ROLE],
      businessId: map[UserKey.BUSINESSID],
      balance: map[UserKey.BALANCE] ?? 0,
      isPromotionStart: map[UserKey.ISPROMOTIONSTART] ?? false,
      isVerified: map[UserKey.ISVERIFIED] ?? StatusKey.pending,
      stripeCustomerId: map[UserKey.STRIPECUSTOMERID] ?? '',



    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserKey.USERID: userId,
      UserKey.USERNAME: userName,
      UserKey.EMAIL: email,
      UserKey.PHONENO: phoneNo ?? '',
      UserKey.IMAGE: image,
      UserKey.LOGO: logo,
      UserKey.ADDRESS: address,
      UserKey.WEBSITE: website,
      UserKey.ROLE: role,
      UserKey.BUSINESSID: businessId,
      UserKey.BALANCE: balance ?? 0,
      UserKey.ISPROMOTIONSTART: isPromotionStart ?? false,
      UserKey.ISVERIFIED: isVerified ?? StatusKey.pending,
      UserKey.STRIPECUSTOMERID: stripeCustomerId ?? '',
    };
  }
}