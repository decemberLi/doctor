import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

/// 开处方主页面viewModel
class PrescriptionViewModel extends ViewStateModel {
  // PrescriptionModel data = PrescriptionModel();
  PrescriptionModel data = PrescriptionModel(attachments: [
    OssFileEntity(
      ossId: '20201026A37A3BC727384B7C995382481D8B79B0',
      name: '测试',
      type: 'PRESCRIPTION_PAPER',
    )
  ]);

  PrescriptionViewModel();

  Future<String> get prescriptionQRCode async {
    String qrCodeUrl = await loadBindQRCode(data.prescriptionNo);
    return qrCodeUrl;
  }

  /// 总价
  double get totalPrice =>
      data.drugRps?.fold(
        0,
        (previousValue, element) => previousValue + element.drugPrice ?? 0,
      ) ??
      0;

  List<String> get clinicaList => this.data.clinicalDiagnosis?.split(',') ?? [];

  set clinicaList(List<String> value) {
    if (value.isEmpty) {
      this.data.clinicalDiagnosis = null;
    } else {
      this.data.clinicalDiagnosis = value.join(',');
    }
  }

  /// 新增临床诊断
  addClinica(String value) {
    List<String> list = this.clinicaList;
    list.add(value);
    this.data.clinicalDiagnosis = list.join(',');
    notifyListeners();
  }

  /// 删除临床诊断
  removeClinica(int index) {
    List<String> list = this.clinicaList;
    list.removeAt(index);
    this.clinicaList = list;
    notifyListeners();
  }

  addByTemplate(PrescriptionTemplateModel data) {
    this.data.clinicalDiagnosis = data.clinicalDiagnosis;
    this.data.drugRps = data.drugRps;
    notifyListeners();
  }

  savePrescription(Function callBack) async {
    this.data.prescriptionNo = null;
    var params = this.data.toJson();
    var res = await addPrescription(params);
    String prescriptionNo = res['prescriptionNo'];
    this.data.prescriptionNo = prescriptionNo;
    if (callBack != null) {
      callBack(prescriptionNo);
    }
    notifyListeners();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方记录viewModel
class PrescriptionListViewModel extends ViewStateRefreshListModel {
  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    var list = await loadPrescriptionList({
      'ps': 10,
      'pn': pageNum,
    });
    return list['records']
        .map<PrescriptionModel>((item) => PrescriptionModel.fromJson(item))
        .toList();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

/// 处方详情viewModel
class PrescriptionDetailModel extends ViewStateModel {
  final String prescriptionNo;
  PrescriptionModel data;

  PrescriptionDetailModel(this.prescriptionNo);

  initData() async {
    setBusy();
    data = await loadData();
    setIdle();
  }

  /// 获取处方详情
  Future<PrescriptionModel> loadData() async {
    var res = await loadPrescriptionDetail({
      'prescriptionNo': this.prescriptionNo,
    });
    return PrescriptionModel.fromJson(res);
  }
}
