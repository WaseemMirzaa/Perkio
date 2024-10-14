class BusniessDetailsModel {
  List<dynamic>? htmlAttributions;
  Result? result;
  String? status;

  BusniessDetailsModel({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  // Convert BusniessDetailsModel to Map
  Map<String, dynamic> toMap() {
    return {
      'html_attributions': htmlAttributions,
      'result': result?.toMap(),
      'status': status,
    };
  }

  // Create an instance from Map
  factory BusniessDetailsModel.fromMap(Map<String, dynamic> map) {
    return BusniessDetailsModel(
      htmlAttributions: map['html_attributions'] ?? [],
      result: map['result'] != null ? Result.fromMap(map['result']) : null,
      status: map['status'],
    );
  }
}

class Result {
  String? name;
  double? rating;
  List<Review>? reviews;

  Result({
    this.name,
    this.rating,
    this.reviews,
  });

  // Convert Result to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'reviews': reviews?.map((review) => review.toMap()).toList(),
    };
  }

  // Create an instance from Map
  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      name: map['name'],
      rating: map['rating']?.toDouble(),
      reviews: map['reviews'] != null
          ? List<Review>.from(
              map['reviews']?.map((review) => Review.fromMap(review)),
            )
          : null,
    );
  }
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

  // Convert Review to Map
  Map<String, dynamic> toMap() {
    return {
      'author_name': authorName,
      'author_url': authorUrl,
      'language': language,
      'original_language': originalLanguage,
      'profile_photo_url': profilePhotoUrl,
      'rating': rating,
      'relative_time_description': relativeTimeDescription,
      'text': text,
      'time': time,
      'translated': translated,
    };
  }

  // Create an instance from Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      authorName: map['author_name'],
      authorUrl: map['author_url'],
      language: map['language'],
      originalLanguage: map['original_language'],
      profilePhotoUrl: map['profile_photo_url'],
      rating: map['rating'],
      relativeTimeDescription: map['relative_time_description'],
      text: map['text'],
      time: map['time'],
      translated: map['translated'],
    );
  }
}
