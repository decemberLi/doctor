import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager http = HttpManager('server');

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
