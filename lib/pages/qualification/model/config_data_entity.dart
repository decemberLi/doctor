import 'package:doctor/widgets/search_widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config_data_entity.g.dart';

/// DISEASE-疾病
/// DEPARTMENTS-科室
/// VISIT_OBJECTIVE-拜访目的
/// SHOP_OBJECTIVE-巡店目的
/// DOCTOR_TITLE-医生职称
/// DOCTOR_PRACTICE_TITLE-易学术执业科室
@JsonSerializable()
class ConfigDataEntity with Search {
  String code;

  String name;

  dynamic children;

  ConfigDataEntity(this.code, this.name, this.children);

  factory ConfigDataEntity.fromJson(Map<String, dynamic> param) =>
      _$ConfigDataEntityFromJson(param);

  factory ConfigDataEntity.create() =>
      _$ConfigDataEntityFromJson(Map<String, dynamic>());

  Map<String, dynamic> toJson() => _$ConfigDataEntityToJson(this);

  @override
  String faceText() => name;
}

@JsonSerializable()
class HospitalEntity with Search {
  String num;
  String hospitalName;
  String address;
  String level;
  String hospitalCode;

  HospitalEntity(
      this.num, this.hospitalName, this.address, this.level, this.hospitalCode);

  factory HospitalEntity.create() =>
      _$HospitalEntityFromJson(Map<String, dynamic>());

  factory HospitalEntity.fromJson(Map<String, dynamic> param) =>
      _$HospitalEntityFromJson(param);

  Map<String, dynamic> toJson() => _$HospitalEntityToJson(this);

  @override
  String faceText() => hospitalName;
}
