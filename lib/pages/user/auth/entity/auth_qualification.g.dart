part of 'auth_qualification.dart';

AutQualificationEntity _$AuthenticationQualificationFromJson(
    Map<String, dynamic> json) {
  return AutQualificationEntity()
    ..rejectReson = (json['rejectReson'] as String)
    ..qualifications = (json['qualifications'] as List)
        ?.map((e) =>
            e == null ? null : FacePhoto.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AuthenticationQualificationToJson(
        AutQualificationEntity instance) =>
    <String, dynamic>{
      'rejectReson': instance.rejectReson,
      'qualifications':
          instance.qualifications?.map((e) => e?.toJson())?.toList(),
    };
