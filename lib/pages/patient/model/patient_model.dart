import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

/// 患者model
@JsonSerializable()
class PatientModel {
  /// id
  int patientUserId;

  /// 姓名
  String patientName;

  /// 年龄
  int age;

  /// 性别
  int sex;

  String get sexLabel => sex == 1 ? '男' : '女';

  /// 诊断时间
  num diagnosisTime;

  /// 疾病名称
  String diseaseName;

  List<String> get diseaseNameList => diseaseName?.split(',') ?? [];

  /// 疾病类型
  String diseaseType;

  /// 头像
  String patientHeaderUrl;

  PatientModel({
    this.patientUserId,
    this.patientName,
    this.age,
    this.sex,
    this.diagnosisTime,
    this.diseaseName,
    this.diseaseType,
    this.patientHeaderUrl,
  });
  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
