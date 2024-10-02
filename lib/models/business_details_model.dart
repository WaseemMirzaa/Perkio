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
      'result': result?.toMap(), // Convert the Result object to Map
      'status': status,
    };
  }
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

  // Convert Result to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'reviews': reviews
          ?.map((review) => review.toMap())
          .toList(), // Convert each Review to Map
    };
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
}
