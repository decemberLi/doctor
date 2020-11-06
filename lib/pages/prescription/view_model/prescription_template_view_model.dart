import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/pages/prescription/service/service.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

class PrescriptionTemplateViewModel extends ViewStateRefreshListModel {
  PrescriptionTemplateViewModel();

  @override
  Future<List<PrescriptionTemplateModel>> loadData({int pageNum}) async {
    var list = await loadPrescriptionTemplateList({
      'ps': 10,
      'pn': pageNum,
    });
    return list['records']
        .map<PrescriptionTemplateModel>(
            (item) => PrescriptionTemplateModel.fromJson(item))
        .toList();
  }

  void changeDataNotify() {
    notifyListeners();
  }
}
