import 'package:doctor/http/http_manager.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/provider/view_state_model.dart';

HttpManager http = HttpManager('server');

class ResourceDetailViewModel extends ViewStateModel {
  final int resourceId;
  final int learnPlanId;

  ResourceModel data;

  ResourceDetailViewModel(this.resourceId, this.learnPlanId);

  initData() async {
    setBusy();
    try {
      data = await loadData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  Future<ResourceModel> loadData() async {
    var data = await http.post('/resource/detail', params: {
      'resourceId': this.resourceId,
      'learnPlanId': this.learnPlanId,
    });
    return ResourceModel.fromJson(data);
  }

  Future<ResourceModel> changeOptions(params) async {
    print(data);
    return null;
  }
}
