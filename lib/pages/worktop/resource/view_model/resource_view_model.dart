import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:http_manager/manager.dart';


class ResourceDetailViewModel extends ViewStateModel {
  final int resourceId;
  final int learnPlanId;
  final int favoriteId;
  ResourceModel data;

  ResourceDetailViewModel(this.resourceId, this.learnPlanId, this.favoriteId);

  initData() async {
    setBusy();
    try {
      data =
          this.learnPlanId == null ? await loadCollectData() : await loadData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  Future<ResourceModel> loadData() async {
    var data = await API.shared.server.resourceDetail({
      'resourceId': this.resourceId,
      'learnPlanId': this.learnPlanId,
    });
    return ResourceModel.fromJson(data);
  }

  Future<ResourceModel> loadCollectData() async {
    var data = await API.shared.server.favoriteDetail({
      'favoriteId': this.favoriteId, //传入的是favoriteId
    });
    data['attachmentOssId'] = data['resourceOssId']; //收藏详情返回的资源id处理，与学习资料详情同步
    return ResourceModel.fromJson(data);
  }

  Future<ResourceModel> changeOptions(params) async {
    print(data);
    return null;
  }
}
