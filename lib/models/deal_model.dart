import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';

class DealModel {
  String? businessId;
  String? dealId;
  String? dealName;
  bool? isPromotionStar;
  String? companyName;
  String? image;
  int? noOfUsedTellNow;
  int? uses;
  int? likes;
  int? views;
  String? location;
  GeoPoint? longLat;
  List<String>? favourites;
  List<String>? dealParams;
  Timestamp? createdAt;
  Map<String, int>? usedBy;
  double? businessRating;
  Map<String, dynamic>? clickHistory; // Added clickHistory

  DealModel({
    this.businessId,
    this.dealId,
    this.dealName,
    this.companyName,
    this.image,
    this.isPromotionStar,
    this.uses,
    this.views,
    this.likes,
    this.noOfUsedTellNow,
    this.location,
    this.longLat,
    this.favourites,
    this.createdAt,
    this.dealParams,
    this.usedBy,
    this.businessRating,
    this.clickHistory, // Added clickHistory
  });

  factory DealModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DealModel(
      dealId: snapshot.id,
      businessId: data[DealKey.BUSINESSID] ?? '',
      dealName: data[DealKey.DEALNAME] ?? '',
      companyName: data[DealKey.COMPANYNAME] ?? '',
      image: data[DealKey.IMAGE] ?? '',
      isPromotionStar: data[DealKey.ISPROMOTIONSTART] ?? false,
      uses: data[DealKey.USES] ?? 0,
      noOfUsedTellNow: data[DealKey.NOOFUSEDTELLNOW] ?? 0,
      likes: data[DealKey.LIKES] ?? 0,
      views: data[DealKey.VIEWS] ?? 0,
      location: data[DealKey.LOCATION] ?? '',
      longLat: data[DealKey.LATLONG] != null ? data[DealKey.LATLONG] as GeoPoint : null,
      favourites: data[DealKey.FAVOURITES] != null ? List<String>.from(data[DealKey.FAVOURITES]) : [],
      dealParams: data[DealKey.DEALPARAMS] != null ? List<String>.from(data[DealKey.DEALPARAMS]) : [],
      createdAt: data[DealKey.CREATEDAT] ?? Timestamp.now(),
      usedBy: data['usedBy'] != null ? Map<String, int>.from(data['usedBy']) : {},
      businessRating: data['businessRating']?.toDouble(),
      clickHistory: data['clickHistory'] != null ? Map<String, dynamic>.from(data['clickHistory']) : {}, // Parse clickHistory
    );
  }

  factory DealModel.fromMap(Map<String, dynamic> map) {
    return DealModel(
      dealId: map[DealKey.DEALID],
      businessId: map[DealKey.BUSINESSID],
      dealName: map[DealKey.DEALNAME],
      companyName: map[DealKey.COMPANYNAME],
      image: map[DealKey.IMAGE],
      isPromotionStar: map[DealKey.ISPROMOTIONSTART] ?? false,
      uses: map[DealKey.USES] ?? 0,
      noOfUsedTellNow: map[DealKey.NOOFUSEDTELLNOW] ?? 0,
      likes: map[DealKey.LIKES] ?? 0,
      views: map[DealKey.VIEWS] ?? 0,
      location: map[DealKey.LOCATION],
      longLat: map[DealKey.LATLONG] != null ? map[DealKey.LATLONG] as GeoPoint : null,
      favourites: map[DealKey.FAVOURITES] != null ? List<String>.from(map[DealKey.FAVOURITES]) : [],
      dealParams: map[DealKey.DEALPARAMS] != null ? List<String>.from(map[DealKey.DEALPARAMS]) : [],
      createdAt: map[DealKey.CREATEDAT] ?? Timestamp.now(),
      usedBy: map['usedBy'] != null ? Map<String, int>.from(map['usedBy']) : {},
      businessRating: map['businessRating']?.toDouble(),
      clickHistory: map['clickHistory'] != null ? Map<String, dynamic>.from(map['clickHistory']) : {}, // Parse clickHistory
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      DealKey.DEALID: dealId ?? '',
      DealKey.BUSINESSID: businessId ?? '',
      DealKey.DEALNAME: dealName ?? '',
      DealKey.COMPANYNAME: companyName ?? '',
      DealKey.IMAGE: image ?? '',
      DealKey.ISPROMOTIONSTART: isPromotionStar ?? false,
      DealKey.USES: uses ?? 0,
      DealKey.NOOFUSEDTELLNOW: noOfUsedTellNow ?? 0,
      DealKey.VIEWS: views ?? 0,
      DealKey.LIKES: likes ?? 0,
      DealKey.LOCATION: location ?? '',
      DealKey.FAVOURITES: favourites ?? [],
      DealKey.DEALPARAMS: dealParams ?? [],
      DealKey.CREATEDAT: createdAt ?? Timestamp.now(),
      'usedBy': usedBy ?? {},
      'businessRating': businessRating ?? null,
      'clickHistory': clickHistory ?? {}, // Include clickHistory
    };

    if (longLat != null) map[DealKey.LATLONG] = longLat!;
    return map;
  }
}
