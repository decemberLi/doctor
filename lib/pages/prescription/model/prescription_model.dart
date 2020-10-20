import 'package:doctor/model/attacements_model.dart';
import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prescription_model.g.dart';

/// 处方model
@JsonSerializable(explicitToJson: true)
class PrescriptionModel {
  /// 处方id
  int id;

  /// 处方患者姓名
  String prescriptionPatientName;

  /// 处方单号
  String prescriptionNo;

  /// 驳回理由
  String reason;

  /// 处方患者年龄
  String prescriptionPatientAge;

  /// 处方患者性别（0-女，1-男）
  @JsonKey(defaultValue: '1')
  String prescriptionPatientSex;

  /// 临床诊断
  String clinicalDiagnosis;

  /// 药师签名（URL，是一张图片）
  String pharmacist;

  /// 是否复诊患者（0-不是，1-是复诊患者）
  @JsonKey(defaultValue: '1')
  String furtherConsultation;

  /// 状态(药师审核：WAIT_VERIFY-待审核、PASS-通过，REJECT-驳回）
  String status;

  /// 处方药品信息
  List<DrugModel> drugRps;

  /// 处方纸质图片附件信息
  List<AttacementsModel> attachments;
  PrescriptionModel({
    this.id,
    this.prescriptionPatientName,
    this.prescriptionNo,
    this.reason,
    this.prescriptionPatientAge,
    this.prescriptionPatientSex = '1',
    this.clinicalDiagnosis,
    this.pharmacist,
    this.furtherConsultation = '1',
    this.status,
    this.drugRps = const <DrugModel>[],
    this.attachments,
  });
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionModelToJson(this);
}
