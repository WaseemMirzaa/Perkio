class BusniessDetailsModel {
  List<dynamic>? htmlAttributions;
  Result? result;
  String? status;

  BusniessDetailsModel({
    this.htmlAttributions,
    this.result,
    this.status,
  });
}

class Result {
  String? name;
  int? rating;
  List<Review>? reviews;

  Result({
    this.name,
    this.rating,
    this.reviews,
  });
}

class Review {
  String? authorName;
  String? authorUrl;
  String? language;
  String? originalLanguage;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;
  bool? translated;

  Review({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });
}
