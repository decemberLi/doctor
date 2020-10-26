import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/patient/model/patient_model.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('ucenter');
HttpManager httpDtp = HttpManager('dtp');

class PatientListViewModel extends ViewStateRefreshListModel {
  PatientListViewModel();

  @override
  Future<List<PatientModel>> loadData({int pageNum}) async {
    // var list = await http.post('/past-patient/list', params: {'ps': 10, 'pn': pageNum});
    // return list['records']
    //     .map<PatientModel>((item) => PatientModel.fromJson(item))
    //     .toList();
    List<PatientModel> list = [];
    for (var i = 0; i < 10; i++) {
      String id = '${pageNum - i}';
      PatientModel _model = PatientModel(
        patientUserId: '$id',
        patientName: '张三-$id',
        sex: '1',
        age: 32,
        diagnosisTime: '1603366262120',
        diseaseName: '颈椎病,高血压',
        patientHeaderUrl:
            'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg',
      );
      list.add(_model);
    }
    return Future.delayed(Duration(seconds: 2), () => list);
  }

  Future<bool> bindPrescription({
    String prescriptionNo,
    String patientId,
  }) async {
    // try {
    //   var res = await httpDtp.post('/patient-prescription-bind', params: {
    //     'prescriptionNo': prescriptionNo,
    //     'patientId': patientId,
    //   });
    //   return res;
    // } catch (e) {
    //   return false;
    // }
    print(prescriptionNo);
    return Future.delayed(Duration(seconds: 1), () => true);
  }

  void changeDataNotify() {
    notifyListeners();
  }
}

class PatientDetailModel extends ViewStateRefreshListModel {
  final String patientId;

  PatientDetailModel(this.patientId);

  PatientModel patient;

  @override
  initData() async {
    setBusy();
    patient = await loadPatientDetail();
    await refresh(init: true);
  }

  Future<PatientModel> loadPatientDetail() async {
    // var data = await http.post('/patient/detail', params: {
    //   patientId: patientId,
    // });
    // return PatientModel.fromJson(data);
    return Future.delayed(
      Duration(seconds: 1),
      () => PatientModel(
        patientUserId: '432432',
        patientName: '张三',
        sex: '1',
        age: 32,
        diagnosisTime: '1603366262120',
        diseaseName: '颈椎病,高血压',
        patientHeaderUrl:
            'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg',
      ),
    );
  }

  @override
  Future<List<PrescriptionModel>> loadData({int pageNum}) async {
    // var list = await httpDtp.post('/patient/prescription/list', params: {
    //   patientId: patientId,
    //   'ps': 10,
    //   'pn': pageNum,
    // });
    // return list['records']
    //     .map<PrescriptionModel>((item) => PrescriptionModel.fromJson(item))
    //     .toList();
    List<PrescriptionModel> list = [];
    for (var i = 0; i < 10; i++) {
      int id = pageNum * i;
      List<DrugModel> drugRps = [];
      for (var j = 0; j < 4; j++) {
        String drugId = '$id-$j';
        drugRps.add(
          DrugModel(
            drugId: j + pageNum * i,
            drugName: '特制开菲尔-$drugId',
            producer: '石家庄龙泽制药股份有限公司',
            drugSize: '32',
            drugPrice: 347,
            frequency: '每日一次',
            singleDose: '32',
            doseUnit: '片/次',
            usePattern: '口服',
            quantity: 3,
          ),
        );
      }
      PrescriptionModel _model = PrescriptionModel(
        id: id,
        prescriptionNo: "NO-43243243-$id",
        prescriptionPatientName: '张三-$id',
        clinicalDiagnosis: '脑瘫,高血压-$id',
        prescriptionPatientAge: 23,
        prescriptionPatientSex: 0,
        status: 'WAIT_VERIFY',
        orderStatus: 'DONE',
        drugRps: drugRps,
      );
      list.add(_model);
    }
    return Future.delayed(Duration(seconds: 1), () => list);
  }

  void changeDataNotify() {
    notifyListeners();
  }
}
