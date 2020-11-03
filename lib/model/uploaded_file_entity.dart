import 'package:json_annotation/json_annotation.dart';

part 'uploaded_file_entity.g.dart';

@JsonSerializable()
class UploadFileEntity {
  String ossId;
  String url;
  String ossFileName;


  UploadFileEntity(this.ossId, this.url);

  factory UploadFileEntity.fromJson(Map<String, dynamic> param) =>
      _$UploadFileEntityFromJson(param);

  Map<String, dynamic> toJson() => _$UploadFileEntityToJson(this);
}
