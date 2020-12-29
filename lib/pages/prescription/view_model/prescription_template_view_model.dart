import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:doctor/http/dtp.dart';
import 'package:http_manager/manager.dart';

class PrescriptionTemplateViewModel extends ViewStateRefreshListModel {
  PrescriptionTemplateViewModel();

  @override
  Future<List<PrescriptionTemplateModel>> loadData({int pageNum}) async {
    var list = await API.shared.dtp.loadPrescriptionTemplateList({
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
