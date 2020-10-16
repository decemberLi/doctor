import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/provider/view_state_model.dart';

import 'resource_view_model.dart';

class ResourceComponentModel extends ViewStateModel {
  ResourceDetailViewModel model;

  ResourceComponentModel();

  Future<ResourceModel> changeOptions(dataNew, params) async {
    print(dataNew);
    print(params);
    return null;
  }
}
