import 'package:json_annotation/json_annotation.dart';

part 'drug_model.g.dart';

/// 药品model
@JsonSerializable()
class DrugModel {
  /// 药品id
  int drugId;

  /// 药品名称
  String drugName;

  /// 药品编号
  String drugNo;

  /// 通用名称
  String generalName;

  /// 国药准字
  String approvalNo;

  /// 剂型
  String drugType;

  /// 药品单价(单位分)
  int drugPrice;

  /// 生产厂家
  String producer;

  /// 图片地址
  List<String> pictures;

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
  num quantity;

  /// 最大用药量
  num purchaseLimit;

  /// 用法用量
  String get useInfo =>
      '${frequency ?? ''}；${singleDose ?? ''}${doseUnit ?? ''}；${usePattern ?? ''}';

  DrugModel({
    this.drugId,
    this.drugName,
    this.drugNo,
    this.generalName,
    this.approvalNo,
    this.drugType,
    this.drugPrice,
    this.producer,
    this.pictures,
    this.drugSize,
    this.frequency,
    this.singleDose,
    this.doseUnit,
    this.usePattern,
    this.quantity,
    this.purchaseLimit
  });
  factory DrugModel.fromJson(Map<String, dynamic> json) =>
      _$DrugModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrugModelToJson(this);
}
