import 'package:json_annotation/json_annotation.dart';

part 'drug_model.g.dart';

/// 药品model
@JsonSerializable()
class DrugModel {
  /// 药品id
  String drugId;

  /// 药品名称
  String drugName;

  /// 规格
  String drugSize;

  /// 用药频率
  String frequency;

  /// 单次用量
  String singleDose;

  /// 剂量单位
  String doseUnit;

  /// 给药方式
  String usePattern;

  /// 数量
  String quantity;
  DrugModel(
    this.drugId,
    this.drugName,
    this.drugSize,
    this.frequency,
    this.singleDose,
    this.doseUnit,
    this.usePattern,
    this.quantity,
  );
  factory DrugModel.fromJson(Map<String, dynamic> json) =>
      _$DrugModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrugModelToJson(this);
}
