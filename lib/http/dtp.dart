import 'package:http_manager/manager.dart';
import 'host.dart';

extension dtpAPI on API {
  Dtp get dtp => Dtp();
}

class Dtp {
  String get _host => API.shared.defaultHost;

  String get _middle =>
      "/medclouds-dtp/${API.shared.defaultSystem}/${API.shared.defaultClient}";

  favoriteList(int page,{int ps = 10}) async {
    var url = _host + _middle + "/favorite/list";
    var result = await HttpManager.shared.post(url,params: {'pn':page,'ps':ps});
    return result;
  }
}
