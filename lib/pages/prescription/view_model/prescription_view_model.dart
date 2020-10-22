import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager http = HttpManager('server');
HttpManager httpFoundation = HttpManager('foundation');

class PrescriptionViewModel extends ViewStateModel {
  PrescriptionModel data = PrescriptionModel();

  PrescriptionViewModel();

  // initData() async {
  //   setBusy();
  //   try {
  //     data = await loadData();
  //     setIdle();
  //   } catch (e, s) {
  //     setError(e, s);
  //   }
  // }

  // Future<ResourceModel> loadData() async {
  //   var data = await http.post('/resource/detail', params: {
  //     'resourceId': this.resourceId,
  //     'learnPlanId': this.learnPlanId,
  //   });
  //   return ResourceModel.fromJson(data);
  // }

  Future<String> get prescriptionQRCode async {
    String qrCodeUrl = await this.loadQRCode();
    return qrCodeUrl;
  }

  /// 获取绑定二维码
  Future<String> loadQRCode() async {
    // var res = await httpFoundation.post(
    //   '/wechat-accounts/temp-qr-code',
    //   params: {
    //     'bizType': 'PRESCRIPTION_BIND',
    //     'bizId': data.prescriptionNo,
    //   },
    //   ignoreErrorTips: true,
    //   showLoading: false,
    // );
    // return res['qrCodeUrl'];
    String qrCodeUrl = await Future.delayed(
        Duration(seconds: 2),
        () =>
            'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg');
    return qrCodeUrl;
  }

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
    this.data.drugRp = data.drugRp;
    notifyListeners();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}
