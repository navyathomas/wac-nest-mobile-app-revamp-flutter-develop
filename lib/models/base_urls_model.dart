class BaseUrLmodel {
  BaseUrLmodel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory BaseUrLmodel.fromJson(Map<String, dynamic> json) => BaseUrLmodel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data(
      {this.fullImage,
      this.thumbImage,
      this.horoscopeImage,
      this.horoscopeThumbImage,
      this.idProofThumbImage,
      this.houseThumbImage,
      this.successStories,
      this.successStoryThumbnails});

  String? fullImage;
  String? thumbImage;
  String? horoscopeImage;
  String? horoscopeThumbImage;
  String? idProofThumbImage;
  String? houseThumbImage;
  String? successStories;
  String? successStoryThumbnails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      fullImage: json["full_image"],
      thumbImage: json["thumb_image"],
      horoscopeImage: json["horoscope_image"],
      horoscopeThumbImage: json["horoscope_thumb_image"],
      idProofThumbImage: json["user_idproof_thumbnails"],
      houseThumbImage: json["house_thumb_image"],
      successStories: json['success_story'],
      successStoryThumbnails: json['success_story_thumbnails']);
}
