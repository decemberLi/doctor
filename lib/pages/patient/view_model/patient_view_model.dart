import 'package:doctor/http/dtp.dart';
import 'package:doctor/http/ucenter.dart';
import 'package:doctor/pages/patient/model/patient_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:http_manager/api.dart';

class PatientListViewModel extends ViewStateRefreshListModel {
  String patientName;
  PatientListViewModel(this.patientName);
  @override
  Future<List<PatientModel>> loadData({int pageNum}) async {
    var list = await API.shared.ucenter.loadPatientList(
        {'ps': 10, 'pn': pageNum, 'patientName': patientName});
    return list['records']
        .map<PatientModel>((item) => PatientModel.fromJson(item))
        .toList();
  }

  Future<bool> bindPrescription({
    String prescriptionNo,
    int patientUserId,
  }) async {
    try {
      var res = await API.shared.dtp.bindPrescriptionService({
        'prescriptionNo': prescriptionNo,
        'patientUserId': patientUserId,
      });
      return res;
    } catch (e) {
      return false;
    }
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

class PatientDetailModel extends ViewStateRefreshListModel {
  final int patientUserId;

  PatientDetailModel(this.patientUserId);

  PatientModel patient;

  @override
  initData() async {
    setBusy();
    patient = await loadPatientDetail();
    await refresh(init: true);
  }

  Future<PatientModel> loadPatientDetail() async {
    var data = await API.shared.ucenter.loadPatientDetailService(this.patientUserId);
    return PatientModel.fromJson(data);
  }

  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    var list = await API.shared.dtp.loadPatientPrescriptionList({
      'patientUserId': this.patientUserId,
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
