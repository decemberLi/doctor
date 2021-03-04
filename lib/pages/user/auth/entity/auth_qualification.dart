import 'package:doctor/model/face_photo.dart';

part 'auth_qualification.g.dart';

class AutQualificationEntity {
  List<FacePhoto> qualifications;
  String rejectReson;

  AutQualificationEntity();

  factory AutQualificationEntity.fromJson(Map<String, dynamic> param) =>
      _$AuthenticationQualificationFromJson(param);

  Map<String, dynamic> toJson() => _$AuthenticationQualificationToJson(this);
}
