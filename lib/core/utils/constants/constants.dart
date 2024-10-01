class UserKey {
  static const String USERID = "userId";
  static const String USERNAME = "userName";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String PHONENO = "phoneNo";
  static const String IMAGE = "image";
  static const String ROLE = "role";
  static const String LATLONG = "latLong";
  static const String WEBSITE = "website";
  static const String BUSINESSID = "businessId";
  static const String LOGO = "logo";
  static const String BALANCE = "balance";
  static const String ISPROMOTIONSTART = 'isPromotionStart';
  static const String ISVERIFIED = 'isVerified';
  static const String STRIPECUSTOMERID = 'stripeCustomerId';
  static const String ADDRESS = 'address';
  static const String VIEWS = 'views';
}

class CollectionsKey {
  static const String USERS = 'users';
  static const String DEALS = 'deals';
  static const String REWARDS = 'reward';
  static const String SETTINGS = 'settings';
  static const String NOTIFICATIONS = 'notifications';
}

class DealKey {
  static const String BUSINESSID = "businessId";
  static const String DEALID = "dealId";
  static const String DEALNAME = "dealName";
  static const String COMPANYNAME = "companyName";
  static const String IMAGE = "image";
  static const String USES = "uses";
  static const String ISPROMOTIONSTART = "isPromotionStart";
  static const String LOCATION = "location";
  static const String FAVOURITES = 'favourites';
  static const String CREATEDAT = 'createdAt';
  static const String DEALPARAMS = 'dealParams';
  static const String LIKES = 'likes';
  static const String VIEWS = 'views';
  static const String NOOFUSEDTELLNOW = 'noOfUsedTellNow';
  static const String LATLONG = "latLong";
}

class RewardKey {
  static const String BUSINESSID = "businessId";
  static const String REWARDID = "rewardId";
  static const String NOOFUSED = "noOfUsed";
  static const String REWARDNAME = "rewardName";
  static const String COMPANYNAME = "companyName";
  static const String REWARDADDRESS = "rewardAddress";
  static const String POINTSTOREDEEM = "pointsToRedeem";
  static const String REWARDLOGO = "rewardLogo";
  static const String CREATEDAT = 'createdAt';
  static const String USES = 'uses';
  static const String REWARDPARAM = 'rewardParam';
  static const String POINTSEARNED = 'pointsEarned';
  static const String ISFAVOURITE = 'isFavourite';
  static const String POINTSPERSCAN = 'pointsPerScan';
  static const String USEDBY = 'usedBy';
}

class NotificationKey {
  static const String NOTIFICATIONID = 'notificationId';
  static const String SENDERID = 'senderId';
  static const String RECEIVERID = 'receiverId';
  static const String NOTIFICATIONTITLE = 'notificationTitle';
  static const String NOTIFICATIONMESSAGE = 'notificationMessage';
  static const String NOTIFICATIONTYPE = 'notificationType';
  static const String EVENTID = 'eventId';
  static const String TIMESTAMP = 'timestamp';
}

class StatusKey {
  static const String verified = 'verified';
  static const String pending = 'pending';
  static const String rejected = 'rejected';
}
