import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/provider/view_state_model.dart';
import 'package:doctor/provider/view_state_refresh_list_model.dart';
import 'package:http_manager/manager.dart';

// 讲课视频
class LearnRecordingModel extends ViewStateModel {
  final String learnPlanId;
  final String resourceId;
  final bool reLearn;

  LearnRecordingItem data;

  LearnRecordingModel(this.learnPlanId, this.resourceId, this.reLearn);

  initData() async {
    if (this.reLearn) {
      setBusy();
      try {
        data = (await loadData());
        setIdle();
      } catch (e, s) {
        setError(e, s);
      }
    }
  }

  Future<LearnRecordingItem> loadData() async {
    try {
      var data = await API.shared.server.doctorLectureDetail({
        'learnPlanId': this.learnPlanId,
        'resourceId': this.resourceId,
      });
      return LearnRecordingItem.fromJson(data);
    } catch (e) {
      return e;
    }
  }
}
