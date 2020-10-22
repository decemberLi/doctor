import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prescription_template_model.g.dart';

/// 药品model
@JsonSerializable(explicitToJson: true)
class PrescriptionTemplateModel {
  String id;

  /// 处方模板名称
  String prescriptionTemplateName;

  /// 临床诊断
  String clinicalDiagnosis;

  /// 处方药品信息
  List<DrugModel> drugRp;

  PrescriptionTemplateModel({
    this.id,
    this.prescriptionTemplateName,
    this.clinicalDiagnosis,
    this.drugRp = const <DrugModel>[],
  });
  factory PrescriptionTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionTemplateModelToJson(this);
}
