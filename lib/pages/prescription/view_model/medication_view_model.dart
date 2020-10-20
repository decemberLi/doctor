import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/prescription/model/drug_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';

HttpManager http = HttpManager('dtp');

class MedicationViewModel extends ViewStateRefreshListModel {
  List<DrugModel> cartList = [];

  MedicationViewModel();

  @override
  Future<List<DrugModel>> loadData({int pageNum}) async {
    // var list = await http.post('/drug/list', params: {'ps': 10, 'pn': pageNum});
    // return list['records']
    //     .map<DrugModel>((item) => DrugModel.fromJson(item))
    //     .toList();
    List<DrugModel> list = [];
    for (var i = 0; i < 10; i++) {
      String id = '${pageNum - i}';
      DrugModel _model = DrugModel(
        drugId: '$id',
        drugName: '特制开菲尔-$id',
        producer: '石家庄龙泽制药股份有限公司',
        drugSize: '32',
        drugPrice: '347',
        pictures: [
          'https://oss-dev.e-medclouds.com/Business-attachment/2020-07/100027/21212508-1595338102423.jpg'
        ],
      );
      list.add(_model);
    }
    // Future.delayed(Duration(seconds: 2), () => list);
    return list;
  }
}
