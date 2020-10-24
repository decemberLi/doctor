import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/medication/model/drug_model.dart';
import 'package:doctor/pages/prescription/model/prescription_template_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('dtp');

class PrescriptionTemplateViewModel extends ViewStateRefreshListModel {
  PrescriptionTemplateViewModel();

  @override
  Future<List<PrescriptionTemplateModel>> loadData({int pageNum}) async {
    // var list = await http.post('/prescription-template/list', params: {'ps': 10, 'pn': pageNum});
    // return list['records']
    //     .map<PrescriptionTemplateModel>((item) => PrescriptionTemplateModel.fromJson(item))
    //     .toList();
    List<PrescriptionTemplateModel> list = [];
    for (var i = 0; i < 10; i++) {
      String id = '$pageNum - $i';
      PrescriptionTemplateModel _model = PrescriptionTemplateModel(
        id: '$id',
        prescriptionTemplateName: '处方模板-$id',
        clinicalDiagnosis: '脑瘫，高血压-$id',
        drugRp: [
          DrugModel(
            drugId: '$id',
            drugName: '特制开菲尔-$id',
            producer: '石家庄龙泽制药股份有限公司',
            drugSize: '32',
            drugPrice: '347',
            frequency: '每日一次',
            singleDose: '32',
            doseUnit: '片/次',
            usePattern: '口服',
            quantity: '3',
          ),
        ],
      );
      list.add(_model);
    }
    // Future.delayed(Duration(seconds: 2), () => list);
    return list;
  }

  void changeDataNotify() {
    notifyListeners();
  }
}
