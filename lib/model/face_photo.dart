import 'package:json_annotation/json_annotation.dart';

part 'face_photo.g.dart';

@JsonSerializable()
class FacePhoto {
  String ossId;
  String url;
  String name;

  FacePhoto(this.ossId, this.url, this.name);

  factory FacePhoto.fromJson(Map<String, dynamic> json) =>
      _$FacePhotoFromJson(json);

  factory FacePhoto.create() => _$FacePhotoFromJson(Map<String, dynamic>());

  Map<String, dynamic> toJson() => _$FacePhotoToJson(this);
}
