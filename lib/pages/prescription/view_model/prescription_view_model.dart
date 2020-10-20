import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/prescription_model.dart';
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

  void changeDataNotify() {
    notifyListeners();
  }
}
